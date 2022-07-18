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
    private var filterData = [Contact]()
    
    private var reObserver : [DatabaseHandle] = []
    private let refContact = Database.database()
    
    
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter initials"
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .done
        return searchBar
    }()

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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(searchBar)
        searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ContactDataReader()
        navigationController?.navigationBar.topItem?.titleView?.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
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
        return contactData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeViewTableViewCell
       let contactDataItem = contactData[indexPath.row]
       cell.configure(with: contactDataItem)
       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}



extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let pretext = searchBar.text{
            searchConatact(query: pretext + text)
        }
        return true
    }
    
    func searchConatact(query: String){
        filterData.removeAll()

        for contact in contactData {
            if contact.firstName.starts(with: query){
                 filterData.append(contact)
            }
        }
        
        if !query.isEmpty{
            let vc = SearchViewController()
            let naVC = UINavigationController(rootViewController: vc)
            vc.filterData = filterData
            searchBar.searchTextField.resignFirstResponder()
            present(naVC, animated: true)
        }
    }
}

