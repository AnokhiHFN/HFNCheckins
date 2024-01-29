// EventCell.swift

import UIKit

class EventCell: UITableViewCell {
    // Add any UI elements you want in your cell here
    var titleLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Initialize and configure your UI elements
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        contentView.addSubview(titleLabel)

        // Add constraints as needed
        //titleLabel.translatesAutoresizingMaskIntoConstraints = false
        /*NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])*/
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
