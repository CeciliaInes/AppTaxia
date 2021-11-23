
import UIKit
import Photos
import FirebaseFirestore
import FirebaseAuth

class RegistrarseViewController : UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private let db = Firestore.firestore()
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtConfirmContrasena: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    
    @IBOutlet weak var anchorContentCenterY: NSLayoutConstraint!
    @IBOutlet weak var viewContent: UIView!
    
    
    @IBAction func swipeToOpenKeyboard(_ sender: Any) {
        self.txtNombre.becomeFirstResponder()
    }
    
    @IBAction func swipeToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    @IBAction func clicBtnMensajeRegistro(_ sender: Any) {
        guard let imagen = self.ImageView.image, imagen.images == nil else {
                    self.showAlertWithTitle("Error", message: "Debe Seleccionar una foto", accept: "Aceptar")
                    return
                }
        
        guard let nombre = self.txtNombre.text, nombre.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Debe ingresar su nombre", accept: "Aceptar")
                    return
                }
        guard let apellidos = self.txtApellidos.text, apellidos.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Debe ingresar sus apellidos", accept: "Aceptar")
                    return
                }
        guard let correo = self.txtCorreo.text, correo.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Debe ingresar un correo", accept: "Aceptar")
                    return
                }
        guard let telefono = self.txtTelefono.text, telefono.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Debe ingresar un telefono", accept: "Aceptar")
                    return
                }
        guard let contrasena = self.txtContrasena.text, contrasena.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Debe ingresar una contrasena", accept: "Aceptar")
                    return
                }
        guard let confirmContrasena = self.txtConfirmContrasena.text, confirmContrasena.count != 0 else {
                    self.showAlertWithTitle("Error", message: "Debe confirmar la contrasena", accept: "Aceptar")
                    return
                }
        
        if contrasena != confirmContrasena {
            self.showAlertWithTitle("Error", message: "Contrasenas deben ser iguales", accept: "Aceptar")
            return
        }
        
        
        Auth.auth().createUser(withEmail: correo, password: contrasena) { (authResult, error) in
            if error == nil{
                self.db.collection("conductores").document(correo).setData([
                                                                    "nombre":nombre,
                                                                    "apellidos":apellidos,
                                                                    "telefono":telefono,
                                                                    "contrasena":contrasena
                                                                            //"foto":imagen
                ])
                let alertController = UIAlertController(title: "Mesaje", message: "Registro con exito", preferredStyle: UIAlertController.Style.alert)
                
                let closeAction = UIAlertAction (title: "Aceptar", style: .cancel, handler: self.clicBtnMsjCerrarRegister)
                alertController.addAction(closeAction)
                self.present(alertController, animated: true, completion: nil)
            
                
            }else{
                self.showAlertWithTitle("Error", message: "Error en el Registro", accept: "Aceptar")
            }
        }
        
        
    }
    @IBAction func clicBtnMsjCerrar(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Mesaje", message: "Segudo de salir sin registrarse?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let acceptAction = UIAlertAction (title: "Aceptar", style: .destructive){
            action in self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(acceptAction)
        
        
        self.present(alertController, animated: true, completion: nil)
     }
    @IBAction func clicBtnMsjCerrarRegister(_ sender: Any) {
          self.navigationController?.popToRootViewController(animated: true)
     }
    
    @IBAction func btnImagePicker(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard  let image = info[.editedImage] as? UIImage else {return}
        ImageView.image = image
        dismiss(animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageView.layer.cornerRadius = ImageView.frame.size.width/2
        ImageView.clipsToBounds = true
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

    extension RegistrarseViewController{
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
                self.anchorContentCenterY.constant = 80
                self.view.layoutIfNeeded()
            }
        }
    }
