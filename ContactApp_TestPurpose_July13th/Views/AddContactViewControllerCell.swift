//
//  File.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import Foundation
import UIKit
import Elements

class AddContactViewControllerCell: UITableViewCell{
    
    lazy var userInputTF: BaseUITextField = {
        let tf = BaseUITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "Enter",
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBackground])
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.shadowColor = UIColor.lightGray.cgColor
        tf.autocapitalizationType = .none
        tf.returnKeyType = .continue
        return tf
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userInputTF)
//        contentView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userInputTF.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant:  10),
            userInputTF.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder: ) has not beeb implemented")
    }
    

    
}
