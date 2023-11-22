import UIKit


protocol QRCodeDelegate: AnyObject {
    func didScanQRCode(_ info: String)
}

class QRViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var checkInButton: UIButton!
    
    var info: String? {
        didSet {
            updateTitle()
            updateSubTitle()
            updateAbhyasiDetailsArray()
        }
    }
    
    var pnr: String? {
        guard let info = info, let secondComponent = info.components(separatedBy: "|").dropFirst().first else { return nil }
        let componentsAfterSecondPipe = info.components(separatedBy: "|")
                                            .dropFirst(2)
                                            .joined(separator: "|")
        let pnrComponents = componentsAfterSecondPipe.components(separatedBy: ";")
        return pnrComponents.first
    }
    
    var abhyasis: String? {
        guard let info = info, let secondComponent = info.components(separatedBy: "|").dropFirst().first else { return nil }
        let componentsAfterSecondPipe = info.components(separatedBy: "|")
                                            .dropFirst(2)
                                            .joined(separator: "|")
        let pnrComponents = componentsAfterSecondPipe.components(separatedBy: ";")
        return pnrComponents.dropFirst().joined(separator: ";")
    }

    var titleText: String? {
        guard let info = info else { return nil }
        let components = info.components(separatedBy: "|")
        return components.first
    }

    var subTitleText: String? {
        guard let info = info, let secondComponent = info.components(separatedBy: "|").dropFirst().first else { return nil }
        return secondComponent
    }

    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var abhyasiDetailsArray: [AbhyasiDetails] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set allowsMultipleSelection to true
        tableView.allowsMultipleSelection = true
        
        // Set the color of the back button to "buttonColor"
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.tintColor = UIColor(named: "EntryTextColor")
        }

        // Create a background image view
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Background") // Replace "Background" with your background image name
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        print(abhyasis)
        setupUI()
        
        // Add Cancel button
                let cancelButton = UIButton(type: .system)
                cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal) // Set text color to white

                cancelButton.backgroundColor = UIColor(named: "SystemButtoncolor") // Set the color for "Test"
        cancelButton.layer.cornerRadius = 15 // Adjust the corner radius as needed
                cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
                view.addSubview(cancelButton)

                // Add CheckIn button
                checkInButton = UIButton(type: .system)
                checkInButton.setTitle("Check In", for: .normal)
        checkInButton.setTitleColor(.white, for: .normal) // Set text color to white

                checkInButton.backgroundColor = UIColor(named: "SystemButtoncolor") // Set the color for "Test"
        checkInButton.layer.cornerRadius = 15 // Adjust the corner radius as needed
        checkInButton.alpha = 0.5 // Set initial alpha to half
        checkInButton.isEnabled = false // Make the button initially inactive
                checkInButton.addTarget(self, action: #selector(checkInButtonTapped), for: .touchUpInside)
                view.addSubview(checkInButton)

                // Set up constraints for buttons
                cancelButton.translatesAutoresizingMaskIntoConstraints = false
                checkInButton.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8), // Adjust as needed
                    cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180),
                    cancelButton.widthAnchor.constraint(equalToConstant: 120), // Adjust the width as needed
                    cancelButton.heightAnchor.constraint(equalToConstant: 40), // Adjust the height as needed

                    checkInButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8), // Adjust as needed
                    checkInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    checkInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180),
                    checkInButton.widthAnchor.constraint(equalToConstant: 120), // Adjust the width as needed
                    checkInButton.heightAnchor.constraint(equalToConstant: 40), // Adjust the height as needed
                ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QRToFinal" {
            print("we will be going to the final screen now")
        }
    }
    
    // Handle Cancel button tap
    @objc func cancelButtonTapped() {
            // Implement Cancel button action
            print("Cancel button tapped")

            if let navigationController = navigationController {
                // Pop to the root view controller
                navigationController.popToRootViewController(animated: true)
            } else {
                // If not embedded in a navigation controller, you might want to handle dismissal
                // Dismiss the current view controller
                dismiss(animated: true, completion: nil)
            }
        }

    // Handle Check In button tap
    @objc func checkInButtonTapped() {
        // Implement Check In button action
        print("Check In button tapped")
        
        // Print details of selected cells
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let details = abhyasiDetailsArray[indexPath.row]
                print("Selected Cell Details:")
                print("Name: \(details.name)")
                print("Batch: \(details.batch)")
                print("AID: \(details.AID)")
                print("RID: \(details.RID)")
                print("----------------------")
            }
        } else {
            print("No cells selected.")
        }
        
        performSegue(withIdentifier: "QRToFinal", sender: self)
    }
    
    private func setupUI() {
            view.addSubview(titleLabel)
            view.addSubview(subTitleLabel)
            view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 10  // Adjust the corner radius as needed
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil // Remove any background view

        NSLayoutConstraint.activate([
                    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                    titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
                    subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                    subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
                    // Adjust the leading and trailing constraints for the tableView
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    tableView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -260)
                ])

            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Set the estimatedRowHeight and rowHeight to automatically adjust the cell height
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        }
    
    private func updateAbhyasiDetailsArray() {
        guard let info = info else { return }

        // Extract data blocks using ";" as the separator
        let dataBlocks = info.components(separatedBy: ";")

        // Filter out any empty strings
        let filteredDataBlocks = dataBlocks.filter { !$0.isEmpty }

        // Parse each data block into AbhyasiDetails and update the array
        abhyasiDetailsArray = filteredDataBlocks.compactMap { dataBlock in
            let components = dataBlock.components(separatedBy: "|")
            guard components.count == 4 else { return nil } // Ensure correct format

            return AbhyasiDetails(RID: components[0].trimmingCharacters(in: .whitespacesAndNewlines),
                                  batch: components[1].trimmingCharacters(in: .whitespacesAndNewlines),
                                  AID: components[2].trimmingCharacters(in: .whitespacesAndNewlines),
                                  name: components[3].trimmingCharacters(in: .whitespacesAndNewlines))
        }

        // Reload the table view to reflect the changes
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abhyasiDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let details = abhyasiDetailsArray[indexPath.row]

            // Set numberOfLines to 0 to allow multiline text
            cell.textLabel?.numberOfLines = 0

            cell.textLabel?.text = """
                Name: \(details.name)
                Batch: \(details.batch)
                AID: \(details.AID)
                RID: \(details.RID)
            """

            return cell
        }
    
    
    // Handle cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection as needed
        // Enable the Check In button when a cell is selected
        checkInButton.isEnabled = true
        checkInButton.alpha = 1.0 // Make the button fully visible
        if let cell = tableView.cellForRow(at: indexPath) {
            // Access the selected cell
            cell.contentView.backgroundColor = UIColor(named: "formColor") ?? UIColor.systemBlue
        }
    }

    // Handle cell deselection
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Handle deselection as needed
        if tableView.indexPathsForSelectedRows == nil {
                    // Disable the Check In button when no cells are selected
                    checkInButton.isEnabled = false
                    checkInButton.alpha = 0.5 // Set the button's alpha to half
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            // Access the deselected cell
            cell.contentView.backgroundColor = UIColor.white // Change background color, or perform other actions
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }

    
    
    // Checkbox tap action
    @objc func checkboxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        // Handle checkbox tap action as needed
    }


    private func setupTitle() {
        view.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        updateTitle()
    }

    private func setupSubTitle() {
        view.addSubview(subTitleLabel)

        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        updateSubTitle()
    }

    private func updateTitle() {
        titleLabel.text = "\(titleText ?? "N/A")"
    }

    private func updateSubTitle() {
        subTitleLabel.text = "\(subTitleText ?? "N/A")"
    }
}

