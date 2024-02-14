import UIKit
import FirebaseFirestore
import FirebaseAuth

class ContainerViewController: UIViewController {

    var eventTitles: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add image in the middle of the screen
        let imageView = UIImageView(image: UIImage(named: "hfn"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 400), // Adjust the width as needed
            imageView.heightAnchor.constraint(equalToConstant: 400) // Adjust the height as needed
        ])

        fetchEvents { [weak self] titles in
            guard let self = self else { return }
            
            self.eventTitles = titles
            
            // Check the number of events and perform the segue accordingly
            if titles.count == 1 {
                // Only one title, directly perform the segue to EntryViewController
                let selectedTitle = titles.first!
                self.performSegue(withIdentifier: "EntrySegue", sender: selectedTitle)
            } else {
                self.performSegue(withIdentifier: "EventSegue", sender: self)
            }
        }
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EntrySegue", let selectedTitle = sender as? String {
            if let entryViewController = segue.destination as? EntryViewController {
                entryViewController.selectedEventTitle = selectedTitle
            }
        }
        if segue.identifier == "EventSegue", let eventListViewController = segue.destination as? EventListViewController {
            // Pass the eventTitles to EventListViewController
            eventListViewController.eventTitles = eventTitles
        }
    }

}
