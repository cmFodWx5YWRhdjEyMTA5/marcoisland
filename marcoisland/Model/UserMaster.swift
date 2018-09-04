//
//  UserMaster.swift
//  marcoisland
//
//  Created by Kalyan Mohan Paul on 9/4/18.
//  Copyright © 2018 Infologic. All rights reserved.
//

import UIKit

import UIKit

class UserMaster: Codable {
    var id :String?
    var device_id :String?
    var mr_full_name :String?
    var mr_salutation :String?
    var mr_fname :String?
    var mr_mname :String?
    var mr_lname :String?
    var mr_telno :String?
    var mr_email :String?
    var mr_extno :String?
    var mr_faxno :String?
    var mr_micano :String?
    var mr_paid_code :String?
    var mr_renter :String?
    var mr_status :String?
    var mr_mtype :String?
    var mr_licenseno :String?
    var mr_valid_from :String?
    var mr_valid_to :String?
    var mr_mailing_address :String?
    var mr_mailing_city :String?
    var mr_mailing_state :String?
    var mr_mailing_country :String?
    var mr_mailing_zip :String?
    var mr_local_address :String?
    var mr_local_city :String?
    var mr_local_state :String?
    var mr_local_country :String?
    var mr_local_zip :String?
    var mr_gen_note :String?
    var mr_profile_image :String?
    var mr_house_owner :String?
    var mr_activation_code :String?
    var checkstatus :String?
    
    init() {
        id = ""
        device_id = ""
        mr_full_name = ""
        mr_salutation = ""
        mr_fname = ""
        mr_mname = ""
        mr_lname = ""
        mr_telno = ""
        mr_email = ""
        mr_extno = ""
        mr_faxno = ""
        mr_micano = ""
        mr_paid_code = ""
        mr_renter = ""
        mr_status = ""
        mr_mtype = ""
        mr_licenseno = ""
        mr_valid_from = ""
        mr_valid_to = ""
        mr_mailing_address = ""
        mr_mailing_city = ""
        mr_mailing_state = ""
        mr_mailing_country = ""
        mr_mailing_zip = ""
        mr_local_address = ""
        mr_local_city = ""
        mr_local_state = ""
        mr_local_country = ""
        mr_local_zip = ""
        mr_gen_note = ""
        mr_profile_image = ""
        mr_house_owner = ""
        mr_activation_code = ""
        checkstatus = ""
    }
    
    func initWithJsonData(jsonData : NSDictionary){
        
        id = jsonData["id"] as? String
        device_id = jsonData["device_id"] as? String
        mr_full_name = jsonData["mr_full_name"] as? String
        mr_salutation = jsonData["mr_salutation"] as? String
        mr_fname = jsonData["mr_fname"] as? String
        mr_mname = jsonData["mr_mname"] as? String
        mr_lname = jsonData["mr_lname"] as? String
        mr_telno = jsonData["mr_telno"] as? String
        mr_email = jsonData["mr_email"] as? String
        mr_extno = jsonData["mr_extno"] as? String
        mr_faxno = jsonData["mr_faxno"] as? String
        mr_micano = jsonData["mr_micano"] as? String
        mr_paid_code = jsonData["mr_paid_code"] as? String
        mr_renter = jsonData["mr_renter"] as? String
        mr_status = jsonData["mr_status"] as? String
        mr_mtype = jsonData["mr_mtype"] as? String
        mr_licenseno = jsonData["mr_licenseno"] as? String
        mr_valid_from = jsonData["mr_valid_from"] as? String
        mr_valid_to = jsonData["post_id"] as? String
        mr_mailing_address = jsonData["mr_mailing_address"] as? String
        mr_mailing_city = jsonData["mr_mailing_city"] as? String
        mr_mailing_state = jsonData["mr_mailing_state"] as? String
        mr_mailing_country = jsonData["mr_mailing_country"] as? String
        mr_mailing_zip = jsonData["mr_mailing_zip"] as? String
        mr_local_address = jsonData["mr_local_address"] as? String
        mr_local_city = jsonData["mr_local_city"] as? String
        mr_local_state = jsonData["mr_local_state"] as? String
        mr_local_country = jsonData["mr_local_country"] as? String
        mr_local_zip = jsonData["mr_local_zip"] as? String
        mr_gen_note = jsonData["mr_gen_note"] as? String
        mr_profile_image = jsonData["mr_profile_image"] as? String
        mr_house_owner = jsonData["mr_house_owner"] as? String
        mr_activation_code = jsonData["mr_activation_code"] as? String
        checkstatus = jsonData["checkstatus"] as? String
    }
    
    func jsonRepresentation() -> String? {
        let dict = [
            "id" : id,
            "device_id" : device_id,
            "mr_full_name" : mr_full_name,
            "mr_salutation" : mr_salutation,
            "mr_fname" : mr_fname,
            "mr_mname" : mr_mname,
            "mr_lname" : mr_lname,
            "mr_telno" : mr_telno,
            "mr_email" : mr_email,
            "mr_extno" : mr_extno,
            "mr_faxno" : mr_faxno,
            "mr_micano" : mr_micano,
            "mr_renter" : mr_renter,
            "mr_status" : mr_status,
            "mr_mtype" : mr_mtype,
            "mr_licenseno" : mr_licenseno,
            "mr_valid_from" : mr_valid_from,
            "mr_mailing_address" : mr_mailing_address,
            "mr_mailing_city" : mr_mailing_city,
            "mr_mailing_state" : mr_mailing_state,
            "mr_mailing_country" : mr_mailing_country,
            "mr_mailing_zip" : mr_mailing_zip,
            "mr_local_address" : mr_local_address,
            "mr_local_city" : mr_local_city,
            "mr_local_state" : mr_local_state,
            "mr_local_country" : mr_local_country,
            "mr_local_zip" : mr_local_zip,
            "mr_gen_note" : mr_gen_note,
            "mr_profile_image" : mr_profile_image,
            "mr_house_owner" : mr_house_owner,
            "mr_activation_code" : mr_activation_code,
            "checkstatus" : checkstatus,
            
            ]
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        var string: String? = nil
        if let aData = jsonData {
            string = String(data: aData, encoding: .utf8)
        }
        return string
    }
}
