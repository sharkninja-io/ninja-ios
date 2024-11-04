//
//  ProfileRegistrationModel.swift
//  SharkClean
//
//  Created by Rahul Sharma on 5/20/22.
//

import Foundation

class ProfileRegistrationModel {
    
    static let regionDecoderDictionary = [
        Localizable("7288f7f860792ffc8674757bfb095eec1e06ffbf").value: "AK",
        Localizable("d1f92d7475bbcca0ddd4c10b283202094097cb17").value: "AL",
        Localizable("2f717ffad4e1a2d3004e0baccfcd94811f656b81").value: "AR",
        Localizable("ca0b36fec74bc61226adce2b5ce0e8ef6fdca179").value: "AS",
        Localizable("104fd3fd5302e037fb8d66ee6c616a71d0739a71").value: "AZ",
        Localizable("cf386e5831516538d6deaa1383a8556be7abbcc0").value: "CA",
        Localizable("d28817938afa7620caa7ca193af1d89eb260a600").value: "CO",
        Localizable("ec4da38bde58c4d26ca79831546407d832bb94d1").value: "CT",
        Localizable("736cd24f80718d440733a7f213d8d22160de4d25").value: "DC",
        Localizable("5861e4e27cb2e8229df3a1771d6af43842a11781").value: "DE",
        Localizable("30c2d0593c259810fc3d2c445082d53288a6daae").value: "FL",
        Localizable("9113c6c0c1f9cb53e3543b53136ba30c51018373").value: "GA",
        Localizable("f8aa3a934ee38a6c86d1b092624a9c385267d927").value: "GU",
        Localizable("a1be950918f8e8be2f501aaeca8b54710b991768").value: "HI",
        Localizable("08a48bb7c8c615c033c31341bdce379989850a11").value: "IA",
        Localizable("18334cc78787c9bf930719c033735bf066a1783e").value: "ID",
        Localizable("31b9d2eef058fc852ec75440518312fc6b32dcd0").value: "IL",
        Localizable("5d00be2150a7a2970ecf83338644746fe69f68bc").value: "IN",
        Localizable("e3b665d0ff0971078778d9f398f70b738676a22d").value: "KY",
        Localizable("48303ff2b3e9c6f3ad91c4b4cea1dcbc0a240594").value: "KS",
        Localizable("b158e01ef568b1ce1ca5b17708b332408b349379").value: "LA",
        Localizable("d429907f8fad8de61eed79786629c962a0844da0").value: "MA",
        Localizable("1ac1075bc705bc7194b0d33122ad389ecee236bc").value: "MD",
        Localizable("8dc02447c9ff3b05aae5ce821410c9c073d5b42e").value: "ME",
        Localizable("5110b352c6bc056ec40bf3aebc4144eb1ae0e1d8").value: "MI",
        Localizable("60590f7c8d85b8f61da2cfa9e4012d72bcbeb7a5").value: "MN",
        Localizable("d961c47cc1343cad81ba8df0145d5e20aa40ac42").value: "MO",
        Localizable("cba267312d6b70a7e9fef185409aaa5892d5f67c").value: "MS",
        Localizable("8d274fd5e6f969dad778c50080302bc3ea89591e").value: "MT",
        Localizable("8ddbb9fd49d254aced9f96e6d5b82c3634fdf5d4").value: "NC",
        Localizable("3de75cf0d242b2918580cf14d0455a413297f107").value: "ND",
        Localizable("e9c60bb36ae298a90b7e6542c96fa49747a1c025").value: "NE",
        Localizable("b93191caeb102bbd0267f7ada2aedf47d5164b25").value: "NV",
        Localizable("4faca668b323e8715f2386a28f65791202098c13").value: "NH",
        Localizable("4b173294f2264191e273c10c1191a9e69ee069cb").value: "NJ",
        Localizable("596d31179192db9a04414b6b1287ed52e752c052").value: "NM",
        Localizable("3dddf7feb16bf399efe204acf0fee9106ad446eb").value: "NY",
        Localizable("d318c17a6d88eb121b52a65898138c1a7870d9d6").value: "OH",
        Localizable("86daa48a315e1760ee8e56f08e7437f36ef41dcb").value: "OK",
        Localizable("07719acb37acddccec25b239e54ae20e9addfe70").value: "OR",
        Localizable("dff756efe8f5dd0813ab9c374e52c792233eda90").value: "PA",
        Localizable("fe23c52dc2441843aa073092188089600dad336c").value: "PR",
        Localizable("26da45ed0ae82468aea757366cae0b824385fd3a").value: "RI",
        Localizable("ac6a60017b0bf8bff41d9bd208e6ef210c47fbdf").value: "SC",
        Localizable("d9a46c5b8d7ec94a676df8abeecbccc0f5fd9852").value: "SD",
        Localizable("1f4d4cf915125a317b022e23cf724cfca9f080d2").value: "TN",
        Localizable("98125dc77105eee722883e53962bb713d1532fbc").value: "TX",
        Localizable("2ff606f5bbdaacc091df7cb49a15e201040dcd56").value: "UT",
        Localizable("027fb4bdb28984d493fe1f36eee6d83fe2cd8afe").value: "VA",
        Localizable("8415fea7e424041dae7cda45687dbb075a2938b1").value: "VI",
        Localizable("835aef515d0f57a89c1e02e8d5d76d1f7aca580d").value: "VT",
        Localizable("a27a6644654593ac9e5d122b1155ff23752c8073").value: "WA",
        Localizable("52b2489ffd6eceb9bd13b6a8f90eac373db50b35").value: "WI",
        Localizable("f59b0517b9ae9be376d45129b9f0efe5556ac594").value: "WV",
        Localizable("ed190c702e849165fc5300f49c74475a9be25331").value: "WY",
        Localizable("1dc61b1a0602de0eaee9dba7eece9279c2844202").value: "AB",
        Localizable("fc5ee4758f2357946d73adcc3ae5bb129a8b7dd6").value: "BC",
        Localizable("c1a3864793495a3734a5a88d4f8cad25c9c1b709").value: "MB",
        Localizable("33db135d23541baec23d3b7de599ca8260faaa6f").value: "NB",
        Localizable("e80159dbab228f345100e1c320f2719486f33422").value: "NL",
        Localizable("030782bbdd841f6c1ab8b4e0f3b37eb9bc4b7aea").value: "NT",
        Localizable("59a057ae5ed028e105f7684e03d84844301b2e81").value: "NS",
        Localizable("1ecc65841c0dce85f844eb9a3cfb1edce4e7588c").value: "NU",
        Localizable("f9f742e1f653a74c4cd78d7ea283b5556539b96b").value: "ON",
        Localizable("c5d072a967d739b64fe5ebddc1446e2157957ef5").value: "PE",
        Localizable("51603eda87814564a2a3a96b1e126dafbbcb5bdf").value: "QC",
        Localizable("59faf25196a00bb55cf7dcde2fb6e45d9c73e335").value: "SK",
        Localizable("581b4de1ed108e7f02a381da027d79c869f763fe").value: "YT"
    ]
    
    // TODO: Might not need this. Delete when certain.
    static let legacyRegionDecoderDictionary = [
         "7288f7f860792ffc8674757bfb095eec1e06ffbf" : "AK",
         "d1f92d7475bbcca0ddd4c10b283202094097cb17" : "AL",
         "2f717ffad4e1a2d3004e0baccfcd94811f656b81" : "AR",
         "ca0b36fec74bc61226adce2b5ce0e8ef6fdca179" : "AS",
         "104fd3fd5302e037fb8d66ee6c616a71d0739a71" : "AZ",
         "cf386e5831516538d6deaa1383a8556be7abbcc0" : "CA",
         "d28817938afa7620caa7ca193af1d89eb260a600" : "CO",
         "ec4da38bde58c4d26ca79831546407d832bb94d1" : "CT",
         "736cd24f80718d440733a7f213d8d22160de4d25" : "DC",
         "5861e4e27cb2e8229df3a1771d6af43842a11781" : "DE",
         "30c2d0593c259810fc3d2c445082d53288a6daae" : "FL",
         "9113c6c0c1f9cb53e3543b53136ba30c51018373" : "GA",
         "f8aa3a934ee38a6c86d1b092624a9c385267d927" : "GU",
         "a1be950918f8e8be2f501aaeca8b54710b991768" : "HI",
         "08a48bb7c8c615c033c31341bdce379989850a11" : "IA",
         "18334cc78787c9bf930719c033735bf066a1783e" : "ID",
         "31b9d2eef058fc852ec75440518312fc6b32dcd0" : "IL",
         "5d00be2150a7a2970ecf83338644746fe69f68bc" : "IN",
         "e3b665d0ff0971078778d9f398f70b738676a22d" : "KY",
         "48303ff2b3e9c6f3ad91c4b4cea1dcbc0a240594" : "KS",
         "b158e01ef568b1ce1ca5b17708b332408b349379" : "LA",
         "d429907f8fad8de61eed79786629c962a0844da0" : "MA",
         "1ac1075bc705bc7194b0d33122ad389ecee236bc" : "MD",
         "8dc02447c9ff3b05aae5ce821410c9c073d5b42e" : "ME",
         "5110b352c6bc056ec40bf3aebc4144eb1ae0e1d8" : "MI",
         "60590f7c8d85b8f61da2cfa9e4012d72bcbeb7a5" : "MN",
         "d961c47cc1343cad81ba8df0145d5e20aa40ac42" : "MO",
         "cba267312d6b70a7e9fef185409aaa5892d5f67c" : "MS",
         "8d274fd5e6f969dad778c50080302bc3ea89591e" : "MT",
         "8ddbb9fd49d254aced9f96e6d5b82c3634fdf5d4" : "NC",
         "3de75cf0d242b2918580cf14d0455a413297f107" : "ND",
         "e9c60bb36ae298a90b7e6542c96fa49747a1c025" : "NE",
         "b93191caeb102bbd0267f7ada2aedf47d5164b25" : "NV",
         "4faca668b323e8715f2386a28f65791202098c13" : "NH",
         "4b173294f2264191e273c10c1191a9e69ee069cb" : "NJ",
         "596d31179192db9a04414b6b1287ed52e752c052" : "NM",
         "3dddf7feb16bf399efe204acf0fee9106ad446eb" : "NY",
         "d318c17a6d88eb121b52a65898138c1a7870d9d6" : "OH",
         "86daa48a315e1760ee8e56f08e7437f36ef41dcb" : "OK",
         "07719acb37acddccec25b239e54ae20e9addfe70" : "OR",
         "dff756efe8f5dd0813ab9c374e52c792233eda90" : "PA",
         "fe23c52dc2441843aa073092188089600dad336c" : "PR",
         "26da45ed0ae82468aea757366cae0b824385fd3a" : "RI",
         "ac6a60017b0bf8bff41d9bd208e6ef210c47fbdf" : "SC",
         "d9a46c5b8d7ec94a676df8abeecbccc0f5fd9852" : "SD",
         "1f4d4cf915125a317b022e23cf724cfca9f080d2" : "TN",
         "98125dc77105eee722883e53962bb713d1532fbc" : "TX",
         "2ff606f5bbdaacc091df7cb49a15e201040dcd56" : "UT",
         "027fb4bdb28984d493fe1f36eee6d83fe2cd8afe" : "VA",
         "8415fea7e424041dae7cda45687dbb075a2938b1" : "VI",
         "835aef515d0f57a89c1e02e8d5d76d1f7aca580d" : "VT",
         "a27a6644654593ac9e5d122b1155ff23752c8073" : "WA",
         "52b2489ffd6eceb9bd13b6a8f90eac373db50b35" : "WI",
         "f59b0517b9ae9be376d45129b9f0efe5556ac594" : "WV",
         "ed190c702e849165fc5300f49c74475a9be25331" : "WY",
         "1dc61b1a0602de0eaee9dba7eece9279c2844202" : "AB",
         "fc5ee4758f2357946d73adcc3ae5bb129a8b7dd6" : "BC",
         "c1a3864793495a3734a5a88d4f8cad25c9c1b709" : "MB",
         "33db135d23541baec23d3b7de599ca8260faaa6f" : "NB",
         "e80159dbab228f345100e1c320f2719486f33422" : "NL",
         "030782bbdd841f6c1ab8b4e0f3b37eb9bc4b7aea" : "NT",
         "59a057ae5ed028e105f7684e03d84844301b2e81" : "NS",
         "1ecc65841c0dce85f844eb9a3cfb1edce4e7588c" : "NU",
         "f9f742e1f653a74c4cd78d7ea283b5556539b96b" : "ON",
         "c5d072a967d739b64fe5ebddc1446e2157957ef5" : "PE",
         "51603eda87814564a2a3a96b1e126dafbbcb5bdf" : "QC",
         "59faf25196a00bb55cf7dcde2fb6e45d9c73e335" : "SK",
         "581b4de1ed108e7f02a381da027d79c869f763fe" : "YT"
    ]
    
    internal enum FDM4InputModel: String {
        case email_addr
        case first_name
        case email_option
        case cust_name
        case cust_addr
        case cust_city
        case cust_state
        case cust_country
        case cust_zip
        case cust_number
        case auth_token
        case area_code
        case phone_num
    }

    internal struct FDM4OutputModel: Equatable {
        var firstName: String,
        lastName: String,
        emailOption: Bool,
        address: String,
        address2: String,
        city: String,
        state: String,
        country: String,
        zipCode: String,
        custNumber: String?,
        areaCode: String,
        phoneNumber: String
    }
    
    internal enum IntershopInputModel: String { // TODO: Never used?
        case firstName
        case lastName
        case address
        case address2
        case city
        case state
        case country
        case postalCode
        case phoneNumber
    }
    
    internal struct IntershopOutputModel: Equatable {
        var firstName: String,
        lastName: String,
        address: String,
        address2: String,
        city: String,
        state: String,
        country: String,
        zipCode: String,
        phoneNumber: String
    }
    
    
    
    static let emptyFDM4Model = FDM4OutputModel(firstName: "", lastName: "", emailOption: false, address: "", address2: "", city: "", state: "", country: "", zipCode: "", custNumber: nil, areaCode: "", phoneNumber: "")
    
    static let emptyInternshopModel = IntershopOutputModel(firstName: "", lastName: "", address: "", address2: "", city: "", state: "", country: "", zipCode: "", phoneNumber: "")
}
