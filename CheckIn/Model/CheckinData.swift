import SwiftUI

struct CheckInData: Codable {
    // email or Mobile Checkin
    var batch: String // correct
    var fullName: String // correct
    var mobile: String? // correct
    var email: String? // correct
    var ageGroup: String?
    var gender: String // correct
    var city: String // correct
    var state: String // correct
    var country: String // correct
    var type = "MOBILE_OR_EMAIL" // correct
    var timestamp: String // correct
    var dormAndBerthAllocation: String? // also in QR
    var event = "68th Birthday Celebration of Pujya Daaji Maharaj" // correct
    
    // QR Type special data
    var abhyasiId: String? //correct
    var berthPreference: String? // correct
    var dormPreference: String? // correct
    var eventName: String? // correct
    var orderId: String? // correct
    var pnr: String? // correct
    var regId: String? // correct
    
    
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "Invalid data", code: 0, userInfo: nil)
        }
        return dictionary
    }
    
}

struct CheckInDataID: Codable {

    // QR Type special data
    var abhyasiId: String //correct
    var batch: String // correct
    var dormAndBerthAllocation: String? // correct
    var eventName = "68th Birthday Celebration of Pujya Daaji Maharaj"
    var timestamp: String // correct
    var type = "ABHYASI_ID" // correct
    
    
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "Invalid data", code: 0, userInfo: nil)
        }
        return dictionary
    }
    
}

struct CheckInDataQR: Codable {

    // QR Type special data
    var abhyasiId: String //correct
    var berthPreference: String? // correct
    var dormAndBerthAllocation: String? // correct
    var dormPreference: String?
    var eventName = "68th Birthday Celebration of Pujya Daaji Maharaj"
    var fullName: String // correct
    var orderId = "68th Birthday Celebration of Pujya Daaji Maharaj"
    var pnr: String?
    var regId: String?
    var timestamp: String
    var type = "QR" // correct
    
    
    func asDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "Invalid data", code: 0, userInfo: nil)
        }
        return dictionary
    }
    
}
