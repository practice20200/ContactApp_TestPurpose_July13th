//
//  DetailedIndivisdualViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements

class DetailedIndivisdualViewController: UIViewController {

    var data : Contact?
    var profileImage: UIImage?
    
    lazy var uiView : UIView = {
        let headerView = BaseUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        let imageView = UIImageView(frame: CGRect(x: (headerView.bounds.width-150)/2, y: 25, width: 150, height: 150))
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.bounds.width/2
        imageView.layer.masksToBounds = true
        let configuration = UIImage.SymbolConfiguration(paletteColors:
        [.white])
        
        imageView.image = UIImage(systemName: "person.circle")
        imageView.preferredSymbolConfiguration = configuration
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedImage))
        gesture.numberOfTapsRequired = 1
        
        let contentView = UIView()
        contentView.layer.addSublayer(gradientLayer)
        headerView.bringSubviewToFront(imageView)
        headerView.addSubview(contentView)
        headerView.addSubview(imageView)
        return headerView
    }()
    
    lazy var gradientLayer : CAGradientLayer = {
        let color = CAGradientLayer()
        color.colors = [
        UIColor(red: 50/255.0, green: 150.0/255.0, blue: 150/255.0, alpha: 1.0).cgColor,
          UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 100.0/255.0, alpha: 1.0).cgColor
        ]
        return color
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(AddContactViewControllerCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .secondarySystemBackground
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
      view.addSubview(tableView)
        
      tableView.tableHeaderView = uiView
      tableView.delegate = self
      tableView.dataSource = self
        
      NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ])
        
      let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHandler))
      navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      tableView.frame = view.bounds
      gradientLayer.frame = uiView.bounds
    }
    
    @objc func addHandler(){
      let vc = AddContactViewController()
      navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTappedImage(){
        
    }
    
}




extension DetailedIndivisdualViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}

extension DetailedIndivisdualViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
      return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddContactViewControllerCell
        let item = PersonDataProvider.dataProvider()
        cell.userInputTF.text = item[indexPath.section].1
        cell.userInputTF.textColor = .systemGray2
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleData = PersonDataProvider.dataProvider()
        return titleData[section].0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}



struct PersonDataProvider {
    static func dataProvider() -> [(String, String)] {
        return [
            ("First name", "John"),
            ("Last name", "Smith"),
            ("Email", "test@example.com"),
            ("Phone Number", "1111111111")
        ]
    }
}
