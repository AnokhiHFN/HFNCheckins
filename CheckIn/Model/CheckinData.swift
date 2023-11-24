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
