import UIKit

// Create a reusable title label component
class TitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLabel()
    }
    
    private func configureLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        text = "68th Birthday Celebrations of\nPujya Daaji Maharaja" // Use '\n' for line break
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 24, weight: .bold) // Increase font size
        numberOfLines = 2 // Allow for multiple lines
        adjustsFontSizeToFitWidth = true
        textColor = UIColor(named: "EntryTextColor") // Set the text color to "buttonColor"
    }
}
