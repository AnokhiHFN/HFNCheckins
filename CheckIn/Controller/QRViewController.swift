import UIKit

protocol QRCodeDelegate: AnyObject {
    func didScanQRCode(_ info: String)
}

class QRViewController: UIViewController {

    var info: String? {
        didSet {
            updateInfoLabel()
        }
    }

    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a UIImageView to display the background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background") // Replace "Background" with the actual image name

        // Ensure the background image scales correctly
        backgroundImage.contentMode = .scaleAspectFill

        // Add the background image view as the main view
        view.addSubview(backgroundImage)
        setupUI()
        print(info)
        

    }

    private func setupUI() {
        view.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])

        updateInfoLabel()
    }

    private func updateInfoLabel() {
        infoLabel.text = info
    }
}
