import SwiftUI

struct CheckInData: Codable {
    var batch: String
    var abhyasiID: String?
    var fullName: String?
    var phoneNumber: String?
    var emailAddress: String?
    var age: String?
    var gender: String?
    var city: String?
    var state: String?
    var country: String?
    var dorm: String?
    var checkinType: String?
    var timestamp: String?
}
