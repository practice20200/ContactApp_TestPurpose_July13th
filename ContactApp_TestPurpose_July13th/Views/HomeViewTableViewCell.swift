//
//  HomeViewTableViewCell.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements

class HomeViewTableViewCell: UITableViewCell {
    
    lazy var firstProfileImage: BaseUIImageView = {
        let iv = BaseUIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var nameLabel: BaseUILabel = {
        let label = BaseUILabel()
        label.text = "+4"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    lazy var numberLabel: BaseUILabel = {
        let label = BaseUILabel()
        label.text = "+10000000000"
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    
    lazy var leftContent: HStack = {
        let stack = HStack()
        stack.addArrangedSubview(firstProfileImage)
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(numberLabel)
        stack.spacing = 10
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return stack
    }()
    
    lazy var arrowImage: BaseUIImageView = {
        let iv = BaseUIImageView()
        iv.image = UIImage(systemName: "chevron.forward")
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.contentMode = .right
        return iv
    }()
    
    lazy var contentStack: HStack = {
        let stack = HStack()
        stack.addArrangedSubview(leftContent)
        stack.addArrangedSubview(arrowImage)
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return stack
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant:  15),
            contentStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder: ) has not beeb implemented")
    }

}
