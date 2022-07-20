//
//  ReactiveViewModel.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ReactiveViewModel {
    let firstNameTextPublishSubject = PublishSubject<String>()
    let lastNameTextPublishSubject = PublishSubject<String>()
    let emailAddressPublishSubject = PublishSubject<String>()
    let phoneNumberTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    func isNumber() -> Observable<Bool>  {
        return phoneNumberTextPublishSubject.startWith("").map { text in
            guard let intPhone = Int(text) else {
                print("text is not a number")
                return false}
            print("Int(phone).description.IsNumeric: \(intPhone.description.IsNumeric)")
            return intPhone.description.IsNumeric
        }.startWith(false)
    }
    
    func isPasswordRule() -> Observable<Bool>  {
        return passwordTextPublishSubject.startWith("").map { phone in
            return phone.count > 7
        }.startWith(false)
    }
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(
                                        phoneNumberTextPublishSubject.asObservable().startWith(""),
                                        passwordTextPublishSubject.asObservable().startWith("")).map {
            phone, password in
            return  phone.IsNumeric &&
                    password.count > 7
            
        }.startWith(false)
    }
}
    
    
