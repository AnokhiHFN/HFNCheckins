import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

// Define a protocol for communication between EntryViewController and DormViewController
protocol EmailOrMobileViewControllerDelegate: AnyObject {
    func didSelectBatchEmailMobile(_ batch: String)
}

class EmailOrMobileViewController: UIViewController, CheckInFormDelegate {
    
    weak var delegate: EmailOrMobileViewControllerDelegate?
    //var checkInType : String = "None"
    var selectedBatch: String? {
        didSet {
            // Update batch when selectedBatch changes
            batch = selectedBatch
        }
    }
    var givenTitle: String? {
        didSet {
            event = givenTitle
        }
    }
    var givenEmail: String? {
        didSet {
            // Update batch when selectedBatch changes
            email = givenEmail
        }
    }
    var givenMobile: String? {
        didSet {
            // Update batch when selectedBatch changes
            mobile = givenMobile
        }
    }
    @State var batch: String? = "DefaultBatchError" // Provide a default value
    @State var email: String? = "DefaultEmailError" //
    @State var mobile: String? = "DefaultMobileError" //
    @State var event: String? = "DefaultTitleError"

    func checkinButtonPressed(with checkInData: CheckInData) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not authenticated, attempting to sign in anonymously...")
            Auth.auth().signInAnonymously { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    // Handle the error
                    print("Error signing in anonymously: \(error.localizedDescription)")
                } else {
                    // The user is signed in anonymously
                    // Now that the user is signed in, you can proceed to write data to Firestore.
                    self.writeCheckinData(db: Firestore.firestore(), checkInData: checkInData)
                }
            }
            return
        }

        // User is already authenticated, proceed to write data.
        writeCheckinData(db: Firestore.firestore(), checkInData: checkInData)
    }

    func writeCheckinData(db: Firestore, checkInData: CheckInData) {
        var emailPart = ""
        if let email = checkInData.email {
            emailPart = "\(email)"
        }

        var mobilePart = ""
        if let mobile = checkInData.mobile {
            mobilePart = "\(mobile)"
        }

        let docRef = db.collection("events/202311_PM_visit/checkins").document("em-\(emailPart)-\(mobilePart)-\(checkInData.fullName)")

        // Convert CheckInData to a dictionary
        do {
            let data = try checkInData.asDictionary()

            // Show loading indicator or any visual feedback here

            // Write data to local cache first
            docRef.setData(data, merge: true)

            self.performSegue(withIdentifier: "CheckinToFinalScreen", sender: self)
        } catch {
            print("Error converting CheckInData to dictionary: \(error)")
        }
    }




    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color of the back button to "buttonColor"
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(named: "EntryTextColor")
        }
        
        // Create a SwiftUI view
        let eventBinding = Binding<String>(
            get: { self.givenTitle ?? "Invalid Title" },
            set: { self.givenTitle = $0 }
        )
        let batchBinding = Binding<String>(
            get: { self.selectedBatch ?? "dummy" },
            set: { self.selectedBatch = $0 }
        )
        let emailBinding = Binding<String>(
            get: { self.givenEmail ?? "" },
            set: { self.givenEmail = $0 }
        )
        let mobileBinding = Binding<String>(
            get: { self.givenMobile ?? "" },
            set: { self.givenMobile = $0 }
        )
        
        // Create a SwiftUI view with the binding
        if #available(iOS 14.0, *) {
            var swiftUIView = SwiftUIView(event: eventBinding, batch: batchBinding, email: emailBinding, mobile: mobileBinding)
            swiftUIView.delegate = self
            
            // Embed the SwiftUI view within a UIHostingController
            let hostingController = UIHostingController(rootView: swiftUIView)
            
            // Add the UIHostingController as a child view controller
            addChild(hostingController)
            
            // Set the frame for the SwiftUI view
            hostingController.view.frame = view.bounds
            
            // Add the SwiftUI view as a subview
            view.addSubview(hostingController.view)
            
            // Notify the child view controller that it has been added to the parent view controller
            hostingController.didMove(toParent: self)
            
            // Adjust the navigation bar title
            navigationItem.title = "Check-In"
        }
        else {
            // Fallback on earlier versions
            print("Not supported")
        }
    }
}
