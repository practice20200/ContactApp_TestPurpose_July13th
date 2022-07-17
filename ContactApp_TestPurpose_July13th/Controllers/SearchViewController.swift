//
//  SearchViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements

class SearchViewController: UIViewController{
    
    public var filterData = [Contact]()

    // ============ Elements ============
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.register(HomeViewTableViewCell.self, forCellReuseIdentifier: "cell")
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
        view.addSubview(notFoundResultLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            notFoundResultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            notFoundResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        updateUI()
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSearcHandler))
        navigationItem.rightBarButtonItem = cancelButton
    }

    
    
    
    

    // ============ Functions ============
    func updateUI(){
        if filterData.isEmpty{
            tableView.isHidden = true
            notFoundResultLabel.isHidden = false
        }
        else {
            tableView.isHidden = false
            notFoundResultLabel.isHidden = true
        }
    }
    
    @objc func cancelSearcHandler(){
        dismiss(animated: true, completion: nil)
    }
    
}


extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailedIndivisdualViewController()
        let passedData = filterData[indexPath.row]
        let convertedData = [passedData.firstName, passedData.lastName, passedData.emailAddress, String(passedData.number),passedData.id]
        vc.data = convertedData
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let friend = filterData[indexPath.item]
            friend.ref?.removeValue()
            navigationController?.dismiss(animated: true)
        }
    }
}

extension SearchViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filterData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeViewTableViewCell
        let filterItemData = filterData[indexPath.row]
        cell.configure(with: filterItemData)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

