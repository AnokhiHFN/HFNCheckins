import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

// Define a protocol for communication between EntryViewController and DormViewController
protocol BatchSelectionDelegate: AnyObject {
    func didSelectBatch(_ batch: String)
}

protocol ScannerDelegate: AnyObject {
    func didScanCode(_ info: String)
}



class DormViewController: UIViewController, UITextFieldDelegate {

    // Define a delegate property to communicate with DormViewController
    weak var delegate: BatchSelectionDelegate?
    weak var scannerDelegate: ScannerDelegate?
    let infoTextField = UITextField()
    // Property to store the selected batch value
    //var selectedBatch: String?
    var selectedBatch: String? = "hello"
    //var abhyasiID: String?
    var abhyasiID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoTextField.delegate = self
        
        // Set the color of the back button to "buttonColor"
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(named: "backButtonColor")
        }

        // Create a background image view
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Background") // Replace "Background" with your background image name
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        
        // Create a container view with a background color
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(named: "smallerBackground") // Replace with your desired background color
        containerView.layer.cornerRadius = 15 // Set the corner radius as needed
        containerView.layer.masksToBounds = true // Ensure that content stays within the rounded corners
        view.addSubview(containerView)
        
        // Create a label for "Checkin With Abhyasi ID"
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Checkin With Abhyasi ID"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor(named: "YourTextColor") // Set the text color you want
        containerView.addSubview(titleLabel)
        
        // Create a label for "Abhyasi ID:"
        let abhyasiIDLabel = UILabel()
        abhyasiIDLabel.translatesAutoresizingMaskIntoConstraints = false
        abhyasiIDLabel.text = "\(abhyasiID!)"
        abhyasiIDLabel.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(abhyasiIDLabel)
        
        // Create a label for "Batch:"
        let batchLabel = UILabel()
        batchLabel.translatesAutoresizingMaskIntoConstraints = false
        batchLabel.text = "\(selectedBatch!)"
        batchLabel.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(batchLabel)
        
        // Create an info text field with header "Dorm and Berth Allocations"
        
        infoTextField.isUserInteractionEnabled = true
        infoTextField.translatesAutoresizingMaskIntoConstraints = false
        infoTextField.placeholder = "Dorm and Berth Allocations"
        infoTextField.borderStyle = .roundedRect
        containerView.addSubview(infoTextField)
        
        // Create a button for "Cancel"
        let cancelButton = UIButton(type: .system)
        cancelButton.isUserInteractionEnabled = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor(named: "buttonColor") // Set the background color to "buttonColor"
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 10
        // Add a target action for the Cancel button
        // Add a target action for the Cancel button
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)

        containerView.addSubview(cancelButton)
        
        // Create a button for "CheckIn"
        let checkInButton = UIButton(type: .system)
        checkInButton.isUserInteractionEnabled = true
        checkInButton.translatesAutoresizingMaskIntoConstraints = false
        checkInButton.setTitle("CheckIn", for: .normal)
        checkInButton.backgroundColor = UIColor(named: "buttonColor") // Set the background color to "buttonColor"
        checkInButton.setTitleColor(.white, for: .normal)
        checkInButton.layer.cornerRadius = 10
        // Add a target action for the CheckIn button
        checkInButton.addTarget(self, action: #selector(checkInAction), for: .touchUpInside)
        containerView.addSubview(checkInButton)
        
        // Set up constraints for the container view
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250), // Adjust the top spacing as needed
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300) // Adjust the bottom spacing as needed
        ])
        
        // Set up constraints for the UI elements within the container view
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            abhyasiIDLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            abhyasiIDLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            batchLabel.topAnchor.constraint(equalTo: abhyasiIDLabel.bottomAnchor, constant: 20),
            batchLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            infoTextField.topAnchor.constraint(equalTo: batchLabel.bottomAnchor, constant: 20),
            infoTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            infoTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            cancelButton.topAnchor.constraint(equalTo: infoTextField.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 100), // Adjust the width as needed
            cancelButton.heightAnchor.constraint(equalToConstant: 40), // Adjust the height as needed
            
            checkInButton.topAnchor.constraint(equalTo: infoTextField.bottomAnchor, constant: 20),
            checkInButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            checkInButton.widthAnchor.constraint(equalToConstant: 100), // Adjust the width as needed
            checkInButton.heightAnchor.constraint(equalToConstant: 40) // Adjust the height as needed
        ])
    }
    
    // Implement the UITextFieldDelegate method to capture the changing text in real-time
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print("Updated text in infoTextField: \(updatedText)")
            // You can use the updatedText as needed.
        }
        return true
    }

    // Implement the UITextFieldDelegate method to capture the final entered text
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Access the entered text using textField.text
        if let enteredText = textField.text {
            print("Entered text from infoTextField: \(enteredText)")
            // You can use the enteredText as needed, e.g., store it in a variable or send it to another function.
        }
    }
    
    // Function to handle the "Cancel" button tap
    @objc func cancelAction() {
        // Dismiss the current view controller and return to the previous screen
        print("hellooooo")
        self.navigationController?.popViewController(animated: true)

        
    }
    
    // Function to handle the "CheckIn" button tap
    @objc func checkInAction() {
        // Handle the action when the "CheckIn" button is tapped
        guard let abhyasiID = abhyasiID, let selectedBatch = selectedBatch else {
            print("Missing required data for check-in")
            return
        }
        
        let dormAndBerthAllocation = infoTextField.text ?? ""

        let checkInData = CheckInDataID(
            abhyasiId: abhyasiID,
            batch: selectedBatch,
            dormAndBerthAllocation: dormAndBerthAllocation,
            timestamp: "" // Make sure timestamp is defined and set appropriately
        )

        writeCheckinData(checkInData)
    }
    
    // Function to write check-in data to Firestore
        func writeCheckinData(_ checkInData: CheckInDataID) {
            let db = Firestore.firestore()

            let docRef = db.collection("events/202311_PM_visit/checkins").document("\(checkInData.abhyasiId)")

            do {
                var data = try checkInData.asDictionary()


                docRef.setData(data, merge: true) { [self] error in
                    if let error = error {
                        // Handle the error, e.g., show an alert to the user
                        print("Error writing document: \(error)")
                    } else {
                        // Document successfully written
                        print("Document successfully written!")

                        // Continue to your next action, e.g., segue to another screen
                        performSegue(withIdentifier: "DormToCheckinSegue", sender: self)
                    }
                }
            } catch {
                // Handle the error when converting checkInData to a dictionary
                print("Error converting checkInData to dictionary: \(error)")
            }
        }
        
}
