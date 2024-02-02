import Foundation

class DateUtility {
    static func getCurrentTimestamp() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    static func getCurrentTimestampAsString() -> String {
        let timestamp = getCurrentTimestamp()
        return String(timestamp)
    }
}

