	
import UIKit

class HomeViewController : UIViewController {
    
    
    //cerrar sesion
    
    @IBAction func clicBtnCerrarSesionn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Mesaje", message: "Segudo de serrar sesion?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let acceptAction = UIAlertAction (title: "Aceptar", style: .destructive){
            action in self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(acceptAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}
