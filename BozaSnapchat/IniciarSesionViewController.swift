//
//  ViewController.swift
//  BozaSnapchat
//
//  Created by Nilda Boza on 14/10/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore


class IniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Iniciar sesión con correo y contraseña
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Mostrar alerta si los campos están vacíos
            mostrarAlerta(titulo: "Error", mensaje: "Por favor, ingrese su correo electrónico y contraseña.")
            return
        }
        
        // Intentar iniciar sesión con Firebase
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            print("Intentando Iniciar Sesion")
            if let error = error {
                self.mostrarAlerta(titulo: "Error de inicio de sesión", mensaje: error.localizedDescription)
            } else {
                print("Inicio de sesión exitoso")
                self.performSegue(withIdentifier: "segueToHome", sender: self) // Navegar a la siguiente vista si el login es exitoso
            }
        }
    }

    // Iniciar sesión con Google
    @IBAction func iniciarSesionGoogleTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Crear configuración de Google Sign-In
        let config = GIDConfiguration(clientID: clientID)

        // Iniciar el flujo de inicio de sesión de Google
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            if let error = error {
                print("Error al iniciar sesión con Google: \(error)")
                return
            }

            // Obtener el GIDGoogleUser
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Error al obtener el token de usuario")
                return
            }

            // Crear credenciales con el ID token de Google
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            // Iniciar sesión con Firebase usando las credenciales de Google
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self?.mostrarAlerta(titulo: "Error de Google Sign-In", mensaje: error.localizedDescription)
                    return
                }
                print("Inicio de sesión con Google exitoso")
                // Navegar a la siguiente pantalla
                self?.performSegue(withIdentifier: "segueToHome", sender: self)
            }
        }
    }


    // Función para mostrar alertas
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
    }
}
