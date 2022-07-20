//
//  DeleteViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-18.
//

import UIKit
import Firebase
import Elements
import FirebaseStorage

final class DeleteViewController: UIViewController {
    
    private var contactData = [Contact]()
    
    private let database = Database.database().reference()
    private var password = ""
    
    private var reObserver : [DatabaseHandle] = []
    private let refContact = Database.database()
    
    //=============== Elements =================
    lazy var imageView : BaseUIImageView = {
        let imageView = BaseUIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill.badge.xmark")
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        let configuration = UIImage.SymbolConfiguration(paletteColors:
                                                            [.systemYellow,.systemRed])
        imageView.preferredSymbolConfiguration = configuration
        return imageView
    }()
    
    lazy var warningMSG: BaseUILabel = {
        let label = BaseUILabel()
        label.text =  "Would you like to delete your account permanently?"
        label.textColor = .systemRed
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        label.textAlignment = .center
        return label
    }()

    lazy var deleteBTN: BaseUIButton = {
        let button = BaseUIButton()
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(UIColor.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(accountDeleteHandler), for: .touchUpInside)
        return button
     }()

    lazy var deleteResigninButton : BaseUIButton = {
        let button = BaseUIButton()
        button.setTitle("Forgot your password?", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 250).isActive = true
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(logoutAlertHasndler), for: .touchUpInside)
        return button
    }()
    
    lazy var contentStack : VStack = {
        let stack = VStack()
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(warningMSG)
        stack.addArrangedSubview(deleteBTN)
        stack.addArrangedSubview(deleteResigninButton)
        stack.spacing = 20
        stack.alignment = .center
        
        return stack
    }()
    
    lazy var scrollView = VScrollableView(content: contentStack)

    
    
    
    
    //=============== Views =================
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Delete Account"
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        checkAuthentification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ContactDataReader()
    }
    
    
   
    
    
    //=============== Functions =================
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
            //Add an contact which contains users own UID to contactData in order to delete user own image in Cloud Storage with other image data.
            self?.contactData.append(Contact(firstName: "", lastName: "", emailAddress: "", number: 0, id: userUID))
        }
        reObserver.append(completed)
    }
    
    func checkAuthentification(){
        let alertView = UIAlertController(title: "Password", message: "Please enter password, to complete deleting your account", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Cancel", style: .cancel){
            [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let yesAction = UIAlertAction(title:"Confirm", style: .default){
           [weak self] _ in
            if let title = alertView.textFields?.first?.text {
                self?.password = title
            }
        }
        
        alertView.addTextField()
        
        alertView.textFields?.first?.isSecureTextEntry = true
        alertView.addAction(noAction)
        alertView.addAction(yesAction)
        present(alertView, animated: true)
    }
    
    //STEP1: Delete contact data in realtime database
    func userDataDeleteHandler(){
        guard let user = Auth.auth().currentUser else { return }
                Database.database().reference(withPath: "\(user.uid)/Contact/").observeSingleEvent(of: .value) { snapshot in
                    guard snapshot.value as? [String: Any] != nil else {
                        print("userDataDeleteHandler Error message: \(String(describing: snapshot.value)).")
                        return
                    }
                    snapshot.ref.removeValue()
                    print("STEP1: Succeeded in deleting contactData in real time database data")
            }
        print("There is no data related to this user in Contact branch.")
    }
    
    //STEP2: Delete imageData in Storage
    func storageDataDeleteHandler(){
        guard let user = Auth.auth().currentUser else { return }

        for contact in contactData{
            let filePathd = contact.id
            let dataRef = Storage.storage().reference(withPath: "images/\(user.uid)/\(filePathd)_profile_picture_url")
            dataRef.delete { error in
                guard error == nil else {
                      print("Error Storage deletion: \(String(describing: error?.localizedDescription))")
                      return
                  }
                print("STEP2: Succeeded in deleting Storage data:\(self.contactData.count)")
            }
        }
    }
    
    //RESULT IN DELETING PROCESS
    //Success Result in deleteing Process
    func successAlert(){
        let alertView = UIAlertController(title: "Approved!", message: "All your data was deleted.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { [weak self] action in
            do{
                try Auth.auth().signOut()
                
                let vc = WelcomeViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
                
            }catch{
                print("Failed to log out")
            }
        }
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }
    
    //Fail Result in deleteing Process
    func failAlert(error : String){
        let alertView = UIAlertController(title: "Failed", message: "Your account failed to be deleted. \(error)", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel){
            [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            self?.navigationController?.dismiss(animated: true)
        }
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }

    @objc func accountDeleteHandler(){
        guard let user = Auth.auth().currentUser else { return }
        
        let alertView = UIAlertController(title: "Warning", message: "All your data will be deleted permanently. Would you like to continue deleting this account?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in

            guard let email = user.email else { return }
            guard let password = self?.password else { return }
           
            var credential: AuthCredential
        
            credential = EmailAuthProvider.credential(withEmail: email, password: password)

            // Prompt the user to re-provide their sign-in credentials
            user.reauthenticate(with: credential) { result, error in
              if error != nil {
                // An error happened.
                  self?.failAlert(error: error?.localizedDescription ?? "Error")
                  return
              } else {
                // User re-authenticated successfully.
                // STEP1: Delete data in RealTImeDatabase
                  self?.userDataDeleteHandler()
                
                //STEP2: Delete storage deta
                  self?.storageDataDeleteHandler()
    
                //Remove this account in Authentification and remove UserDefault data in local storage
                user.delete { [weak self] error in
                   if let error = error{
                       self?.failAlert(error: error.localizedDescription)
                       print("\(String(describing: error.localizedDescription))")
                   } else {
                       UserDefaults.standard.setValue(nil, forKey: "firstName")
                       UserDefaults.standard.setValue(nil, forKey: "lastName")
                       UserDefaults.standard.setValue(nil, forKey: "emailAddress")
                       UserDefaults.standard.setValue(nil, forKey: "phoneNumber")
                       print("STEP3: UserDefaultData was deleted and delete this acccount in Authentification.")
                       self?.successAlert()
                  }
                }
              }
            }
        }
        alertView.addAction(cancelAction)
        alertView.addAction(deleteAction)
        present(alertView, animated: true)
    }
    
    
    @objc func logoutAlertHasndler(){
        let alertView =  UIAlertController(title: "Help", message: "Did you forget your password or get some errors? Please log out and log in again.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            self?.navigationController?.dismiss(animated: true)
        }
        alertView.addAction(OKAction)
        present(alertView, animated: true)
        
    }
}


