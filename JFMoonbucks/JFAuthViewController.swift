//
//  JFAuthViewController.swift
//  JFMoonbucks
//
//  Created by Jonyzfu on 4/2/15.
//  Copyright (c) 2015 Jonyzfu. All rights reserved.
//

import UIKit

import LocalAuthentication

@objc class JFAuthViewController: UITabBarController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateUser()

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPasswordAlert() {
        var passwordAlert: UIAlertView = UIAlertView(title: "Moonbucks", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == "moon" {
                    
                } else {
                    showPasswordAlert()
                }
            } else {
                showPasswordAlert()
            }
        }
    }
    
    func authenticateUser() {
        // Get the local authentication context
        let context : LAContext = LAContext()
        
        // Declare a NSError variable
        var error : NSError?
        
        // Set the reason string that will appear on the authentication aler
        var reasonString = "Authentication is needed to access your app."
        
        // Check if the device can evaluate the policy
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if success {
                    
                } else {
                    // If authentication failed then show a message to the console with a short description
                    // In case that the error is a user fallback, then show the password alert view
                    switch evalPolicyError!.code {
                    case LAError.SystemCancel.rawValue:
                        println("Authentication was cancelled by the system")
                    case LAError.UserCancel.rawValue:
                        println("Authentication was cancelled by the user")
                    case LAError.UserFallback.rawValue:
                        println("User selected to enter custom password")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    default:
                        println("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            // self.showPasswordAlert()
                        })
                    }
                    
                }
            })]
        } else {
            // If the security policy cannot be evaluted then show a short message depending on the error
            switch error!.code {
            case LAError.TouchIDNotEnrolled.rawValue:
                println("TouchID is not enrolled")
            case LAError.PasscodeNotSet.rawValue:
                println("A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case
                println("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console
            println(error?.localizedDescription)
            
            // Show the custom alert view to allow users to enter the password
            self.showPasswordAlert()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
