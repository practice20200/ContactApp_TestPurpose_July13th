//
//  HomeViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements
import Firebase

class HomeViewController: UIViewController {
    
    //========== Elements ==========
    private var contactData = [Contact]()
    
    private var reObserver : [DatabaseHandle] = []
    private let refContact = Database.database()

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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHandler))
        navigationItem.rightBarButtonItem = addButton
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ContactDataReader()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
        navigationController?.navigationBar.topItem?.titleView = UIView()
    }

    
    
    
    
    //========== Functions ==========
    func ContactDataReader(){
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        let completed = refContact.reference(withPath: "\(userUID)/Contact").observe(.value) { [weak self] snapshot in
            var newItem: [Contact] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot,
                   let contactItem = Contact(snapshot: snapshot) {
                       newItem.append(contactItem)
                }
            }
            self?.contactData = newItem
            self?.tableView.reloadData()
        }
        reObserver.append(completed)
    }
    
    @objc func addHandler(){
        let vc = AddContactViewController()
        vc.completion = { [weak self] firstName, lastName, emailAddress, number, id in
            self?.contactData.append(Contact(firstName: firstName, lastName: lastName, emailAddress: emailAddress, number: number, id: id))
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension HomeViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailedIndivisdualViewController()
        let passedData = contactData[indexPath.row]
        let convertedData = [passedData.firstName, passedData.lastName, passedData.emailAddress, String(passedData.number),passedData.id]
        vc.data = convertedData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let friend = contactData[indexPath.item]
            friend.ref?.removeValue()
        }
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
        cell.numberLabel.text = "\(item.number)"
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


