//
//  ViewController.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import UIKit
import Elements
class WelcomeViewController: UIViewController{
    

    lazy var imageView : BaseUIImageView = {
        let iv = BaseUIImageView()
        iv.image = UIImage(systemName: "book.closed.circle")
        let configuration = UIImage.SymbolConfiguration(paletteColors:
                                                            [.systemBackground])
        iv.preferredSymbolConfiguration = configuration
        iv.widthAnchor.constraint(equalToConstant: 150).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return iv
        
    }()

    lazy var titleLabel: BaseUILabel = {
        let label = BaseUILabel()
        label.text = "Contact"
        label.textColor = .systemBackground
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var labelsStack: VStack = {
        let stack = VStack()
        stack.spacing = 10
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleLabel)
        stack.alignment = .center
        return stack
    }()
    
    lazy var loginButton: BaseUIButton = {
        let button = BaseUIButton()
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.3
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(loginTagged), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpButton: BaseUIButton = {
        let button = BaseUIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(UIColor.systemMint, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.3
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(signUpTagged), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStack : VStack = {
       let stack = VStack()
        stack.spacing = 20
        stack.addArrangedSubview(loginButton)
        stack.addArrangedSubview(signUpButton)
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return stack
    }()
    
    
    
    lazy var latterPart : VStack = {
       let stack = VStack()
        stack.spacing = 20
        stack.addArrangedSubview(labelsStack)
        stack.addArrangedSubview(buttonStack)
        return stack
    }()
    
    lazy var contentStack: VStack = {
        let stack = VStack()
        stack.addArrangedSubview(labelsStack)
        stack.addArrangedSubview(buttonStack)
        stack.spacing = 20
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 40, left: 10, bottom: 40, right: 10)
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
    

    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.layer.addSublayer(gradientLayer)
        title = "Welcome"

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    
    
    

    @objc func signUpTagged(){
        print("signup: tapped")
        let signUpViewController = SignUpViewController()
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @objc func loginTagged(){
        print("login: tapped")
        let loginViewController = LogInViewController()
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
     
}

