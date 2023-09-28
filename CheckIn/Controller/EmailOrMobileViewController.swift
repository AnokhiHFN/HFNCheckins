import SwiftUI

class EmailOrMobileViewController: UIViewController, CheckInFormDelegate {
    func checkinButtonPressed() {
        print("in the right method")
        performSegue(withIdentifier: "CheckinToFinalScreen", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hellooooo")
        
        // Create a SwiftUI view
        var swiftUIView = SwiftUIView()
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
}
