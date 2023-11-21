import UIKit


protocol QRCodeDelegate: AnyObject {
    func didScanQRCode(_ info: String)
}

class QRViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
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
        print(abhyasis)
        setupUI()
    }
    
    private func setupUI() {
            view.addSubview(titleLabel)
            view.addSubview(subTitleLabel)
            view.addSubview(tableView)

        NSLayoutConstraint.activate([
                    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                    titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
                    subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                    subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

