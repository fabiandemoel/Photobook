//
//  OverviewTableViewController.swift
//  Photobook
//
//  Created by Fabian de Moel on 29/04/2019.
//  Copyright © 2019 Fabian de Moel. All rights reserved.
//

import UIKit


class ContactsTableViewController: UITableViewController {
    
    ////////////////////// View Preperation /////////////////////
    
    // Variables
    var users = [User]()
    var userId = 1
    var currentUser: User!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var faultyActionController: UIAlertController!
    
    // Outlets
    @IBOutlet var SwitchUserBarButton: UIBarButtonItem!
    
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser = appDelegate.globalUser
        let user = self.currentUser!
        
        // Alert user of demo mode
        if user.name == "Demo Account" {
            let alert = UIAlertController(title: "Demo Mode", message: "You have been automatically signed in with a sample account", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
        
        // fetch friends & family
        let friendList = user.friendsFamily.split(separator: ",")
        for friend in friendList {
            UserController.shared.fetchUser(forUser: String(friend)) { (userFriend) in
                if let userFriend = userFriend {
                    self.users.append(userFriend)
                    self.updateUI()
                }
            }
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    /////////////////// Table view data source //////////////////////

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

    // Reload data when switched to Tab bar with new user
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            print("tabbar 1 selected")
            if currentUser.name != appDelegate.globalUser.name {
                viewDidLoad()
            }
        }
    }
    
    
    /////////////////////// Functions //////////////////////////////
    
    
    ////////////////////////////////////// Log In Function //////////////////////////////////
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
                                self.appDelegate.globalUser = user
                                self.users.removeAll()
                                self.viewDidLoad()
                            } else {
                                let faultAlert = self.faultyActionController!
                                faultAlert.message = "This combination of username and password is incorrect, please try again or sign up for an account."
                                faultAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                                self.present(self.faultyActionController, animated: true, completion: nil)
                            }
                        } else {
                            let faultAlert = self.faultyActionController!
                            faultAlert.message = "This username is unknown, please try again or sign up for an account."
                            faultAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                            self.present(self.faultyActionController, animated: true, completion: nil)
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
                    let newUser: [String: String] = ["name": userName, "type": "simple", "friendsFamily": "DemoAccount", "passWord": password]
                    UserController.shared.fetchUser(forUser: userName) { (user) in
                        if user != nil {
                            let faultAlert = self.faultyActionController!
                            faultAlert.message = "This username is already in use, please choose another."
                            faultAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                            self.present(faultAlert, animated: true, completion: nil)
                        } else {
                            UserController.shared.addUser(forUser: newUser)
                            { (user) in
                                DispatchQueue.main.async {
                                    if let user = user {
                                        self.appDelegate.globalUser = user
                                        self.users.removeAll()
                                        print(self.users)
                                        self.viewDidLoad()
                                    }
                                }
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
        
        faultyActionController = loginController
        
        // 7
        present(loginController, animated: true, completion: nil)
       
        // Source: https://mycodetips.com/swift-ios/create-login-screen-alert-view-controller-using-uialertcontroller-swift-1306.html
        
    }
    
    
    ///////////////////////////////////////// Add Contact Function //////////////////////////////////
    @IBAction func AddContactButton(_ sender: Any) {
        
        // 1 Create Pop Up Alert
        let addContactController = UIAlertController(title: "Add Contact", message: "Tell us your friends username and we'll find them!", preferredStyle: UIAlertController.Style.alert)
        
        // 2 Log user in with provided credentials
        let addContactAction = UIAlertAction(title: "Add Contact", style: UIAlertAction.Style.default) { (action:UIAlertAction) -> Void in
            if let newContact = addContactController.textFields![0].text {
                let friendList = self.currentUser.friendsFamily.split(separator: ",")
                if friendList.contains(Substring(newContact)) {
                    let duplicateFriendAlert = self.faultyActionController!
                    duplicateFriendAlert.message = "You already have this person in your contact list. Please add a new person's username."
                    duplicateFriendAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    self.present(duplicateFriendAlert, animated: true, completion: nil)
                } else {
                    UserController.shared.fetchUser(forUser: String(newContact)) { (userFriend) in
                        if let userFriend = userFriend {
                            self.users.append(userFriend)
                            self.updateUI()
                            
                            let friends = self.currentUser?.friendsFamily
                            var newFriends = ""
                            if friends == nil {
                                newFriends = newContact
                            } else {
                                newFriends = "\(friends!),\(newContact)"
                            }
                            UserController.shared.editUser(forValues: ["friendsFamily": newFriends], forUser: self.currentUser!.id) { (user) in}
                        }
                    }
                }
            }
        }
        addContactAction.isEnabled = false
        
        // 3 Username Field
        addContactController.addTextField { (textField:UITextField!) -> Void in
            textField.placeholder = "Username"
            textField.keyboardType = UIKeyboardType.emailAddress
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification:Notification!) -> Void in
                let textField = notification.object as! UITextField
                addContactAction.isEnabled = !textField.text!.isEmpty
            })
        }
        
        // 4
        addContactController.addAction(addContactAction)
        
        faultyActionController = addContactController
        
        // 5 Present Pop Up
        present(addContactController, animated: true, completion: nil)
        
    }
}




// Not in use, look in UserController for reason
//        UserController.shared.fetchFriends(forFriends: currentUser.friendsFamily) { (friends) in
//            if let friends = friends {
//                self.updateUI(with: friends)
//            }
//        }
