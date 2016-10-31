//
//  LoginViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var netIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /* (1) Overridden UIViewController functions. */
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.LoginSegueId {
            // Save the entered netId and password.
            if let netId = netIdTextField.text, let password = passwordTextField.text {
                _ = Rider.riderInDatabase(from: netId, with: password, in: moc)
            }
        }
    }
    
    /* (2) NetId and password entry functions. E.g., login after keyboard entered. */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.netIdTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            // Segue when the password is entered.
            performSegue(withIdentifier: "Login Segue", sender: self)
        }
        return true
    }
    /* Make keyboard disappear when tapping outside of text field. */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
