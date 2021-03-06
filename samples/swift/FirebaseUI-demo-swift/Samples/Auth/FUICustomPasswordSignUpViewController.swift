//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import FirebaseAuthUI

@objc(FUICustomPasswordSignUpViewController)

class FUICustomPasswordSignUpViewController: FUIPasswordSignUpViewController, UITextFieldDelegate {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var nextButton: UIBarButtonItem!
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, authUI: FUIAuth, email: String?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil, authUI: authUI, email: email)

    emailTextField.text = email
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    //override action of default 'Next' button to use custom layout elements'
    self.navigationItem.rightBarButtonItem?.target = self
    self.navigationItem.rightBarButtonItem?.action = #selector(onNext(_:))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    //update state of all UI elements (e g disable 'Next' buttons)
    self.updateTextFieldValue(nil)
  }

  @IBAction func onNext(_ sender: AnyObject?) {
    if let email = emailTextField.text,
      let password = passwordTextField.text,
      let username = usernameTextField.text {
      self.signUp(withEmail: email, andPassword: password, andUsername: username)
    }
  }

  @IBAction func onCancel(_ sender: AnyObject) {
    self.cancelAuthorization()
  }

  @IBAction func onBack(_ sender: AnyObject) {
    self.onBack()
  }
  @IBAction func onViewSelected(_ sender: AnyObject) {
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    usernameTextField.resignFirstResponder()
  }

  // MARK: - UITextFieldDelegate methods

  @IBAction func updateTextFieldValue(_ sender: AnyObject?) {
    if let email = emailTextField.text,
      let password = passwordTextField.text,
      let username = usernameTextField.text {

      nextButton.isEnabled = !email.isEmpty && !password.isEmpty && !username.isEmpty
      self.didChangeEmail(email, orPassword: password, orUserName: username)
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      usernameTextField.becomeFirstResponder()
    } else if textField == usernameTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      self.onNext(nil)
    }

    return false
  }

}
