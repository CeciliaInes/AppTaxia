
import UIKit
import Firebase

class LoginViewController : UIViewController {
    private let db = Firestore.firestore()
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!

    @IBOutlet weak var anchorContentCenterY: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipeToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipToOpenKeyboard(_ sender: Any) {
        self.txtCorreo.becomeFirstResponder()
    }
    
    @IBAction func clicBtnIngresar(_ sender: Any) {
        
        guard let usuario = self.txtCorreo.text, usuario.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Ingrese un usuario", accept: "Aceptar")
                    return
                }
        guard let password = self.txtPassword.text, password.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Ingrese una contrasena", accept: "Aceptar")
                    return
                }
                
        //self.performSegue(withIdentifier: "HomeViewController", sender: nil)
        db.collection("clientes").document(usuario).getDocument { (documentSnaptshot,error) in
            if let document = documentSnaptshot, error == nil{
                if let pass = document.get("contrasena") as? String{
                    if pass != password {
                        self.showAlertWithTitle("Error", message: "correo o pass invalido", accept: "Aceptar")
                    }else{
                        //self.showAlertWithTitle("Error", message: "El Home", accept: "Aceptar")
                        self.performSegue(withIdentifier: "HomeViewController", sender: nil)
                }
                }else{self.showAlertWithTitle("Error", message: "correo o pass invalido", accept: "Aceptar")}
            }
            }
        }
    private func clearAllFields() {
        self.txtCorreo.text = nil
        self.txtPassword.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearAllFields()
        self.registerKeyboardEvents()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }
        
    }

extension LoginViewController{
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


