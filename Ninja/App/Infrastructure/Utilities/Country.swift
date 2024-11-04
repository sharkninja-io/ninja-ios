//
//  Country.swift
//  Ninja - Unstable
//
//  Created by Richard Jacobson on 10/13/22.
//

import Foundation

public enum Country: String, CaseIterable {
    case UnitedStates = "United States"
    case Canada
    case Japan // Counts as North America for region server
    
    case China
    
    case Austria
    case Belgium
    case Bulgaria
    case Switzerland
    case Cyprus
    case Czechia
    case Germany
    case Denmark
    case Estonia
    case Spain
    case Finland
    case France
    case UnitedKingdom = "United Kingdom"
    case Greece
    case Croatia
    case Hungary
    case Ireland
    case Iceland
    case Italy
    case Liechtenstein
    case Lithuania
    case Luxembourg
    case Latvia
    case Malta
    case Netherlands
    case Norway
    case Poland
    case Portugal
    case Romania
    case Sweden
    case Slovenia
    case Slovakia
    
    case Other
    
    // MARK: - Computed Properties
    
    /// Two-letter identifier for the country
    var countryCode: String {
        switch self {
        case .UnitedStates:
            return "US"
        case .Canada:
            return "CA"
        case .Japan:
            return "JP"
        case .China:
            return "CN"
        case .Austria:
            return "AU"
        case .Belgium:
            return "BE"
        case .Bulgaria:
            return "BG"
        case .Switzerland:
            return "CH"
        case .Cyprus:
            return "CY"
        case .Czechia:
            return "CZ"
        case .Germany:
            return "DE"
        case .Denmark:
            return "DK"
        case .Estonia:
            return "EE"
        case .Spain:
            return "ES"
        case .Finland:
            return "FI"
        case .France:
            return "FR"
        case .UnitedKingdom:
            return "GB"
        case .Greece:
            return "GR"
        case .Croatia:
            return "HR"
        case .Hungary:
            return "HU"
        case .Ireland:
            return "IE"
        case .Iceland:
            return "IS"
        case .Italy:
            return "IT"
        case .Liechtenstein:
            return "LI"
        case .Lithuania:
            return "LT"
        case .Luxembourg:
            return "LU"
        case .Latvia:
            return "LV"
        case .Malta:
            return "MT"
        case .Netherlands:
            return "NL"
        case .Norway:
            return "NO"
        case .Poland:
            return "PL"
        case .Portugal:
            return "PT"
        case .Romania:
            return "RO"
        case .Sweden:
            return "SE"
        case .Slovenia:
            return "SI"
        case .Slovakia:
            return "SK"
        case .Other:
            return "ZZ" // Should never be used
        }
    }
    
    // TODO: Figure out localization
    /// DO NOT USE UNTIL LOCALIZATION PROCESS IS FINALIZED
    @available(*, deprecated, message: "Do not use until localization process is finished.")
    var localizedName: String {
        switch self {
        case .UnitedStates:
            return Localizable("768685ca582abd0af2fbb57ca37752aa98c9372b").value
        case .Canada:
            return Localizable("cd6a7b8768528485a0dbcd459185091e80dc28ad").value
        case .Japan:
            return Localizable("fcf29f6cad3232704b33e962ef5194fad3b6817b").value
        case .China:
            return Localizable("c5026dd8f7f2472de55291e0f1b04d60e5498a11").value
        case .Austria:
            return Localizable("593905b31972f6ffe58325abf98595caf4ebf458").value
        case .Belgium:
            return Localizable("5cb4c9d828175ed3931ec52305b32f47173a8e04").value
        case .Bulgaria:
            return Localizable("5c77726358c5daf98ad9cdccd0882bca0f718b88").value
        case .Switzerland:
            return Localizable("77dcd849e550afec3c83d38fcc8cbc72c058f4db").value
        case .Cyprus:
            return Localizable("852addab901cbc5699d190285a009d7a7035fb57").value
        case .Czechia:
            return Localizable("045e2f1d6c4d61aaecfd1b2f30f30a9711042768").value
        case .Germany:
            return Localizable("17d53e0e6a68acdf80b78d4f9d868c8736db2cec").value
        case .Denmark:
            return Localizable("89da124e04dfe1ad9946cd37d91a119e1d028898").value
        case .Estonia:
            return Localizable("f0a96da3f86a334cbe8d569110d6545277973859").value
        case .Spain:
            return Localizable("20a8df9b760336178fca425339ec1c7e542a2463").value
        case .Finland:
            return Localizable("c909b138eba89ecfbd86df4c9d170ac78d4a3820").value
        case .France:
            return Localizable("e3772ac4b4db87b4a8dbfa59ef43cd1a8ad29515").value
        case .UnitedKingdom:
            return Localizable("9769121f10f77079b27eb08e9ffa488cbcc37ed0").value
        case .Greece:
            return Localizable("4902a456caa9a4eab463ce526c9df0f6180be184").value
        case .Croatia:
            return Localizable("d7e0453bb4af87006533f4d77ad9546dac533db8").value
        case .Hungary:
            return Localizable("f14e46ce7d094f9326167acc499698128651be85").value
        case .Ireland:
            return Localizable("eb2131ece0efe78ee8bb1ae98af6099114a8df09").value
        case .Iceland:
            return Localizable("b3c92eecf0aa1905086059d9f6d3261d8fb19657").value
        case .Italy:
            return Localizable("ad79ef0f076d3a686ab9738925f4dd2c7e69d7d1").value
        case .Liechtenstein:
            return Localizable("b0ddce0f54c916c106117e280aead4f9c0cbf1df").value
        case .Lithuania:
            return Localizable("74a788cee27d549015a0786732c662e05cdd7567").value
        case .Luxembourg:
            return Localizable("5076721c4060feeb69bd2c3dd9bdce115d5c62f3").value
        case .Latvia:
            return Localizable("c5f5bb3b350774d7cda57104c55fb6c82b7ae7d9").value
        case .Malta:
            return Localizable("1a591a3e91fcb7a47f2c08e9e2e117f39af22078").value
        case .Netherlands:
            return Localizable("fb61c8a8eba24117016597fc7618f38821b16e8f").value
        case .Norway:
            return Localizable("988455e67df7cd81d090ea4bacdc05f39fb7caa5").value
        case .Poland:
            return Localizable("5ff03b7273b1808e5ba852e230991bbf07da703c").value
        case .Portugal:
            return Localizable("a495190bcc2ef4116725616d321016a7def5bd8f").value
        case .Romania:
            return Localizable("d6b897fd145a64fbad36ff7cb1c47a00dcbbe9b6").value
        case .Sweden:
            return Localizable("72ddd2b619af6d6a73febf80f7fcad22495498cd").value
        case .Slovenia:
            return Localizable("d1aa0503612aa4168939b77b59ca74532a11951a").value
        case .Slovakia:
            return Localizable("b6c149c3e00467fba347629a63ed02fed098d061").value
        case .Other:
            return Localizable("6e6a6f2086bb5fe5dbfd17d8d5f502d48759834b").value
        }
    }
    
    var regionServer: CountryRegionSupport.CountryRegionServer {
        switch self {
        case .UnitedStates, .Canada, .Japan:
            return .NorthAmerica
        case .China:
            return .China
        case .Other:
            return .Unknown
        default:
            return .Europe
        }
    }
    
    var phoneNumberCountryCode: Int? {
        switch self {
        case .UnitedStates, .Canada:
            return 1
        case .France:
            return 33
        case .Germany:
            return 49
        case .UnitedKingdom:
            return 44
        default:
            return nil
        }
    }
    
    /**
     A regex string that matches the country's postal code format.
     
     From [Unicode Common Locale Data Repository (CLDR)](https://github.com/unicode-org/cldr/blob/release-26-0-1/common/supplemental/postalCodeData.xml)
     
     Note that the CLDR ceased including postal code regex strings around 2014. The only one missing from their list, then, is Ireland's Eircode, which we've added, ourselves.
     */
    var postalCodeRegex: String {
        switch self {
        case .UnitedStates:
            return #"\d{5}([ \-]\d{4})?"#
        case .Canada:
            return #"[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][ ]?\d[ABCEGHJ-NPRSTV-Z]\d"#
        case .Japan:
            return #"\d{3}-\d{4}"#
        case .China:
            return #"\d{6}"#
        case .Austria:
            return #"\d{4}"#
        case .Belgium:
            return #"\d{4}"#
        case .Bulgaria:
            return #"\d{4}"#
        case .Switzerland:
            return #"\d{4}"#
        case .Cyprus:
            return #"\d{4}"#
        case .Czechia:
            return #"\d{3}[ ]?\d{2}"#
        case .Germany:
            return #"\d{5}"#
        case .Denmark:
            return #"\d{4}"#
        case .Estonia:
            return #"\d{5}"#
        case .Spain:
            return #"\d{5}"#
        case .Finland:
            return #"\d{5}"#
        case .France:
            return #"\d{2}[ ]?\d{3}"#
        case .UnitedKingdom:
            return #"GIR[ ]?0AA|((AB|AL|B|BA|BB|BD|BH|BL|BN|BR|BS|BT|CA|CB|CF|CH|CM|CO|CR|CT|CV|CW|DA|DD|DE|DG|DH|DL|DN|DT|DY|E|EC|EH|EN|EX|FK|FY|G|GL|GY|GU|HA|HD|HG|HP|HR|HS|HU|HX|IG|IM|IP|IV|JE|KA|KT|KW|KY|L|LA|LD|LE|LL|LN|LS|LU|M|ME|MK|ML|N|NE|NG|NN|NP|NR|NW|OL|OX|PA|PE|PH|PL|PO|PR|RG|RH|RM|S|SA|SE|SG|SK|SL|SM|SN|SO|SP|SR|SS|ST|SW|SY|TA|TD|TF|TN|TQ|TR|TS|TW|UB|W|WA|WC|WD|WF|WN|WR|WS|WV|YO|ZE)(\d[\dA-Z]?[ ]?\d[ABD-HJLN-UW-Z]{2}))|BFPO[ ]?\d{1,4}"#
        case .Greece:
            return #"\d{3}[ ]?\d{2}"#
        case .Croatia:
            return #"\d{5}"#
        case .Hungary:
            return #"\d{4}"#
        case .Ireland:
            return #"([AC-FHKNPRTV-Y]{1}[0-9]{2}|D6W)[ ]?[0-9AC-FHKNPRTV-Y]{4}"# // Ireland just started using this Eircode system in 2015. They had no postal codes prior, so this regex is possibly not as well-tested as the others.
        case .Iceland:
            return #"\d{3}"#
        case .Italy:
            return #"\d{5}"#
        case .Liechtenstein:
            return #"(948[5-9])|(949[0-7])"#
        case .Lithuania:
            return #"\d{5}"#
        case .Luxembourg:
            return #"\d{4}"#
        case .Latvia:
            return #"\d{4}"#
        case .Malta:
            return #"[A-Z]{3}[ ]?\d{2,4}"#
        case .Netherlands:
            return #"\d{4}[ ]?[A-Z]{2}"#
        case .Norway:
            return #"\d{4}"#
        case .Poland:
            return #"\d{2}-\d{3}"#
        case .Portugal:
            return #"\d{4}([\-]\d{3})?"#
        case .Romania:
            return #"\d{6}"#
        case .Sweden:
            return #"\d{3}[ ]?\d{2}"#
        case .Slovenia:
            return #"\d{4}"#
        case .Slovakia:
            return #"\d{3}[ ]?\d{2}"#
        case .Other:
            return ".*" // Matches any string
        }
    }
    
    
    // MARK: - Static Properties
    
    static var ninjaSupportedCountries: [Country] {
        return [.UnitedStates, .Canada, .France, .Germany, .UnitedKingdom]
    }
    
    /// All Countries excluding `.Other`
    static var sharkSupportedCountries: [Country] {
        return Country.allCases.dropLast()
    }
    
    /// Array of supported countries in North America.
    ///
    /// Note: Does not include Japan, though robots in Japan are to connect to the North America server.
    static var northAmericanCountries: [Country] {
        return [.UnitedStates, .Canada]
    }
    
    /// .US, .Canada, and .Other
    static var northAmericanCountriesWithOther: [Country] {
        return [.UnitedStates, .Canada, .Other]
    }
    
    /// Array of supported countries in Europe with an additional `.Other` value.
    static var europeanCountries: [Country] {
        return [.Austria, .Belgium, .Bulgaria, .Croatia, .Cyprus, .Czechia, .Denmark, .Estonia, .Finland, .France, .Germany, .Greece, .Hungary, .Iceland, .Ireland, .Italy, .Japan, .Latvia, .Liechtenstein, .Lithuania, .Luxembourg, .Malta, .Netherlands, .Norway, .Poland, .Portugal, .Romania, .Sweden, .Slovenia, .Slovakia, .Other]
    }
    
    
    /// Get the Country item from its name.
    ///
    /// Will successfully return a Country from either a localized name *or* a rawValue. Will return `.Other` if no match is found.
    @available(*, deprecated, message: "Use '.from'")
    static func fromName(_ name: String) -> Country {
        guard let country = Country.allCases.first(where: {$0.localizedName == name || $0.rawValue == name}) else {
            Logger.Error("Failed to find country for name: \(name)")
            return .Other
        }
        return country
    }
    
    /// Get the Country item from its country code.
    ///
    /// Will return `.Other` if no match is found.
    @available(*, deprecated, message: "Use '.from'")
    static func fromCountryCode(_ countryCode: String) -> Country {
        guard let country = Country.allCases.first(where: {$0.countryCode == countryCode}) else {
            Logger.Error("Failed to find country for code: \(countryCode)")
            return .Other
        }
        return country
    }
    
    
    /// Get the Country from either its name, country code, or rawValue.
    ///
    /// Will return `.Other` if no match is found.
    static func from(_ nameOrCode: String) -> Country {
        if let country = Country.allCases.first(where: {$0.localizedName == nameOrCode || $0.rawValue == nameOrCode || $0.countryCode == nameOrCode}) {
            return country
        } else {
            Logger.Error("Provided string does not match the name nor code of any supported country: \(nameOrCode)")
            return .Other
        }
    }
    
    /// Get the current country from the app's cache
    static var current: Country { Country.from(CacheService.shared().getSelectedCountryRegionForUser()) }
}



// MARK: States and Provinces
extension Country {
    enum USRegions: String, CaseIterable {
        case Alaska = "AK"
        case Alabama = "AL"
        case Arkansas = "AR"
        case Arizona = "AZ"
        case California = "CA"
        case Colorado = "CO"
        case Connecticut = "CT"
        case WashingtonDC = "DC"
        case Delaware = "DE"
        case Florida = "FL"
        case Georgia = "GA"
        case Guam = "GU"
        case Hawaii = "HI"
        case Iowa = "IA"
        case Idaho = "ID"
        case Illinois = "IL"
        case Indiana = "IN"
        case Kentucky = "KY"
        case Kansas = "KS"
        case Louisiana = "LA"
        case Massachusetts = "MA"
        case Maryland = "MD"
        case Maine = "ME"
        case Michigan = "MI"
        case Minnesota = "MN"
        case Missouri = "MO"
        case Mississippi = "MS"
        case Montana = "MT"
        case NorthCarolina = "NC"
        case NorthDakota = "ND"
        case Nebraska = "NE"
        case NewHampshire = "NH"
        case NewJersey = "NJ"
        case NewMexico = "NM"
        case NewYork = "NY"
        case Ohio = "OH"
        case Oklahoma = "OK"
        case Oregon = "OR"
        case Pennsylvania = "PA"
        case PuertoRico = "PR"
        case RhodeIsland = "RI"
        case SouthCarolina = "SC"
        case SouthDakota = "SD"
        case Tennessee = "TN"
        case Texas = "TX"
        case Utah = "UT"
        case Virginia = "VA"
        case VirginIslands = "VI"
        case Vermont = "VT"
        case Washington = "WA"
        case Wisconsin = "WI"
        case WestVirgina = "WV"
        case Wyoming = "WY"
        
        // TODO: Localization
        var localizedName: String {
            switch self {
            case .Alaska:
                return "Alaska"
            case .Alabama:
                return "Alabama"
            case .Arkansas:
                return "Arkansas"
            case .Arizona:
                return "Arizona"
            case .California:
                return "California"
            case .Colorado:
                return "Colorado"
            case .Connecticut:
                return "Connecticut"
            case .WashingtonDC:
                return "Washington DC"
            case .Delaware:
                return "Delaware"
            case .Florida:
                return "Florida"
            case .Georgia:
                return "Georgia"
            case .Guam:
                return "Guam"
            case .Hawaii:
                return "Hawaii"
            case .Iowa:
                return "Iowa"
            case .Idaho:
                return "Idaho"
            case .Illinois:
                return "Illinois"
            case .Indiana:
                return "Indiana"
            case .Kentucky:
                return "Kentucky"
            case .Kansas:
                return "Kansas"
            case .Louisiana:
                return "Louisiana"
            case .Massachusetts:
                return "Massachusetts"
            case .Maryland:
                return "Maryland"
            case .Maine:
                return "Maine"
            case .Michigan:
                return "Michigan"
            case .Minnesota:
                return "Minnesota"
            case .Missouri:
                return "Missouri"
            case .Mississippi:
                return "Missippi"
            case .Montana:
                return "Montana"
            case .NorthCarolina:
                return "Norta Carolina"
            case .NorthDakota:
                return "North Dakota"
            case .Nebraska:
                return "Nebraska"
            case .NewHampshire:
                return "New Hampshire"
            case .NewJersey:
                return "New Jersey"
            case .NewMexico:
                return "New Mexico"
            case .NewYork:
                return "New York"
            case .Ohio:
                return "Ohio"
            case .Oklahoma:
                return "Oklahoma"
            case .Oregon:
                return "Oregon"
            case .Pennsylvania:
                return "Pennsylvania"
            case .PuertoRico:
                return "Puerto Rico"
            case .RhodeIsland:
                return "Rhode Island"
            case .SouthCarolina:
                return "South Carolina"
            case .SouthDakota:
                return "South Dakota"
            case .Tennessee:
                return "Tennessee"
            case .Texas:
                return "Texas"
            case .Utah:
                return "Utah"
            case .Virginia:
                return "Virginia"
            case .VirginIslands:
                return "Virgin Islands"
            case .Vermont:
                return "Vermont"
            case .Washington:
                return "Washington"
            case .Wisconsin:
                return "Wisconsin"
            case .WestVirgina:
                return "West Virginia"
            case .Wyoming:
                return "Wyoming"
            }
        }
    }
    
    enum CanadaRegions: String, CaseIterable {
        case Alberta = "AB"
        case BritishColumbia = "BC"
        case Manitoba = "MB"
        case NewBrunswick = "NB"
        case NewFoundLandAndLabrador = "NL"
        case NorthWestTerritories = "NT"
        case NovaScotia = "NS"
        case Nunavut = "NU"
        case Ontario = "ON"
        case PrinceEdwardIsland = "PE"
        case Quebec = "QC"
        case Saskatchewan = "SK"
        case Yukon = "YT"
        
        // TODO: Localization
        var localizedName: String {
            switch self {
            case .Alberta:
                return "Alberta"
            case .BritishColumbia:
                return "British Columbia"
            case .Manitoba:
                return "Manitoba"
            case .NewBrunswick:
                return "New Brunswick"
            case .NewFoundLandAndLabrador:
                return "Newfoundland and Labrado"
            case .NorthWestTerritories:
                return "Northwest Territories"
            case .NovaScotia:
                return "Nova Scotia"
            case .Nunavut:
                return "Nunavut"
            case .Ontario:
                return "Ontario"
            case .PrinceEdwardIsland:
                return "Prince Edward Island"
            case .Quebec:
                return "Quebec"
            case .Saskatchewan:
                return "Saskatchewan"
            case .Yukon:
                return "Yukon"
            }
        }
    }
}
