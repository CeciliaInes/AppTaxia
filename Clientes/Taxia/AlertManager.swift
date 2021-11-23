//
//  AlertManager.swift
//  Taxia
//
//  Created by user194451 on 10/10/21.
//

import UIKit

extension UIViewController {
    func showAlertWithTitle(_ title: String, message: String, accept: String) {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: accept, style: .cancel, handler: nil)
            alertController.addAction(closeAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
}
