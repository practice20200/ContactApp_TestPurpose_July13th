//
//  DetailedIndivisdualViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements
import SDWebImage
import Firebase
import FirebaseStorage

class DetailedIndivisdualViewController: UIViewController, UINavigationControllerDelegate {

    //================ Elements =================
    public var data = [String]()
    public var urlPath: String?
    private var profileImage: UIImage?
    private var imageView = UIImageView()
    private let refContact = Database.database()
    
    public var completion: ((String, String, String, Int) -> Void)?
    
    lazy var uiView : UIView = {
        let headerView = BaseUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        imageView = UIImageView(frame: CGRect(x: (headerView.bounds.width-150)/2, y: 25, width: 150, height: 150))
        
        //Layout of ImageView in HeaderView
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.bounds.width/2
        imageView.layer.masksToBounds = true
        let configuration = UIImage.SymbolConfiguration(paletteColors:
        [.white])
        imageView.image = UIImage(systemName: "person.circle")
        imageView.preferredSymbolConfiguration = configuration
        
        //Behaviour of ImageView when users tap it to change profile
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedImage))
        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)
        
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
    
    
    
    
    
    //============= Views ================
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
        
        let editBTN = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editHandler))
        navigationItem.rightBarButtonItem = editBTN
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        displayProfileImage()
    }
    
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      tableView.frame = view.bounds
      gradientLayer.frame = uiView.bounds
    }
    
    

    
    
    // ============= Functions ==============
    //Udatecontact information()
    func contactInformationEdit(child: String, section: Int){
        guard (Auth.auth().currentUser?.email) != nil else { return }
        
        let alert = UIAlertController(title: "Change your user name", message:  "Would you like to change this information?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Change", style: .default) { [weak self] _ in
            
            if section == 3 { //the type of phone number is int. Therefore, Make sure to covert String type to int
                guard let modification = alert.textFields?.first?.text , !modification.isEmpty else { return }
                guard let intModification =  Int(modification) else { return }
                self?.uploadEdition(child: child, modification: intModification)
                self?.data[3] = modification
            }else {
                guard let modification = alert.textFields?.first?.text , !modification.isEmpty else { return }
                self?.uploadEdition(child: child, modification: modification)
                self?.data[section] = modification
            }
            self?.tableView.reloadData()
        }
        
        alert.addTextField()
        if section == 3 {
            alert.textFields?.first?.keyboardType = .numberPad //the type of phone number is int. Therefore, let users type number with numberpad
        }else {
            alert.textFields?.first?.keyboardType = .default
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func uploadEdition(child: String, modification: Any){
        guard let user = Auth.auth().currentUser else { return }
        let fireBaseChildName = data[4]

        //Send the created data to firebase
        let ref = refContact.reference(withPath: "\(user.uid)/Contact/\(fireBaseChildName)").child(child)
        ref.setValue(modification)
    }
    
    
    //Update a profile picture
    func displayProfileImage(){
        guard let user = Auth.auth().currentUser else { return }
        let filePath = "\(user.uid)/\(data[4])_profile_picture_url"
        
        //download a new picture
       Storage.storage().reference().child("images/\(filePath)").downloadURL { url, error in
           guard let url = url, error == nil else{
               print("error downloading :\(String(describing: error?.localizedDescription))")
               return }
           DispatchQueue.main.async { [weak self] in
               self?.imageView.sd_setImage(with: url)
               print("displayProfileImage: Image was successfully downloaded")
           }
       }
    }

    
    
    @objc func editHandler(){
      instruction()
    }
    
    func instruction(){
        let alertView = UIAlertController(title: "Edit", message: "Please tap the section where you would like to change your information.", preferredStyle: .actionSheet)
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }
    
    @objc func didTappedImage(){
        presentPhotoActionSheet()
    }
    

}




extension DetailedIndivisdualViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       informationUpdate(indexPath: indexPath)
    }
    
    func informationUpdate(indexPath: IndexPath){
        if indexPath.section == 0{
            contactInformationEdit(child: "firstName", section: 0)
        }else if indexPath.section == 1 {
            contactInformationEdit(child: "lastName", section: 1)
        }else if indexPath.section == 2{
            contactInformationEdit(child: "emailAddress", section: 2)
        }else {
            contactInformationEdit(child: "number", section: 3)
        }
    }
    
    func updateInfromationAlert(indexPath: IndexPath){
        let alertView = UIAlertController(title: "Edit", message: "Would you like to change this contact information??", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            self?.informationUpdate(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(confirmAction)
        alertView.addAction(cancelAction)
        present(alertView, animated: true)
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

        cell.userInputTF.text = data[indexPath.row]
        
        if indexPath.section == 0 {
            cell.userInputTF.text = data[0]
        }else if indexPath.section == 1{
            cell.userInputTF.text = data[1]
        }else if indexPath.section == 2{
            cell.userInputTF.text = data[2]
        }else{
            cell.userInputTF.text = data[3]
        }
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


extension DetailedIndivisdualViewController: UIImagePickerControllerDelegate {

    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select your picture?", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { [weak self] _ in
            self?.presentCamera()
        }

        let selectPhotoAction = UIAlertAction(title: "Choose a photo", style: .default) { [weak self] _ in
            self?.presentPhotoPicker()
        }

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(selectPhotoAction)
        present(actionSheet, animated: true)
    }

    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    
    
    //when users chose
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            print(info)
            guard let selectImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            imageView.image = selectImage
            
            //Upload a new profile picture
            guard let user = Auth.auth().currentUser else { return }
            let filePath = "\(user.uid)/\(data[4])_profile_picture_url"
            confirmModification(filePath: filePath)
    }
    
    func confirmModification(filePath: String){
        let alertView = UIAlertController(title: "Edit Profile picture", message: "Would you like to change your profile picture?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
            //Upload a picture
            guard let image = self?.imageView.image, let data = image.pngData() else { return }
            StorageManager.shared.uploadProfilePicture(with: data, fileName: filePath)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(confirmAction)
        alertView.addAction(cancelAction)
        present(alertView, animated: true)
    }
        
    // users cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



struct PersonDataProvider {
    static func dataProvider() -> [(String, String)] {
        return [
            ("First name", "ex.) John"),
            ("Last name", "ex.) Smith"),
            ("Email", "ex.) test@example.com"),
            ("Phone Number", "ex.) 1111111111")
        ]
    }
}
