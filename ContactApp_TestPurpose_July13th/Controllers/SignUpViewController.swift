//
//  SignUpViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate {
    
    private let database = Database.database().reference()
    private var handle: AuthStateDidChangeListenerHandle?
    
    private let auth = Auth.auth()

    
    //========== Elements ==========
    lazy var logo: BaseUIImageView = {
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
        label.text = "Contact"
        label.font = UIFont.systemFont(ofSize: 27)
        label.textColor = .systemBackground
        return label
    }()
    
    lazy var logoStack : VStack = {
        let stack = VStack()
        stack.addArrangedSubview(logo)
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
        tf.returnKeyType = .continue
        tf.keyboardType = .numbersAndPunctuation
        return tf
    }()
    
    lazy var passTF: BaseUITextField = {
        let tf = BaseUITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "password",
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBackground])
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.shadowColor = UIColor.lightGray.cgColor
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var signupButton: BaseUIButton = {
        let button = BaseUIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(UIColor.systemMint, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.3
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(signUpHandler), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStack: VStack = {
        let stack = VStack()
        stack.addArrangedSubview(firstNameTF)
        stack.addArrangedSubview(LastNameTF)
        stack.addArrangedSubview(emailTF)
        stack.addArrangedSubview(phoneNumberTF)
        stack.addArrangedSubview(passTF)
        stack.addArrangedSubview(signupButton)
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

        logo.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedImage))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTapsRequired = 1
        logo.addGestureRecognizer(gesture)
        scrollView.showsVerticalScrollIndicator = false
        
        firstNameTF.delegate = self
        LastNameTF.delegate = self
        emailTF.delegate = self
        passTF.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       firstNameTF.setUnderLine()
       LastNameTF.setUnderLine()
       emailTF.setUnderLine()
       phoneNumberTF.setUnderLine()
       passTF.setUnderLine()
    
       //Check if user is registered with validationof their email
       isEmailValidated()
    }

    
    
    
    @objc func didTappedImage() {
            print("Change picture request")
            presentPhotoActionSheet()
    }
    
    
    
    //===================== Functions =========================
    func isEmailValidated(){
        if auth.currentUser != nil {
            
            auth.currentUser?.reload(completion: {[weak self] error in
                if error == nil {
                    if self?.auth.currentUser?.isEmailVerified == true {
                       self?.isAuthentificated()
                    } else if self?.auth.currentUser?.isEmailVerified == false {
                        self?.emailValidationAlert()
                    }
                }
            })
            
        }
    }
    
    func isAuthentificated(){
        handle = Auth.auth().addStateDidChangeListener({ [weak self] success, user in
            if user != nil {
                let vc = TabBarViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    func emailValidationAlert(){
        let alert = UIAlertController(title: "Validate your email address", message: "Please check inbox to validate the URL link attached.", preferredStyle: .alert)
        let resignUpAction = UIAlertAction(title: "Re-sign up", style: .default, handler: nil)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)})
        alert.addAction(OKAction)
        alert.addAction(resignUpAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Check if phone number was enterted as its type is Int
    func isphoneNumberValid(){
        let alertView = UIAlertController(title: "Invalid", message: "Please type only numbers in phone number.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }
    
    @objc func signUpHandler() {
        
        guard let firstName = firstNameTF.text, !firstName.isEmpty,
              let lastName = LastNameTF.text, !lastName.isEmpty,
              let email = emailTF.text , !email.isEmpty,
              let phoneNumber = phoneNumberTF.text, !phoneNumber.isEmpty,
              let password = passTF.text, !password.isEmpty, password.count >= 8 else { return }
        
        guard Int(phoneNumber) != nil else {
            isphoneNumberValid()
            return
        }
        print("===========User input information correctly")

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let result = result, error == nil else{
                print("Auth Error; \(String(describing: error?.localizedDescription))")
                return
            }
            print("==========create user: email and password are valid")
            
            //send authentification Email to users
            result.user.sendEmailVerification {[weak self] error in
                guard error == nil else {
                    self?.emailInvalidAlert(error: error!)
                    return
                }
                
                //Received user information
                let req = result.user.createProfileChangeRequest()
                let username = firstName + " " + lastName
                req.displayName = username
                
                //store information in local device
                UserDefaults.standard.setValue(firstName, forKey:"firstName")
                UserDefaults.standard.setValue(lastName, forKey:"lastName")
                UserDefaults.standard.setValue(email, forKey:"email")
                UserDefaults.standard.setValue(phoneNumber, forKey:"phoneNumber")
                
                self?.validateEmailAlert()
            }
       }
    }
    
   func safeEmail(email: String) -> String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    func emailInvalidAlert(error: Error){
        let alertView = UIAlertController(title: "Error", message: String(error.localizedDescription), preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }
    
    func validateEmailAlert(){
        let alertView = UIAlertController(title: "One more step", message: "Please check your email box and click the URL attached in order to validate your email address. ", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        alertView.addAction(OKAction)
        present(alertView, animated: true)
    }
    
}



extension SignUpViewController: UIImagePickerControllerDelegate {

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
       logo.image = selectImage
    }

    func uploadProfilePicture(with data : Data, fileName: String, completion: (Result< String, Error >)  -> Void) {

    }

    // users cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



extension SignUpViewController : UITextFieldDelegate{
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
            passTF.becomeFirstResponder()
        }
        else if textField == passTF{
            logoStack.isHidden = false
            passTF.resignFirstResponder()
            print("Done")
        }
        return true
    }
}
