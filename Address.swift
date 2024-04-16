//
//  Address.swift
//  Kifa-Plus (1)
//
//  Created by Testuser on 15/04/24.
//

import SwiftUI

struct Address {
    var recipientName: String
    var line1: String
    var line2: String
    var line3: String
    var cityName: String
    var postalCode: String
    var mobileNumber: String

    // Initialize from a dictionary, typically from Firestore data
    init(dictionary: [String: Any]) {
        self.recipientName = dictionary["recipientName"] as? String ?? ""
        self.line1 = dictionary["line1"] as? String ?? ""
        self.line2 = dictionary["line2"] as? String ?? ""
        self.line3 = dictionary["line3"] as? String ?? ""
        self.cityName = dictionary["cityName"] as? String ?? ""
        self.postalCode = dictionary["postalCode"] as? String ?? ""
        self.mobileNumber = dictionary["mobileNumber"] as? String ?? ""
    }

    var dictionaryRepresentation: [String: Any] {
        return [
            "recipientName": recipientName,
            "line1": line1,
            "line2": line2,
            "line3": line3,
            "cityName": cityName,
            "postalCode": postalCode,
            "mobileNumber": mobileNumber
        ]
    }
}
