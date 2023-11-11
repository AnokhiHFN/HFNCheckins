import UIKit

class EntryViewController: UIViewController,EmailOrMobileViewControllerDelegate,
DormViewControllerDelegate{

    

    var dormViewController: DormViewController?
    var emailOrMobileViewController: EmailOrMobileViewController?
    
    let batchPickerView = UIPickerView()
    let infoTextField = UITextField()
    
    // Create a reference to the Start Check-In button
    let startButton = UIButton(type: .system)
    // Define the data source for the picker view
    let batchOptions = ["Batch-1", "Batch-2", "Batch-3"]


    var segue :String = ""
    var abhayasiID: String = ""
    var email: String?
    var mobile: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a background image view
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Background") // Replace "Background" with your background image name
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        
        // Create a label
        let titleLabel = TitleLabel()
        view.addSubview(titleLabel)
        
        // Create a picker view for Batch
        batchPickerView.delegate = self // Set the delegate
        batchPickerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(batchPickerView)
        
        infoTextField.isUserInteractionEnabled = true
        infoTextField.translatesAutoresizingMaskIntoConstraints = false
        infoTextField.placeholder = "Enter Info"
        infoTextField.borderStyle = .roundedRect
        infoTextField.textColor = UIColor(named: "EntryTextColor")
        view.addSubview(infoTextField)
        
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
    
    @objc func startCheckIn() {
        // Handle the action when the "Start Check-In" button is tapped
        infoTextField.text = ""
        startButton.isEnabled = false
        startButton.alpha = 0.5
        performSegue(withIdentifier: segue, sender: self)
        
    }
    
    // Function to handle the "Scan" button tap
    @objc func scanAction() {
        // Create an instance of the ScannerViewController
        let scannerVC = QRScannerViewController()
        present(scannerVC, animated: true, completion: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DormViewController {
            // Set the delegate and dormViewController properties
            destinationVC.delegate = self
            dormViewController = destinationVC
            destinationVC.selectedBatch = getSelectedBatch()
            destinationVC.abhyasiID = abhayasiID
        }
        if let destinationVC = segue.destination as? EmailOrMobileViewController,
           segue.identifier == "CheckInSegue" {
            print("Preparing for segue to EmailOrMobileViewController")
            destinationVC.selectedBatch = getSelectedBatch()
            if (email != nil) {
                destinationVC.givenEmail = email
            }
            if (mobile != nil){
                destinationVC.givenMobile = mobile
            }
        }
    }

    // MARK: - DormViewControllerDelegate method
    func didSelectBatch(_ batch: String) {
        // Set the selected batch value in DormViewController
        dormViewController?.selectedBatch = batch
        performSegue(withIdentifier: segue, sender: self)
    }
    
    func didSelectBatchEmailMobile(_ batch: String) {
        emailOrMobileViewController?.batch = batch
        performSegue(withIdentifier: segue, sender: self)
    }
}

// MARK: - UIPickerViewDataSource methods

extension EntryViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Number of columns in the picker view
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return batchOptions.count // Number of rows in the picker view
    }
    
    // Method to get the selected batch from the picker
    func getSelectedBatch() -> String? {
        let selectedRow = batchPickerView.selectedRow(inComponent: 0)
        
        // Check if the selectedRow is within the bounds of the batchOptions array
        if selectedRow >= 0 && selectedRow < batchOptions.count {
            return batchOptions[selectedRow]
        } else {
            return nil // Return nil if no valid selection is made
        }
    }
}

// MARK: - UIPickerViewDelegate methods

extension EntryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return batchOptions[row] // Display the options from the data source
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = batchOptions[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "EntryTextColor")!
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        return attributedTitle
    }
}

// MARK: - UITextFieldDelegate methods

extension EntryViewController:
                                    
    UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the info text field will have some input after the change
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        // Enable the startButton only if validID or ValidEmail
        let abhyasiManager = AbhyasiManager(updatedText!)
        
        if (updatedText != nil) == abhyasiManager.isValidEmail(){
            email = updatedText!
            mobile = ""
            startButton.isEnabled = true
            startButton.alpha = 1.0 // Set the alpha to make it normal
            segue = "CheckInSegue"
            
            
        }
        else if (updatedText != nil) == abhyasiManager.isValidNumber() {
            mobile = updatedText!
            print(mobile!)
            email = ""
                startButton.isEnabled = true
                startButton.alpha = 1.0 // Set the alpha to make it normal
            segue = "CheckInSegue"
            
        }
        else if (updatedText != nil) == abhyasiManager.isValidId() {
                abhayasiID = updatedText!
                startButton.isEnabled = true
                startButton.alpha = 1.0 // Set the alpha to make it normal
            segue = "DormSegue"
            
        }
        else {
            startButton.isEnabled = false
            startButton.alpha = startButton.isEnabled ? 1.0 : 0.5 // Set the alpha to make it pale
            segue = "Invalid"

        }
        print("Segue: \(segue)")
        return true
    }
}

