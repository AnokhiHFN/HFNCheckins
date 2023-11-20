import UIKit


protocol QRCodeDelegate: AnyObject {
    func didScanQRCode(_ info: String)
}

class CheckBoxView: UIView {
    var checkBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        return button
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var isChecked: Bool {
        return checkBox.isSelected
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(checkBox)
        addSubview(nameLabel)

        checkBox.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }

    @objc private func checkBoxTapped() {
        checkBox.isSelected.toggle()
    }
}
class QRViewController: UIViewController {

    var info: String? {
        didSet {
            updateCheckboxes()
        }
    }

    var checkboxViews: [CheckBoxView] = []
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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
    }

    private func setupUI() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        // Assuming you have a vertical stack view to contain the checkboxes
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32) // Adjust the constant based on your needs
        ])

        // Example: Create and add CheckboxViews for each data block
        for _ in 1...20 { // Adjust based on the number of data blocks
            let checkboxView = CheckBoxView()
            stackView.addArrangedSubview(checkboxView)
            checkboxViews.append(checkboxView)
        }

        updateCheckboxes()
    }

    private func updateCheckboxes() {
        guard let info = info else { return }

        let dataBlocks = info.components(separatedBy: "|")

        for (index, checkboxView) in checkboxViews.enumerated() {
            // Adjust the range based on the structure of your data
            let startIndex = index * 4
            let endIndex = startIndex + 3

            if endIndex < dataBlocks.count {
                // Example: Display PNR, ID, batch, and Name in the checkbox
                checkboxView.nameLabel.text = "PNR: \(dataBlocks[startIndex + 2])\nID: \(dataBlocks[startIndex + 3])\nBatch: \(dataBlocks[startIndex + 4])\nName: \(dataBlocks[startIndex + 5])"
                checkboxView.checkBox.isSelected = false // Adjust based on your logic
                checkboxView.isHidden = false
            } else {
                // Hide checkbox views that don't have enough data
                checkboxView.isHidden = true
            }
        }
    }
}

