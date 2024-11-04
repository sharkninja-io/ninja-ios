//
//  IntershopAPI.swift
//  Intershop
//
//  Created by Tyler Hall on 4/16/20.
//  Copyright © 2020 Tyler Hall. All rights reserved.
//

import Foundation

class IntershopAPI: SimpleAPI {
    
    // EU and GB production servers
    // https://sharkninja.azure-api.net/icm/b2c/SharkNinja-EU-Site/
    // https://sharkninja.azure-api.net/icm/b2c/SharkNinja-GB-Site/
    // subscription key: d2290321efb34f3d99fd76c284091761
    
    // NA UAT (test) servers
    // https://sharkninja-uat.azure-api.net/
    // subscription key: f7a1c4daf0b0442e81539810c8a7f40f
    
    private static var instance: IntershopAPI?
    
    private static var country: String?
    private static var aylaAccessToken: String?
    private static var email: String?
    
    public static func getInstance() -> IntershopAPI {
        guard instance != nil else {
            let EU_PROD = "https://sharkninja.azure-api.net/icm/b2c/SharkNinja-EU-Site/-/"
            let GB_PROD = "https://sharkninja.azure-api.net/icm/b2c/SharkNinja-GB-Site/-/"
            let EU_GB_PROD_SUBKEY = "d2290321efb34f3d99fd76c284091761"
            
            let US_UAT = "https://sharkninja-uat.azure-api.net/icm/b2c/SharkNinja-NA-Site/sharkus/"
            let CA_UAT = "https://sharkninja-uat.azure-api.net/icm/b2c/SharkNinja-NA-Site/sharkca/"
            let NA_UAT_SUBKEY = "f7a1c4daf0b0442e81539810c8a7f40f"
            
            // Currently, we only have regional URL's for Great Britain (GB) and Germany (EU).
            // Not sure if subscription key will ever change, but it can be changed here if needed.
            self.country = CacheService.shared().getSelectedCountryRegionForUser()
            let session = CacheService.shared().getCurrentAppUserSession()
            self.aylaAccessToken = session["access_token"] as? String
            self.email = session["auth_username"] as? String
            
            switch country {
            case "CA":
                instance = IntershopAPI(baseURL: URL(string: CA_UAT)!)
                instance?.subscriptionKey = NA_UAT_SUBKEY
            case "DE":
                instance = IntershopAPI(baseURL: URL(string: EU_PROD)!)
                instance?.subscriptionKey = EU_GB_PROD_SUBKEY
            case "GB":
                instance = IntershopAPI(baseURL: URL(string: GB_PROD)!)
                instance?.subscriptionKey = EU_GB_PROD_SUBKEY
            case "US":
                instance = IntershopAPI(baseURL: URL(string: US_UAT)!)
                instance?.subscriptionKey = NA_UAT_SUBKEY
            default:
                // This will need to change, because by default we will hide Intershop
                instance = IntershopAPI(baseURL: URL(string: EU_PROD)!)
                instance?.subscriptionKey = EU_GB_PROD_SUBKEY
            }
            return instance!
        }
        return instance!
    }

    struct Customer {
        var email: String?
        var firstName: String?
        var lastName: String?
        var phone: String?
        var customerNumber: String?
        var address: Address?
        var products = [Product]()

        init(json: [String: Any?]) {
            self.email = json["email"] as? String
            self.firstName = json["firstName"] as? String
            self.lastName = json["lastName"] as? String
            self.phone = json["phoneHome"] as? String
            self.customerNumber = json["customerNo"] as? String
            
            if let addressDict = json["preferredShipToAddress"] as? [String: Any?] {
                self.address = Address(json: addressDict)
            }
        }
        
        var jsonDict: [String: Any?] {
            var dict = [String: Any?]()
            dict["email"] = email
            dict["firstName"] = firstName
            dict["lastName"] = lastName
            dict["phoneHome"] = phone
            dict["customerNo"] = customerNumber
            return dict
        }
    }

    struct Address {
        var id: String?
        var firstName: String?
        var lastName: String?
        var addressLine1: String?
        var addressLine2: String?
        var countryCode: String?
        var city: String?
        var postalCode: String?
        var state: String?

        private var shipToAddress = true
        private var invoiceToAddress = false

        init(json: [String: Any?]? = nil) {
            self.id = json?["id"] as? String
            self.firstName = json?["firstName"] as? String
            self.lastName = json?["lastName"] as? String
            self.addressLine1 = json?["addressLine1"] as? String
            self.addressLine2 = json?["addressLine2"] as? String
            self.countryCode = json?["countryCode"] as? String
            self.city = json?["city"] as? String
            self.postalCode = json?["postalCode"] as? String
            self.state = json?["state"] as? String
        }
        
        var jsonDict: [String: Any?] {
            var dict = [String: Any?]()
            dict["id"] = id
            dict["firstName"] = firstName
            dict["lastName"] = lastName
            dict["addressLine1"] = addressLine1
            dict["addressLine2"] = addressLine2
            dict["countryCode"] = countryCode
            dict["city"] = city
            dict["postalCode"] = postalCode
            dict["state"] = state
            dict["shipToAddress"] = shipToAddress
            dict["invoiceToAddress"] = invoiceToAddress
            return dict
        }
    }
    
    struct Product {
        var firstName: String?
        var lastName: String?
        var postalCode: String?
        var email: String?
        var productID: String?
        var serialNumber: String?
        var purchaseDate: Date? // 2020-04-13T00:00:0.000Z
        var sellingLocation: String?
        var sellingLocationName: String?    // only used for GB, not sure why?
        var competitions = false
        var offers = false
    
        let dateFormat = "yyyy-MM-dd'T'00:00:0.000'Z'"

        init(json: [String: Any?]? = nil) {
            firstName = json?["firstname"] as? String
            lastName = json?["lastname"] as? String
            postalCode = json?["postalcode"] as? String
            productID = json?["productid"] as? String
            serialNumber = json?["serialnumber"] as? String
            sellingLocation = json?["sellinglocation"] as? String
            sellingLocationName = json?["sellinglocationname"] as? String
            competitions = ((json?["competitions"] as? String) == "true")
            offers = ((json?["offers"] as? String) == "true")

            let df = DateFormatter()
            df.dateFormat = dateFormat
            if let dateStr = json?["purchasedate"] as? String {
                purchaseDate = df.date(from: dateStr) ?? Date()
            }
        }

        var jsonDict: [String: Any?] {
            var dict = [String: Any?]()
            dict["firstname"] = firstName
            dict["lastname"] = lastName
            dict["postalcode"] = postalCode
            dict["email"] = email
            dict["productid"] = productID
            dict["serialnumber"] = serialNumber
            dict["sellinglocation"] = sellingLocation
            dict["sellinglocationname"] = sellingLocationName
            dict["competitions"] = (competitions ? "true" : "false")
            dict["offers"] = (offers ? "true" : "false")

            let df = DateFormatter()
            df.dateFormat = dateFormat
            dict["purchasedate"] = df.string(from: purchaseDate ?? Date())
            
            return dict
        }
    }

    var customer: Customer?

    var authenticationToken: String?
    var subscriptionKey: String = "d2290321efb34f3d99fd76c284091761"
    
    struct Store {
        var name: String?
        var apiName: String?
        
        init(name: String, apiName: String) {
            self.name = name
            self.apiName = apiName
        }
    }
    
    // TODO: Update
    public var allStoresEU: [Store] = [
        Store.init(name: "SharkClean", apiName: "Website"),
        Store.init(name: "Amazon", apiName: "Amazon"),
        Store.init(name: "Other", apiName: "Others")
    ]
    
    public var allStoresUK: [Store] = [
        Store.init(name: "SharkClean", apiName: "Website"),
        Store.init(name: "Amazon", apiName: "Amazon"),
        Store.init(name: "Other", apiName: "Other")
    ]
    
    struct Model {
        var intershopModel: String?     // model that Intershop will accept
        var customerModels: [String]?   // models that customers can enter, will be mapped to Intershop model
        
        init(intershopModel: String, customerModels: [String]) {
            self.intershopModel = intershopModel
            self.customerModels = customerModels
        }
    }
    
    public var allModelsEU: [Model] = [
        // Under customerModels:
        // Left is Internal/Factory (from QR code scan)
        // Right is Customer Facing (what Intershop will accept)
        Model.init(intershopModel: "RV1000SEU", customerModels: ["RV1100S1EU", "RV1000SEU"]),
        Model.init(intershopModel: "RV750EU", customerModels: ["RV750R01EU", "RV750EU"]),
        Model.init(intershopModel: "RV750L00EU", customerModels: ["RV750L00EU"]),
        Model.init(intershopModel: "RV2001WDEU", customerModels: ["RV2001WREU", "RV2001WDEU"]),
        Model.init(intershopModel: "RV2001EU", customerModels: ["RV2001DREU", "RV2001EU"]),
        Model.init(intershopModel: "RV1001AEEU", customerModels: ["RV1101A1EU", "RV1001AEEU"])
    ]
    
    public var allModelsUK: [Model] = [
        // Under customerModels:
        // Left is Internal/Factory (from QR code scan)
        // Right is Customer Facing (what Intershop will accept)
        Model.init(intershopModel: "RV1000SUK", customerModels: ["RV1100S1UK", "RV1000SUK"]),
        Model.init(intershopModel: "RV754UK", customerModels: ["RV754R01UK", "RV754UK"]),
        Model.init(intershopModel: "RV2001WDUK", customerModels: ["RV2001WRUK", "RV2001WDUK"]),
        Model.init(intershopModel: "RV2001UK", customerModels: ["RV2001DRUK", "RV2001UK"]),
        Model.init(intershopModel: "RV1001AEUK", customerModels: ["RV1101A1UK", "RV1001AEUK"])
    ]
    
    internal var overrideAdditionalHTTPHeaders: [String: String?]?
    override internal var additionalHTTPHeaders: [String: String?] {
        if let overrideAdditionalHTTPHeaders = overrideAdditionalHTTPHeaders {
            return overrideAdditionalHTTPHeaders
        }
        if let token = authenticationToken {
            return ["authentication-token": token, "access-token": Self.aylaAccessToken, "Ocp-Apim-Subscription-Key": subscriptionKey]
        } else {
            return ["access-token": Self.aylaAccessToken, "Ocp-Apim-Subscription-Key": subscriptionKey]
        }
    }

    override internal func getJSON(path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        super.getJSON(path: path) { (success, data, response, error) in
            self.checkForAuthToken(response: response)
            completion?(success, data, response, error)
        }
    }
    
    override internal func postJSON(_ json: [String : Any?], withPath path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        super.postJSON(json, withPath: path) { (success, data, response, error) in
            self.checkForAuthToken(response: response)
            completion?(success, data, response, error)
        }
    }

    override internal func putJSON(_ json: [String : Any?], withPath path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        super.putJSON(json, withPath: path) { (success, data, response, error) in
            self.checkForAuthToken(response: response)
            completion?(success, data, response, error)
        }
    }

    private func checkForAuthToken(response: HTTPURLResponse?) {
        if let response = response {
            for (header, value) in response.allHeaderFields {
                if let header = header as? String, header == "authentication-token" {
                    authenticationToken = value as? String
                }
            }
        }
    }
    
    public func getAllStoreNamesEU() -> [String] {
        var storesToReturn: [String] = []
        for store in allStoresEU {
            storesToReturn.append(store.name ?? "")
        }
        return storesToReturn
    }
    
    public func getAllStoreNamesUK() -> [String] {
        var storesToReturn: [String] = []
        for store in allStoresUK {
            storesToReturn.append(store.name ?? "")
        }
        return storesToReturn
    }
    
    public func getAllCountryNamesEU() -> [String] {
        return Country.europeanCountries.map { $0.rawValue }
    }
    
    public func getAllCountryNamesNA() -> [String] {
        return Country.northAmericanCountriesWithOther.map { $0.rawValue }
    }
    
}

extension IntershopAPI {
    
    func createCustomer(login: String, completion: ((Bool) -> Void)? = nil) {
        overrideAdditionalHTTPHeaders = ["Ocp-Apim-Subscription-Key": subscriptionKey] // We have to make sure not to send an access_token or authentication_token when creating the Intershop account
        let dict = ["login": login]
        postJSON(dict, withPath: "customers/basic") { (success, data, response, error) in
            self.overrideAdditionalHTTPHeaders = nil // And then clear the override for the next request
            guard success, let response = response, response.isValid(validStatusCodes: 201..<409) else {
                completion?(false)
                return
            }

            completion?(true)
        }
    }
    
    // MARK: Todo
    private func attemptOnTheFlyCreateCustomer(completion: ((Bool) -> Void)? = nil) {
        if let email = Self.email {
            self.createCustomer(login: email) { (success) in
                if success {
                    self.getCustomerInfo(completion: { (success) in
                        completion?(success)
                    }, attemptOnTheFlyCreateAccount: false)
                } else {
                    completion?(false)
                }
            }
        } else {
            // Not sure how the customer could not have an email at this point, but whatever...
            completion?(false)
        }
    }

    func getCustomerInfo(completion: ((Bool) -> Void)? = nil, attemptOnTheFlyCreateAccount: Bool = true) {
        // We need to kill any existing Interhshop authentication_token before calling this becaues of...reasons.
        authenticationToken = nil
        getJSON(path: "customers/-") { (success, data, response, error) in
            if (success == false) || !(response?.isValid() ?? false) {
                // The idea behind this is...
                // There could be times when we request the customer's info with a valid Ayla token,
                // but for various reasons, their record hasn't been created with Intershop yet,
                // so let's try one last time to transparently create their Intershop account on the fly.
                if (response?.statusCode == 400) && attemptOnTheFlyCreateAccount {
                    self.attemptOnTheFlyCreateCustomer { (success) in
                        completion?(success)
                    }
                } else {
                    completion?(false)
                }
                return
            }

            if let json = data?.jsonObject() {
                self.customer = Customer(json: json)
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }

    func updateCustomer(completion: ((Bool) -> Void)? = nil) {
        guard let customer = customer else {
            completion?(false)
            return
        }
        putJSON(customer.jsonDict, withPath: "customers/-") { (success, data, response, error) in
            guard success, let response = response, response.isValid() else {
                completion?(false)
                return
            }

            if let json = data?.jsonObject() {
                self.customer = Customer(json: json)
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }

    func getAddress(completion: ((Bool) -> Void)? = nil) {
        guard let addressID = customer?.address?.id else {
            completion?(false)
            return
        }

        getJSON(path: "customers/-/addresses/" + addressID) { (success, data, response, error) in
            guard success, let response = response, response.isValid() else {
                completion?(false)
                return
            }

            if let json = data?.jsonObject() {
                self.customer?.address = Address(json: json)
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }

    func updateAddress(newAddress: Address, completion: ((Bool) -> Void)? = nil) {
        guard let addressID = customer?.address?.id else {
            completion?(false)
            return
        }
        let path = "customers/-/addresses/" + addressID
        putJSON(newAddress.jsonDict, withPath: path) { (success, data, response, error) in
            guard success, let response = response, response.isValid() else {
                completion?(false)
                return
            }

            if let json = data?.jsonObject() {
                self.customer?.address = Address(json: json)
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }
    
    func changeEmail(newEmail: String, completion: ((Bool) -> Void)? = nil) {
        guard let customer = customer else {
            completion?(false)
            return
        }
        
        let dict = ["email": newEmail,
                    "firstName": customer.firstName,
                    "lastName": customer.lastName,
                    "phoneHome": customer.phone,
                    "customerNo": customer.customerNumber]

        putJSON(dict, withPath: "customers/-") { (success, data, response, error) in
            guard success, let response = response, response.isValid() else {
                completion?(false)
                return
            }

            if let json = data?.jsonObject() {
                self.customer = Customer(json: json)
                completion?(true)
            } else {
                completion?(false)
            }
        }
    }

    func registerProduct(product: Product, completion: ((Bool, String) -> Void)? = nil) {
        guard customer != nil else {
            completion?(false, "")
            return
        }
        postJSON(product.jsonDict, withPath: "productregistrations/-") { (success, data, response, error) in
            
            guard success, let response = response, response.isValid() else {
                guard let data = data, let stringData = String(data: data, encoding: .utf8) else {
                    completion?(false, "")
                    return
                }
                
                guard let model: ErrorResponseModel = try? stringData.toModel(trim: false) else {
                    completion?(false, "")
                    return
                }
                let error = model.errors?.first?.causes.first?.message ?? ""
                
                completion?(false, error)
                return
            }

            completion?(true, "")
        }
    }

    func getProducts(completion: ((Bool) -> Void)? = nil) {
        getJSON(path: "productregistrations") { (success, data, response, error) in
            guard success, let response = response, response.isValid() else {
                completion?(false)
                return
            }

            if let json = data?.jsonObject(), let products = json["data"] as? [[String: Any?]] {
                IntershopAPI.getInstance().customer?.products.removeAll()
                for productDict in products {
                    let product = Product(json: productDict)
                    IntershopAPI.getInstance().customer?.products.append(product)
                }
            }

            completion?(true)
        }
    }
    
    private struct ErrorResponseModel: Decodable {
        let errors: [Error]?
        struct Error: Decodable {
            let causes: [Cause]
            struct Cause: Decodable {
                let code: String
                let message: String
            }
        }
    }
}

