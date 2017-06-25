//
//  LoginViewController.swift
//  BaseMVC
//
//  Created by Henry Tran on 6/21/17.
//  Copyright © 2017 THL. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: BaseViewController {

    // MARK: - IBOutlet

    // MARK: - Varialbes

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBtnRightNavWithTitle(title: "Setting")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Setup View

    // MARK: - Call Api
    private func loginFirebase() {

        Auth.auth().signIn(withEmail: "ltranframgia@gmail.com", password: "12345678") { (user, _) in
            if user != nil {
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (idToken, _ ) in

                    logD("token: \(String(describing: idToken)) - refreshToken:  \(String(describing: Auth.auth().currentUser?.refreshToken))")

                    // main app
                    self.gotoMainApp()
                })

            }

        }
    }

    // MARK: - Actions
    @IBAction func actionTouchBtnLogin(_ sender: Any) {
        self.loginFirebase()
    }

    override func actionTouchBtnRight() {
        let userSettingVC = LoginViewController.getViewControllerFromStoryboard(Storyboard.User.name)
        let navigationVC = UINavigationController(rootViewController: userSettingVC)
        // present
        self.present(navigationVC, animated: true, completion: nil)
    }

    // MARK: - Functions
    private func gotoMainApp() {
        self.mainViewController?.setupMainApp()
        self.mainViewController?.dismiss(animated: true, completion: nil)
    }
}
