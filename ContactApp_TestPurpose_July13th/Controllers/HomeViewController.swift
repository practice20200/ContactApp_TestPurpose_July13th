//
//  HomeViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements

class HomeViewController: UIViewController {
    
    //========== Elements ==========
    var contactData = [Contact]()

    lazy var contactLabel : BaseUILabel = {
        let label = BaseUILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.heightAnchor.constraint(equalToConstant: 75).isActive = true
        return label
    }()
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.backgroundColor = .secondarySystemBackground
        table.register(HomeViewTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    lazy var contentStack : VStack = {
        let stack = VStack()
        stack.addArrangedSubview(contactLabel)
        stack.addArrangedSubview(tableView)
        return stack
    }()

    
    
    
    
    
    //========== Viewa ==========
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(contentStack)
        view.largeContentTitle = "Contact"
        
        let testPerson = Contact(firstName: "FirstName", lastName: "LastName", emailAddress: "test@example.com", number: 1112224444)
        contactData.append(testPerson)
        
        tableView.delegate = self
        tableView.dataSource = self

        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHandler))
//        navigationItem.rightBarButtonItem = addButton
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        parseJSON()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }

    
    
    
    
    //========== Functions ==========
    @objc func addHandler(){
        let vc = AddContactViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}


extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeViewTableViewCell
        let item = contactData[indexPath.row]
        cell.nameLabel.text = "\(item.firstName)" + " " + "\(item.lastName)"
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
