import UIKit

class EntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Create a reference to the Start Check-In button
    let startButton = UIButton(type: .system)
    // Define the data source for the picker view
    let batchOptions = ["Batch-1", "Batch-2", "Batch-3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a background image view
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Background") // Replace "Background" with your background image name
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        
        // Create a label
        // Create a label
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "68th Birthday Celebrations of\nPujya Daaji Maharaja" // Use '\n' for line break
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold) // Increase font size
        titleLabel.numberOfLines = 2 // Allow for multiple lines
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = UIColor(named: "buttonColor") // Set the text color to "buttonColor"
        view.addSubview(titleLabel)


        // Create a picker view for Batch
        let batchPickerView = UIPickerView()
        batchPickerView.delegate = self // Set the delegate
        batchPickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(batchPickerView)
        
        // Create a text field for info
        let infoTextField = UITextField()
        infoTextField.isUserInteractionEnabled = true
        infoTextField.translatesAutoresizingMaskIntoConstraints = false
        infoTextField.placeholder = "Enter Info"
        infoTextField.borderStyle = .roundedRect
        view.addSubview(infoTextField)
        
        // Create a button for starting check-in
        // Create a button for starting check-in
        startButton.isUserInteractionEnabled = true
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start Check-In", for: .normal)
        startButton.backgroundColor = UIColor(named: "buttonColor")
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 10
        startButton.addTarget(self, action: #selector(startCheckIn), for: .touchUpInside)
        startButton.isEnabled = false // Initially disable the button
        startButton.alpha = 0.5 // Set the alpha to make it pale
        view.addSubview(startButton)

        
        // Set up constraints for the elements within the view
        // Set up constraints for the elements within the view
        // Create a container view with a background color
        // Create a container view with rounded corners and a background color
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(named: "smallerBackground") // Replace with your desired background color
        containerView.layer.cornerRadius = 15 // Set the corner radius as needed
        containerView.layer.masksToBounds = true // Ensure that content stays within the rounded corners
        view.addSubview(containerView)


        // Add the title label, picker view, text field, and button to the container view
        containerView.addSubview(titleLabel)
        containerView.addSubview(batchPickerView)
        containerView.addSubview(infoTextField)
        containerView.addSubview(startButton)

        // Set up constraints for the elements within the container view
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20) // Adjust as needed
        ])

        // Adjust constraints for items inside the container view
        // (Use containerView as the superview for constraints)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            batchPickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            batchPickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            batchPickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            infoTextField.topAnchor.constraint(equalTo: batchPickerView.bottomAnchor, constant: 2),
            infoTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            infoTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            startButton.topAnchor.constraint(equalTo: infoTextField.bottomAnchor, constant: 10),
            startButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 150),
            startButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Create a "Scan" button
        let scanButton = UIButton(type: .system)
        scanButton.isUserInteractionEnabled = true
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.setTitle("Scan", for: .normal)
        scanButton.backgroundColor = UIColor(named: "buttonColor") // Set the background color
        scanButton.setTitleColor(.white, for: .normal) // Set the text color
        scanButton.layer.cornerRadius = 10 // Set the corner radius as needed
        scanButton.addTarget(self, action: #selector(scanAction), for: .touchUpInside)
        view.addSubview(scanButton)

        // Set up constraints for the "Scan" button
        NSLayoutConstraint.activate([
            scanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70), // Adjust the bottom spacing as needed
            scanButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40), // Adjust the right spacing as needed
            scanButton.widthAnchor.constraint(equalToConstant: 80), // Adjust the width as needed
            scanButton.heightAnchor.constraint(equalToConstant: 40) // Adjust the height as needed
        ])
        
        infoTextField.delegate = self
    }
    
    // MARK: - UIPickerViewDataSource methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Number of columns in the picker view
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return batchOptions.count // Number of rows in the picker view
    }
    
    // MARK: - UIPickerViewDelegate methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return batchOptions[row] // Display the options from the data source
    }
    
    // MARK: - UIPickerViewDelegate methods

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = batchOptions[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "buttonColor")!
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        return attributedTitle
    }
    
    @objc func startCheckIn() {
        // Handle the action when the "Start Check-In" button is tapped
        performSegue(withIdentifier: "CheckInSegue", sender: self)
    }
    
    // Function to handle the "Scan" button tap
    @objc func scanAction() {
        print("Scanning")
    }
}

// MARK: - UITextFieldDelegate methods


// MARK: - UITextFieldDelegate methods

extension EntryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the info text field will have some input after the change
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        startButton.isEnabled = !(updatedText?.isEmpty ?? true)
        startButton.alpha = 1 // Set the alpha to make it normal
        return true
    }
}
