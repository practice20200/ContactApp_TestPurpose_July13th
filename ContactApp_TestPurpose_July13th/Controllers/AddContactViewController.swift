//
//  AddContactViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements
import Firebase
import RxCocoa
import RxSwift

class AddContactViewController: UIViewController, UINavigationControllerDelegate {

    public var completion: ((String, String, String, Int, String) -> Void)?
    private let refContact = Database.database()

    private let reactiveViewModel = ReactiveViewModel()
    private let disposeBag = DisposeBag()
    
    //========== Elements ==========
    lazy var profileImageIV: BaseUIImageView = {
        let iv = BaseUIImageView()
        iv.image = UIImage(systemName: "person.circle")
        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 150).isActive = true
        iv.layer.cornerRadius = 75
        iv.clipsToBounds = true
        let configuration = UIImage.SymbolConfiguration(paletteColors:
         [.white])
        iv.preferredSymbolConfiguration = configuration
        return iv
    }()
    
    lazy var titleLabel: BaseUILabel = {
        let label = BaseUILabel()
        label.text = "Add a new contact"
        label.font = UIFont.systemFont(ofSize: 27)
        label.textColor = .systemBackground
        return label
    }()
    
    lazy var logoStack : VStack = {
        let stack = VStack()
        stack.addArrangedSubview(profileImageIV)
        stack.addArrangedSubview(titleLabel)
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    lazy var firstNameTF: BaseUITextField = {
        let tf = BaseUITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "first name",
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBackground])
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.shadowColor = UIColor.lightGray.cgColor
        tf.autocapitalizationType = .none
        tf.returnKeyType = .continue
        return tf
    }()
    
    lazy var LastNameTF: BaseUITextField = {
        let tf = BaseUITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "last name",
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBackground])
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.shadowColor = UIColor.lightGray.cgColor
        tf.autocapitalizationType = .none
        tf.returnKeyType = .continue
        return tf
    }()
    
    lazy var emailTF: BaseUITextField = {
        let tf = BaseUITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "email",
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBackground])
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.shadowColor = UIColor.lightGray.cgColor
        tf.autocapitalizationType = .none
        tf.returnKeyType = .continue
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    lazy var phoneNumberTF: BaseUITextField = {
        let tf = BaseUITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "phone number",
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBackground])
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.shadowColor = UIColor.lightGray.cgColor
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.keyboardType = .numbersAndPunctuation
        return tf
    }()
    
    lazy var phoneNumberRuleLabel : BaseUILabel = {
        let label = BaseUILabel()
        label.text = "Type Only numbers"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .left
        return label
    }()
    
    lazy var phoneNumberContent: VStack = {
        let stack = VStack()
        stack.addArrangedSubview(phoneNumberTF)
        stack.addArrangedSubview(phoneNumberRuleLabel)
        stack.spacing = 10
       
        return stack
    }()
    
    lazy var addBTN: BaseUIButton = {
        let button = BaseUIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.systemMint, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.3
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(addHandler), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStack: VStack = {
        let stack = VStack()
        stack.addArrangedSubview(firstNameTF)
        stack.addArrangedSubview(LastNameTF)
        stack.addArrangedSubview(emailTF)
        stack.addArrangedSubview(phoneNumberContent)
        stack.addArrangedSubview(addBTN)
        stack.spacing = 20
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return stack
    }()

    lazy var contentStack: VStack = {
        let stack = VStack()
        stack.addArrangedSubview(logoStack)
        stack.addArrangedSubview(buttonStack)
        stack.spacing = 25
        stack.alignment = .center
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return stack
    }()
    
    lazy var gradientLayer : CAGradientLayer = {
        let color = CAGradientLayer()
        color.colors = [
            UIColor(red: 50/255.0, green: 150.0/255.0, blue: 150/255.0, alpha: 1.0).cgColor,
               UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 100.0/255.0, alpha: 1.0).cgColor
        ]
        return color
    }()
    
    
    lazy var  scrollView =  VScrollableView(content: contentStack)

    
    
    
    
    
    
    //===================== Views =========================
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        view.backgroundColor = .systemBackground
        view.layer.addSublayer(gradientLayer)

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
        
        
        profileImageIV.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedImage))
        gesture.numberOfTapsRequired = 1
        profileImageIV.addGestureRecognizer(gesture)
        scrollView.showsVerticalScrollIndicator = false
        
        firstNameTF.delegate = self
        LastNameTF.delegate = self
        emailTF.delegate = self
        phoneNumberTF.delegate = self

        ResponsiveDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gradientLayer.frame = view.bounds
        navigationController?.navigationBar.topItem?.titleView?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           firstNameTF.setUnderLine()
           LastNameTF.setUnderLine()
           emailTF.setUnderLine()
           phoneNumberTF.setUnderLine()
       }

    
    
    
    //===================== Functions =========================
    func ResponsiveDesign(){
        //Target: Email textField and Password textField
        phoneNumberTF.rx.text.map { $0 ?? "" }.bind(to: reactiveViewModel.phoneNumberTextPublishSubject).disposed(by: disposeBag)
        
        //Layout
        //SignUp Button Rule
        reactiveViewModel.isNumber().bind(to: addBTN.rx.isEnabled).disposed(by: disposeBag)
        reactiveViewModel.isNumber().map{$0 ? 1 : 0.3}.bind(to: addBTN.rx.alpha).disposed(by: disposeBag)
        
        //PhonNumber Rule
        reactiveViewModel.isNumber().map{$0 ? UIColor.systemBlue : UIColor.systemRed}.bind(to: phoneNumberRuleLabel.rx.textColor).disposed(by: disposeBag) //Color
        reactiveViewModel.isNumber().map{$0 ? "Valid" : "Type Only Number"}.bind(to: phoneNumberRuleLabel.rx.text).disposed(by: disposeBag) // text
    }
    
    func isphoneNumberValid(){
        let alertView = UIAlertController(title: "Invalid", message: "Please type only numbers in phone number.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(OKAction)
        present(alertView, animated: true)
        
    }
    
    func successAlert(){
        let alertView = UIAlertController(title: "Success", message: "A new contact was successfully added.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            self?.makeDefaultTextField()
        }
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }
    
    func makeDefaultTextField(){
        firstNameTF.text = ""
        LastNameTF.text = ""
        emailTF.text = ""
        phoneNumberTF.text = ""
        profileImageIV.image = UIImage(systemName: "person.circle")
    }
    
    @objc func addHandler(){
        guard let userUID = Auth.auth().currentUser?.uid else {
            return }

        if  let firstName = firstNameTF.text, !firstName.isEmpty,
            let lastName = LastNameTF.text, !lastName.isEmpty,
            let emailAddress = emailTF.text, !emailAddress.isEmpty,
            let number = phoneNumberTF.text, !number.isEmpty{

                guard let intNumber = Int(number) else {
                    isphoneNumberValid()
                    return
                }

                //Send the created data to firebase
                let uuid = UUID().uuidString
                let contact = Contact(firstName: firstName, lastName: lastName, emailAddress: emailAddress, number: intNumber, id: uuid)
                let ref = refContact.reference(withPath: "\(userUID)/Contact").child("\(uuid)")
                ref.setValue(contact.toAnyObject())
                completion?(firstName,lastName,emailAddress,intNumber,uuid)
                
                //Storage
                guard let image = profileImageIV.image, let data = image.pngData() else { return }
                let fileName = "\(userUID)/\(uuid)_profile_picture_url"
                print("file Name: \(fileName)")
                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName)
                successAlert()
                
                
            }
    }
    
    
    @objc func didTappedImage() {
        print("Change picture request")
        presentPhotoActionSheet()
    }

}



extension AddContactViewController: UIImagePickerControllerDelegate {

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
        profileImageIV.image = selectImage
    }

    // users cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



extension AddContactViewController : UITextFieldDelegate{
    // when users enter, automatically move to the next page
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTF{
            logoStack.isHidden = true
            LastNameTF.becomeFirstResponder()
        }
        else if textField == LastNameTF{
            logoStack.isHidden = true
            emailTF.becomeFirstResponder()
        }
        else if textField == emailTF{
            logoStack.isHidden = true
            phoneNumberTF.becomeFirstResponder()
        }
        else if textField == phoneNumberTF{
            logoStack.isHidden = false
            phoneNumberTF.resignFirstResponder()
            print("Done")
        }
        return true
    }
}
