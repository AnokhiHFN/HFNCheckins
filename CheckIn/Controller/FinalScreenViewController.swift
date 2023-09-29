import UIKit
import SwiftUI

class FinalScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a UIImageView to display the background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background") // Replace "Background" with the actual image name

        // Ensure the background image scales correctly
        backgroundImage.contentMode = .scaleAspectFill

        // Add the background image view as the main view
        view.addSubview(backgroundImage)

        // Create a SwiftUI view for confetti
        let confettiView = ConfettiView(colors: [.red, .blue, .green], number: 50, speed: 2.0)

        // Create a UIHostingController for the SwiftUI view
        let hostingController = UIHostingController(rootView: AnyView(confettiView))

        // Set the frame for the hosting controller's view and make the background clear
        hostingController.view.frame = view.bounds
        hostingController.view.backgroundColor = .clear

        // Add the hosting controller's view on top of the background image
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
