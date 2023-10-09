import SwiftUI

// Define a protocol for communication between EntryViewController and DormViewController
protocol EmailOrMobileViewControllerDelegate: AnyObject {
    func didSelectBatchEmailMobile(_ batch: String)
}

class EmailOrMobileViewController: UIViewController, CheckInFormDelegate {
    
    weak var delegate: EmailOrMobileViewControllerDelegate?
    var selectedBatch: String? {
        didSet {
            // Update batch when selectedBatch changes
            batch = selectedBatch
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

    func checkinButtonPressed() {
        print("debugging: \(selectedBatch ?? "hello")")
        performSegue(withIdentifier: "CheckinToFinalScreen", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a SwiftUI view
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
            var swiftUIView = SwiftUIView(batch: batchBinding, email: emailBinding, mobile: mobileBinding)
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
