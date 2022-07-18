//
//  MyProfileViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-17.
//

import UIKit
import Elements
import FirebaseStorage
import Firebase

class MyProfileViewController: UIViewController, UINavigationControllerDelegate {

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .secondarySystemBackground
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    
    
    
    
    //============= Views ================
    override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
        
      // set uer information
      userData()
      
      view.addSubview(tableView)

      tableView.tableHeaderView = uiView
      tableView.delegate = self
      tableView.dataSource = self
        
      NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100)
      ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        displayProfileImage()
        navigationController?.navigationBar.topItem?.titleView?.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      tableView.frame = view.bounds
      gradientLayer.frame = uiView.bounds
      
    }
    
    

    
    
    // ============= Functions ==============
    func userData(){
        let user = UserDefaults.standard

        guard let firstName = user.value(forKey: "firstName") as? String,
              let lastName = user.value(forKey: "lastName") as? String,
              let email = user.value(forKey: "email") as? String,
              let phoneNumber = user.value(forKey: "phoneNumber") as? String,
              let user =  Auth.auth().currentUser
        else  { return }
        
        data = [ firstName, lastName, email, phoneNumber, user.uid ]
    }
    
    
    //Udatecontact information()
    func contactInformationEdit(key: String, section: Int){
        
        let alert = UIAlertController(title: "Edit your name", message:  "Would you like to change this information?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Change", style: .default) { [weak self] _ in
            
            guard let modification = alert.textFields?.first?.text , !modification.isEmpty else { return }
            self?.uploadEdition(key: key, section: section, modification: modification)
            self?.data[section] = modification

            self?.tableView.reloadData()
        }
        
        alert.addTextField()
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func uploadEdition(key: String, section: Int, modification: Any){
//        let fireBaseChildName = data[4]

        //Modify the information in local device
        let userDefault = UserDefaults.standard
        if section == 0{
            userDefault.setValue(modification, forKey: key)
        }else {
            userDefault.setValue(modification, forKey: key)
        }
        
 
        //Modify the information in firebase(database0
        editAuthentificateInFirebase(key: key, section: section, modification: modification)
   
    }
    
    func editAuthentificateInFirebase(key: String, section: Int, modification: Any){
        guard let user = Auth.auth().currentUser else { return }
        
        var stringName = ""
        let userDefault = UserDefaults.standard
        if section == 0 {
            stringName = (modification as! String) + " " + (userDefault.value(forKey: key) as! String)
        }else{
            stringName = (userDefault.value(forKey: key) as! String) + " " + (modification as! String)
        }
        
        //Send a change request to firebase
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = stringName
        changeRequest.commitChanges { [weak self] error in
            if error == nil {
                user.createProfileChangeRequest().displayName = stringName
                UserDefaults.standard.setValue(stringName, forKey: "name")
                self?.tableView.reloadData()
            }
            print("Error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    
    //Update a profile picture
    func displayProfileImage(){
        guard let user = Auth.auth().currentUser, data.count >= 5 else { return }
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
    

    //When user tap phone number and email address
    func inValidActivity(){
        let alert = UIAlertController(title: "Edit your name", message:  "Would you like to change this information?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField()
        alert.textFields?.first?.resignFirstResponder()
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    

    @objc func didTappedImage(){
        presentPhotoActionSheet()
    }
    

}




extension MyProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       informationUpdate(indexPath: indexPath)
    }
    
    func informationUpdate(indexPath: IndexPath){
        if indexPath.section == 0{
            contactInformationEdit(key: "firstName", section: 0)
        }else if indexPath.section == 1 {
            contactInformationEdit(key: "lastName", section: 1)
        }else if indexPath.section == 4{
            deleteAccount()
        }
    }
    
    func deleteAccount(){
        let alertView = UIAlertController(title: "Delete Account", message: "Would you like to delete this account?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Continue", style: .default) {  _ in
            //Move to the delete account process
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(confirmAction)
        alertView.addAction(cancelAction)
        present(alertView, animated: true)
    }
}

extension MyProfileViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PersonDataProvider.myProfileDataProvider().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        
        guard data.count >= 5 else {
            cell.textLabel?.text = "error"
            return cell }
        
        cell.textLabel?.text = data[indexPath.row]
        
        if indexPath.section == 0 {
            cell.textLabel?.text = data[0]
        }else if indexPath.section == 1{
            cell.textLabel?.text = data[1]
        }else if indexPath.section == 2{
            cell.textLabel?.text = data[2]
        }else if indexPath.section == 3{
            cell.textLabel?.text = data[3]
        }else {
            cell.textLabel?.text = PersonDataProvider.myProfileDataProvider()[4].1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleData = PersonDataProvider.myProfileDataProvider()
        return titleData[section].0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}


extension MyProfileViewController: UIImagePickerControllerDelegate {

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


