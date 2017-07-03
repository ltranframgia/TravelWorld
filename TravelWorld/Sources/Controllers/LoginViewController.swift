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
    @IBOutlet private weak var contentView: UIView!
    lazy private var loginFormView: LoginFormView? = LoginFormView.fromNib()

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
        self.addLoginFormView()

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
    private func addLoginFormView() {

        if let loginFormView = self.loginFormView {
            loginFormView.addToViewWithAnimation(superView: self.contentView, animate: true, action: #selector(LoginViewController.actionTouchBtnLogin(_:)))
        }
    }

    // MARK: - Call Api
    private func loginFirebase() {

        Auth.auth().signIn(withEmail: "ltranframgia@gmail.com", password: "12345678") { (user, _) in
            if user != nil {
                Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (idToken, _ ) in
                    _ = OAuthHandler(accessToken: idToken, refreshToken: Auth.auth().currentUser?.refreshToken)
                    logD("token: \(String(describing: idToken)) - refreshToken:  \(String(describing: Auth.auth().currentUser?.refreshToken))")

                    // main app
                    self.gotoMainApp()
                })

            }

        }
    }

    // MARK: - Actions
    @IBAction func actionTouchBtnLogin(_ sender: Any) {
        self.view.endEditing(true)

        if let loginFormView = self.loginFormView {
            loginFormView.hideWithAnimation(animate: true, completion: { (_) in
                let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
                indicatorView.center = loginFormView.center
                indicatorView.startAnimating()
                loginFormView.superview?.addSubview(indicatorView)
                self.loginFirebase()
            })
        }
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
