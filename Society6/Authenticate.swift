//
//  AuthenticateViewController.swift
//  Society6
//
//  Created by Ampe on 3/22/17.
//  Copyright © 2017 Ampe. All rights reserved.
//

import UIKit
import Parse

class IGTitle: UILabel, Colorable {}
class IconImageView: UIImageView, Shakeable {}
class EmailTextField: UITextField, Shakeable {}
class PasswordTextField: UITextField, Shakeable {}
class LoginButton: UIButton, Shakeable {}

class AuthenticateViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: IGTitle!
    @IBOutlet weak var iconImageView: IconImageView!
    @IBOutlet weak var emailTextField: EmailTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var loginButton: LoginButton!
    
    @IBAction func loginButtonPressed(_ sender: LoginButton) {
        logIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func check() {
        if PFUser.current() != nil { proceed() }
    }
    
    private func logIn() {
        view.endEditing(true)
        check()
        isEmpty(emailField: emailTextField, passwordField: passwordTextField)
    }
    
    private func isEmpty(emailField: EmailTextField, passwordField: PasswordTextField) {
        let emailBool = emailField.text?.isEmpty
        let passwordBool = passwordField.text?.isEmpty
        if emailBool! || passwordBool! {
            shake()
            color()
            return
        }
        createNewUser(email: emailTextField.text, password: passwordTextField.text)
    }
    
    // TODO: - Move To Networking
    private func createNewUser(email: String?, password: String?) {
        let user = PFUser()
        user.email = email
        user.password = password
        user.username = createUserName(email: email!)
        user["posts"] = []
        user["followers"] = []
        user["following"] = []
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if (error != nil) { self.shake(); self.color() }
            else { self.proceed() }
        }
    }
    
    private func createUserName(email: String) -> String {
        var username = email
        if let range = username.range(of: "@") {
            username.removeSubrange(range.lowerBound..<username.endIndex)
        }
        return username
    }
    
    private func proceed() {
        self.performSegue(withIdentifier: "tomain", sender: nil)
    }
    
    private func shake() {
        iconImageView.shake()
        emailTextField.shake()
        passwordTextField.shake()
        loginButton.shake()
    }
    
    private func color() {
        titleLabel.color(from: .white, to: .red)
    }
    
}
