//
//  OverviewTableViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 29/04/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit


class ContactsTableViewController: UITableViewController {
    var users = [User]()
    var userId = 1
    
    var currentUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch friends & family
        UserController.shared.fetchUsers { (users) in
            if let users = users {
                self.updateUI(with: users)
            }
        }
    }
    
    func updateUI(with users: [User]) {
        DispatchQueue.main.async {
            self.users = users
            self.tableView.reloadData()
        }
    }

    // Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCellIdentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }

    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserContentSegue" {
            let userContentTableViewController = segue.destination as! UserContentTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            userContentTableViewController.user = users[index]
        }
    }

    
    @IBAction func logIn(_ sender: Any) {
    
        // 1 Create Pop Up Alert
        let loginController = UIAlertController(title: "Please Sign In", message: "Fill in the following", preferredStyle: UIAlertController.Style.alert)
        
        // 2 Log user in with provided credentials
        let loginAction = UIAlertAction(title: "Log In", style: UIAlertAction.Style.default) { (action:UIAlertAction) -> Void in
            let loginTextField = loginController.textFields![0]
            let passwordTextField = loginController.textFields![1]
            // Log user in
            if let userName = loginTextField.text {
                if let password = passwordTextField.text {
                    UserController.shared.fetchUser(forUser: userName) { (user) in
                        if let user = user {
                            if password == user.passWord {
                                self.currentUser = user
                            }
                        }
                    }
                }
            }
        }
        
        
        
        // 3 Sign user up
        let signupAction = UIAlertAction(title: "Sign Up", style: UIAlertAction.Style.default) { (action:UIAlertAction) -> Void in
            let loginTextField = loginController.textFields![0]
            let passwordTextField = loginController.textFields![1]
            
            // Check if information is provided
            // if not, shake and colour red
            // Register User
            if let userName = loginTextField.text {
                if let password = passwordTextField.text {
                    let newUser: [String: String] = ["name": userName, "type": "simple", "friendsFamily": "", "passWord": password]
                    UserController.shared.addUser(forUser: newUser)
                    { (user) in
                        DispatchQueue.main.async {
                            if let user = user {
                                self.currentUser = user
                            }
                        }
                    }
                }
            }
        }
        
        // 4 Username Field
        loginController.addTextField { (textField:UITextField!) -> Void in
            textField.placeholder = "Username"
            loginAction.isEnabled = false
            textField.keyboardType = UIKeyboardType.emailAddress
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification:Notification!) -> Void in
                let textField = notification.object as! UITextField
                loginAction.isEnabled = !textField.text!.isEmpty
            })
        }
        
        // 5 Secure Password Field
        loginController.addTextField { (textField:UITextField!) -> Void in
            textField.placeholder = "Password"
            signupAction.isEnabled = false
            textField.isSecureTextEntry = true
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification:Notification!) -> Void in
                let textField = notification.object as! UITextField
                signupAction.isEnabled = !textField.text!.isEmpty
            })
        }
        // 6
        loginController.addAction(loginAction)
        loginController.addAction(signupAction)
        
        // 7
        present(loginController, animated: true, completion: nil)
       
        // Source: https://mycodetips.com/swift-ios/create-login-screen-alert-view-controller-using-uialertcontroller-swift-1306.html
        
    }
    
    @IBAction func AddContactButton(_ sender: Any) {
        
        // 1 Create Pop Up Alert
        let loginController = UIAlertController(title: "Add Contact", message: "Tell us your friends username and we'll find him!", preferredStyle: UIAlertController.Style.alert)
        
        // 2 Log user in with provided credentials
        let loginAction = UIAlertAction(title: "Add Contact", style: UIAlertAction.Style.default) { (action:UIAlertAction) -> Void in
            let newContact = loginController.textFields![0]
            // Check if information is provided
                // if not, shake and colour red
            // add newContact to user's contactlist
        }
        loginAction.isEnabled = false
        
        // 3 Username Field
        loginController.addTextField { (textField:UITextField!) -> Void in
            textField.placeholder = "Username"
            textField.keyboardType = UIKeyboardType.emailAddress
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification:Notification!) -> Void in
                let textField = notification.object as! UITextField
                loginAction.isEnabled = textField.text!.isEmpty
            })
        }
        
        // 4
        loginController.addAction(loginAction)
        
        // 5
        present(loginController, animated: true, completion: nil)
        
    }
}
