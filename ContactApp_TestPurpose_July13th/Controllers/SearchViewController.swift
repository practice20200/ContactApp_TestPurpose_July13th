//
//  SearchViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements

class SearchViewController: UIViewController{
    var completion: ((String, String) -> Void)?
    var users = [[String: String]]()
    var hasFetched = false
    var results = [SearchResult]()
    var pickedUpResult = [Contact]()

    // ============ Elements ============
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for contacts"
        return searchBar
    }()
    
    lazy var instructionLabel : BaseUILabel = {
        let label = BaseUILabel()
        label.text = "Enter an email adress"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.systemGray
        label.textAlignment = .center
        return label
    }()

    lazy var tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(SearchViewControllerCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = UIColor.systemGray6
        table.layer.shadowColor = UIColor.lightGray.cgColor
        table.layer.opacity = 0.8
        return table
    }()

    lazy var notFoundResultLabel : BaseUILabel = {
        let label =  BaseUILabel()
        label.isHidden = true
        label.text = "Not Found"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.systemRed
        label.textAlignment = .center
        return label
    }()


    
    
    // ============ Views ============
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchBar)
        view.addSubview(notFoundResultLabel)
        view.addSubview(tableView)
        view.addSubview(instructionLabel)
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            notFoundResultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            notFoundResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        searchBar.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearcHandler))
        navigationItem.rightBarButtonItem = cancelButton
        navigationController?.navigationBar.topItem?.titleView = searchBar
    }

    
    
    
    

    // ============ Functions ============
    @objc func cancelSearcHandler(){
        dismiss(animated: true, completion: nil)
    }
    
}


extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertView = UIAlertController(title: "Matched", message: "Would you like to search this person?", preferredStyle: .alert)
    
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        let addAction = UIAlertAction(title: "add", style: .default) { _ in
            print("Add a new contact")
        }
    
        alertView.addAction(cancelAction)
        alertView.addAction(addAction)
        self.navigationController?.present(alertView, animated: true, completion: nil)
    }
}

extension SearchViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchViewControllerCell
//        let item = results[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}




extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else{ return }
        results.removeAll()
        
        searchBar.resignFirstResponder()
        
        updateUI()
        print("you found your friend successfully")
        
    }

    func updateUI(){
        if  results.isEmpty{
            instructionLabel.isHidden = true
            notFoundResultLabel.isHidden = false
            tableView.isHidden = true
        }else{
            instructionLabel.isHidden = true
            notFoundResultLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}

