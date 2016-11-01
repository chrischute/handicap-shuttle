//
//  UIViewController+dismissKeyboard.swift
//  Wheels
//
//  Created by Christopher Chute on 11/1/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

extension UIViewController {
    func setKeyboardAutoHiding(_ doAutoHide: Bool) {
        let tapOutsideKeyboard = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        if doAutoHide {
            self.view.addGestureRecognizer(tapOutsideKeyboard)
        } else {
            view.removeGestureRecognizer(tapOutsideKeyboard)
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
