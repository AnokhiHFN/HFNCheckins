import UIKit
import SwiftUI

class FinalScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Create a UIImageView to display the background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Background") // Replace "Background" with the actual image name

        // Ensure the background image scales correctly
        backgroundImage.contentMode = .scaleAspectFill

        // Add the background image view as the main view
        view.addSubview(backgroundImage)

        // Create a SwiftUI view for confetti
        let confettiView = ConfettiView(colors: [.red, .blue, .green], number: 200, speed: 3)

        // Create a UIHostingController for the SwiftUI view
        let hostingController = UIHostingController(rootView: AnyView(confettiView))

        // Set the frame for the hosting controller's view and make the background clear
        hostingController.view.frame = view.bounds
        hostingController.view.backgroundColor = .clear

        // Add the hosting controller's view on top of the background image
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Create a big circle view
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        circleView.center = view.center
        circleView.backgroundColor = UIColor(named: "buttonColor") // Set the background color to your desired color
        circleView.layer.cornerRadius = circleView.frame.width / 2

        // Create a checkmark (tick) view
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmarkView.frame = circleView.bounds
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.tintColor = .white

        // Add the checkmark to the circle view
        circleView.addSubview(checkmarkView)

        // Add the circle view as a subview to the view controller's view
        view.addSubview(circleView)

        // Create a blue button
        let returnButton = UIButton(type: .system)
        returnButton.setTitle("Main Screen", for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        returnButton.setTitleColor(.white, for: .normal)
        returnButton.backgroundColor = UIColor(named: "buttonColor") // Set the background color to "buttonholer"
        returnButton.layer.cornerRadius = 10
        returnButton.frame = CGRect(x: view.frame.midX - 75, y: circleView.frame.maxY + 20, width: 150, height: 40) // Adjusted width

        // Add an action to the button to return to the root view
        returnButton.addTarget(self, action: #selector(returnToRootView), for: .touchUpInside)

        // Add the button to the view
        view.addSubview(returnButton)
    }

    // Action method to return to the root view
    @objc func returnToRootView() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
