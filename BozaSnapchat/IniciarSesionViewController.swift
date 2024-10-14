//
//  ViewController.swift
//  BozaSnapchat
//
//  Created by Nilda Boza on 14/10/24.
//

import UIKit
import FirebaseAuth

class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                print("Intentando Iniciar Sesion")
                if error != nil {
                    print("Se presentó el siguiente error: \(error!)")
                } else {
                    print("Inicio de sesión exitoso")
                }
            }
    }

}
