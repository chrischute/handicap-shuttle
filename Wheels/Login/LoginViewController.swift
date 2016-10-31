//
//  LoginViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var netIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /* Make keyboard disappear when return is pressed. Also login. */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.netIdTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            // Automatically segue when the password is entered.
            performSegue(withIdentifier: "Login Segue", sender: self)
        }
        return true
    }
    /* Make keyboard disappear when tapping outside of text field. */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
