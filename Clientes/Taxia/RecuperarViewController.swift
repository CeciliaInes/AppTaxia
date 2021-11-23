//
//  RecuperarViewController.swift
//  Taxia
//
//  Created by user194451 on 10/10/21.
//

import UIKit
import FirebaseAuth

class RecuperarViewController : UIViewController{
    
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var anchorContentCenterY: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipeToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipeToOpenClose(_ sender: Any) {
        self.txtCorreo.becomeFirstResponder()
    }
    
    @IBAction func clicBtnBack(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    @IBAction func clicBtnMsjRecuperarContra(_ sender: Any) {

        
        
        guard let correo = self.txtCorreo.text, correo.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Debe ingresar un correo", accept: "Aceptar")
                    return
                }
        Auth.auth().sendPasswordReset(withEmail: correo) { (error) in
            if error == nil{
                let alertController = UIAlertController(title: "Mesaje", message: "Correo enviado", preferredStyle: UIAlertController.Style.alert)
                
                let closeAction = UIAlertAction (title: "Aceptar", style: .cancel, handler: self.clicBtnMsjCerrarContra)
                alertController.addAction(closeAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                self.showAlertWithTitle("Error", message: "Correo no valido", accept: "Aceptar")
            }
        }
        
        
    }
    
    @IBAction func clicBtnMsjCerrarContra(_ sender: Any) {
          self.navigationController?.popToRootViewController(animated: true)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardEvents()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }
    
}

extension RecuperarViewController{
    private func registerKeyboardEvents(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyboardEvents(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification){
        let keyboarFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        let finalPosYContent = self.viewContent.frame.origin.y + self.viewContent.frame.height
        
        if keyboarFrame.origin.y < finalPosYContent{
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.anchorContentCenterY.constant = keyboarFrame.origin.y - finalPosYContent
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification){
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration){
            self.anchorContentCenterY.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
