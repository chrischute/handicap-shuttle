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
    
    /**
     * (1) Overridden UIViewController functions.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss the keyboard by tapping outside its bounds.
        setKeyboardAutoHiding(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.loginSegueId {
            let dest = segue.destination as! MainPageViewController
            // Save the entered netId and password.
            if let netId = netIdTextField.text, let password = passwordTextField.text {
                dest.rider = Rider.riderInDatabase(from: netId, with: password, in: moc)
                dest.moc = moc
            }
        }
    }
    
    /**
     * Determine whether to segue away from the login screen.
     * We segue only if netId and password are non-empty.
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let netId = netIdTextField.text, let password = passwordTextField.text {
            if netId.characters.count > 0 && password.characters.count > 0 {
                return true
            }
        }
        // Clear and move the cursor to the netId text field. Do not segue.
        Debug.log("At least one text field was blank.")
        netIdTextField.text = ""
        netIdTextField.becomeFirstResponder()
        return false
    }
    
    /**
     * (2) NetId and password entry functions.
     */
    
    /**
     * Move to next text field on return from netId field.
     * Move to segue on return from password field.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.netIdTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            // Segue when the password is entered.
            performSegue(withIdentifier: StoryboardConstants.loginSegueId, sender: self)
        }
        return true
    }
}
