//
//  LogInViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements
import Firebase

class LogInViewController: UIViewController{

    //========== Elements ==========
    private let database = Database.database().reference()
    private var handle: AuthStateDidChangeListenerHandle?
    private let auth = Auth.auth()
    
    lazy var titleLabel: BaseUILabel = {
        let label = BaseUILabel()
        label.textColor = .systemBackground
        label.text = "Contact"
        label.font = UIFont.systemFont(ofSize: 27)
        return label
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
    
    lazy var loginButton: BaseUIButton = {
        let button = BaseUIButton()
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = UIColor.systemMint
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.3
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        return button
    }()
    
    lazy var textFieldStack: VStack = {
        let stack = VStack()
        stack.addArrangedSubview(emailTF)
        stack.addArrangedSubview(passTF)
        stack.spacing = 20
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return stack
    }()

    lazy var contentStack: VStack = {
        let stack = VStack()
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(textFieldStack)
        stack.addArrangedSubview(loginButton)
        stack.spacing = 30
        stack.alignment = .center
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return stack
    }()
    
    lazy var scrollView =  VScrollableView(content: contentStack)
    
    
    
    lazy var gradientLayer : CAGradientLayer = {
        let color = CAGradientLayer()
        color.colors = [
            UIColor(red: 50/255.0, green: 150.0/255.0, blue: 150/255.0, alpha: 1.0).cgColor,
               UIColor(red: 50.0/255.0, green: 200.0/255.0, blue: 100.0/255.0, alpha: 1.0).cgColor
        ]
        return color
    }()
    
    
    
    
    
    //========== Views ==========
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        view.backgroundColor = .secondarySystemBackground
        view.layer.addSublayer(gradientLayer)

        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        scrollView.showsVerticalScrollIndicator = false
        
        emailTF.delegate = self
        passTF.delegate = self
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTF.setUnderLine()
        passTF.setUnderLine()
        
        //Check if user is registered with validationof their email
        isEmailValidated()
    }
    
    
    
    
    
    
    //========== Functions ==========
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
    
    @objc func loginHandler(){

        
       guard let email = emailTF.text , !email.isEmpty,
             let password = passTF.text, !password.isEmpty, password.count >= 8 else { return }

        Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in

            guard let strongSelf = self else { return }
        
            guard let result = result, error == nil else {
                let alert = UIAlertController(title: "Log in failed", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                    strongSelf.present(alert, animated: true, completion: nil)
                print("Login Failed")
                return
            }
            
            UserDefaults.standard.set(result.user.displayName, forKey: "name")
            UserDefaults.standard.set(password, forKey: "password")
            UserDefaults.standard.set(email, forKey: "email")
            print("logged in successfully with this user: \(String(describing: result.user.displayName))")
            self?.navigationController?.dismiss(animated: true, completion: nil)
            
            let vc = TabBarViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func safeEmail(email: String) -> String{
         var safeEmail = email.replacingOccurrences(of: ".", with: "-")
         safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
         return safeEmail
     }
}
    
    
    
    
extension LogInViewController : UITextFieldDelegate{
    // when users enter, automatically move to the next page
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF{
            passTF.becomeFirstResponder()
        }
        else if textField == passTF{
            passTF.resignFirstResponder()
            print("Done")
        }
        return true
    }
}
