//
//  EventListViewController.swift
//  CheckIn
//
//  Created by Anokhi Shah on 23.01.24.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var eventTitles: [String]?
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Set additional properties if needed
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Set up background image
        let backgroundImage = UIImage(named: "Background") // Make sure to add your image to the Assets.xcassets
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        
        // Create and configure the table view
        //tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        // Set corner radius for all four corners
        tableView.layer.cornerRadius = 10
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell") // Register the custom cell
        tableView.backgroundColor = UIColor.clear // Set background color if needed

        // Add the table view to the view hierarchy
        view.addSubview(tableView)

        // Do any additional setup after loading the view.
        // Apply constraints to the table view (adjust these as needed)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300), // Adjust the top padding
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Adjust the left padding
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // Adjust the right padding
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100) // Adjust the bottom padding
         ])

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Add 1 to the count for the title cell
        return (eventTitles?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        // Customize the appearance based on the cell index
        if indexPath.row == 0 {
            // First cell is the title cell
            cell.textLabel?.text = "Select Event"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.textColor = UIColor.black
            cell.contentView.backgroundColor = UIColor(named: "selectEventColor")

        } else {
            // Other cells are event cells
            cell.textLabel?.text = eventTitles?[indexPath.row - 1]
            cell.textLabel?.textColor = UIColor.black
            cell.contentView.backgroundColor = UIColor(named: "eventListColor")

        }
        // Set corner radius for cell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        // Set number of lines to 0 for multiline text
        cell.textLabel?.numberOfLines = 0
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if a row is selected and it is not the title cell
        if indexPath.row > 0, let selectedTitle = eventTitles?[indexPath.row - 1] {
            // Perform the segue to EntryViewController
            UserDefaults.standard.set(selectedTitle, forKey: "SelectedEventTitle")
            performSegue(withIdentifier: "EventToEntry", sender: selectedTitle)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Prevent selection of the title cell
        return indexPath.row == 0 ? nil : indexPath
    }
    
    // ... Additional UITableViewDelegate methods can be implemented as needed
    
    // MARK: - Navigation
    
    // Prepare for segue to pass the selected title
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventToEntry", let selectedTitle = sender as? String {
            if let entryViewController = segue.destination as? EntryViewController {
                entryViewController.selectedEventTitle = selectedTitle
            }
        }
    }
    
}
