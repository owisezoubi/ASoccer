//
//  LoginVC.swift
//  ASoccer
//
//  Created by owise zoubi on 04/07/2019.
//

import UIKit

@available(iOS 11.0, *)
class LoginVC: UIViewController {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var copyRightsLabel: UILabel!
    
    //Login View Initialize
    @IBOutlet var LogInView: UIView!
    //log in view Activity Indicator
    @IBOutlet weak var myActivityIndicator:     UIActivityIndicatorView!
    
    @IBOutlet weak var loginViewLoginButton: CustomButton!
    @IBOutlet weak var loginViewSignUpButton: CustomButton!
    @IBOutlet weak var LoginUserName: UITextField!
    @IBOutlet weak var LoginPassword: UITextField!
    @IBOutlet weak var getStartedButton: CustomButton!
    
    //Register View Initialize
    @IBOutlet weak var RegisterViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var SignUpView: UIView!
    @IBOutlet weak var RegisterUserName: UITextField!
    @IBOutlet weak var RegisterPassword: UITextField!
    @IBOutlet weak var RegisterConfirmPassword: UITextField!
    @IBOutlet weak var RegisterEmailAddress: UITextField!
    
    @IBOutlet weak var RegisterButton: CustomButton!
    
    
    //Backendless things
    let APP_ID = "79381585-46F6-FF64-FF68-E807D7763500"
    let API_KEY = "96EB250C-CED3-C79D-FFE2-170E13194400"
    let backendless = Backendless.sharedInstance()!
    let SERVER_URL = "https://api.backendless.com"
    
    
    //initializing the visual effect(blurr) when the dialog appears
    var effect:UIVisualEffect!
    
    //setting the status bar (battery, clock...) to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyRightsLabel.text = "© all rights are reserved";
        
        //setting a background and border color for The main View button
        getStartedButton.setupBGColor(bgColor: UIColor.orange)
        getStartedButton.setupBorderColor(BorderColor: UIColor.black)
        
        //setting for LOG IN Button in LogIn View
        loginViewLoginButton.setupBGColor(bgColor: UIColor.clear)
        loginViewLoginButton.setupBorderColor(BorderColor: UIColor.blue)
        
        //setting for SIGN UP Button in LogIn View
        loginViewSignUpButton.setupBGColor(bgColor: UIColor.clear)
        loginViewSignUpButton.setupBorderColor(BorderColor: UIColor.green)
        
        //setting for SIGN UP Button in Register View
        RegisterButton.setupBGColor(bgColor: UIColor.clear)
        RegisterButton.setupBorderColor(BorderColor: UIColor.red)
        
        //view settings
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        LogInView.layer.cornerRadius = 20
        SignUpView.layer.cornerRadius = 20
        
        //backendless initialize
        backendless.initApp(APP_ID, apiKey: API_KEY)
        backendless.hostURL = SERVER_URL
        
        //hide the Activity Indicator at the beginning
        myActivityIndicator.isHidden = true
    }
    
    @IBAction func ViewMainView(_ sender: AnyObject) {
        animateIn(myView: LogInView)
        getStartedButton.isHidden = true
        
    }
    
    //////////////// Login View ////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    //////////////                   //////////////
    
    @IBAction func dismissPopUp(_ sender: AnyObject) {
        LoginPassword.text = ""
        LoginUserName.text = ""
        
        animateOut(myView: LogInView)
        getStartedButton.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginViewSignUpButton(_ sender: Any) {
        LoginPassword.text = ""
        LoginUserName.text = ""
        animateOut(myView: LogInView)
        animateIn(myView: SignUpView)
        
        //hide the Activity Indicator in Register View at the beginning
        RegisterViewActivityIndicator.isHidden = true
    }
    
    @IBAction func LoginViewLogInButton(_ sender: Any) {
        let backendless = Backendless.sharedInstance()!
        
        loginViewLoginButton.shake()
        
        if (LoginUserName.text?.isEmpty)! || (LoginPassword.text?.isEmpty)!  {
            
            displayMessage(userMessage: "must fill all the fields")
            return
        }
        
        //show the Activity Indicator
        myActivityIndicator.isHidden = false
        
        //start the Activity Indicator
        myActivityIndicator.startAnimating()
        
        let loginName = LoginUserName.text
        let loginPassword = LoginPassword.text
        
        backendless.userService.login(loginName,
                                      password: loginPassword,
                                      response: {
                                        (loggedUser : BackendlessUser?) -> Void in
                                        self.removeActivityIndicator(activityIndicator: self.myActivityIndicator)
                                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                                        self.present(VC, animated: true, completion: nil)
        },
                                      error: {
                                        (fault : Fault?) -> Void in
                                        //removing the activity indicator from the view
                                        self.removeActivityIndicator(activityIndicator: self.myActivityIndicator)
                                        
                                        //getting the understandable string from the error
                                        var mySubstring = fault?.description.slice(from: "[", to: "]")
                                        
                                        //cleaning the login Password text field
                                        self.LoginPassword.text = ""
                                        
                                        //replacing the 'connection offline' message to a good one
                                        if mySubstring == "NSURLErrorDomain" {
                                            //getting the understandable string from the error
                                            mySubstring = fault?.description.slice(from: "<", to: ">")
                                        }
                                        //displaying an alert message containing the error
                                        self.displayMessage(userMessage: "\(mySubstring!)")
        })
    }
    
    //////////////// Register View ////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    //////////////                   //////////////
    
    @IBAction func RegisterViewSignUpButton(_ sender: Any) {
        RegisterButton.shake()
        
        let user = BackendlessUser()
        let userDefaults = UserDefaults.standard
        let userName = RegisterUserName.text!
        let password = RegisterPassword.text!
        
        if (RegisterUserName.text?.isEmpty)! || (RegisterPassword.text?.isEmpty)! || (RegisterConfirmPassword.text?.isEmpty)! || (RegisterEmailAddress.text?.isEmpty)! {
            
            displayMessage(userMessage: "must fill all the fields")
            return
        }
        
        //if we met all the request in the field.
        if userName.count<5 && password.count<5
        {
            displayMessage(userMessage: "User Name/Passwors must be at least 5 characters")
            return
        }
        
        //if the two password are the same
        if (RegisterPassword.text!.elementsEqual(RegisterConfirmPassword.text!)) != true
        {
            displayMessage(userMessage: "Password not matching")
            return
        }
        
        //check if password less than 5 elements
        if RegisterPassword.text!.count <= 5 || RegisterConfirmPassword.text!.count <= 5
        {
            displayMessage(userMessage: "Password must be at least 6 characters")
            return
        }
        
        //check if we have a name like we want to save
        if userDefaults.object(forKey: password) != nil
        {
            displayMessage(userMessage: "User Name is already used")
            return
        }
        
        //show the Activity Indicator
        RegisterViewActivityIndicator.isHidden = false
        
        //start the Activity Indicator
        RegisterViewActivityIndicator.startAnimating()
        
        user.setProperty("email", object: RegisterEmailAddress!.text)
        user.setProperty("userName", object: RegisterUserName!.text)
        user.password = RegisterPassword!.text as NSString?
        
        backendless.userService.register(user, response: { (registredUser) in
            //removing the activity indicator from the view
            self.removeActivityIndicator(activityIndicator: self.RegisterViewActivityIndicator)
            
            self.displayMessage(userMessage: "User registered Successfully!")
            
            self.emptyTheRegisterViewTextFields()
            
            self.animateOut(myView: self.SignUpView)
            self.animateIn(myView: self.LogInView)
        },
                                         
                                         error: { (fault:Fault?) in
                                            //removing the activity indicator from the view
                                            self.removeActivityIndicator(activityIndicator: self.RegisterViewActivityIndicator)
                                            
                                            //getting the understandable string from the error
                                            var mySubstring = fault?.description.slice(from: "[", to: "]")
                                            
                                            //replacing the 'connection offline' message to a good one
                                            if mySubstring == "NSURLErrorDomain" {
                                                //getting the understandable string from the error
                                                mySubstring = fault?.description.slice(from: "<", to: ">")
                                            }
                                            
                                            //cleaning the login Password text field
                                            self.RegisterPassword.text = ""
                                            self.RegisterConfirmPassword.text = ""
                                            
                                            //displaying an alert message containing the error
                                            self.displayMessage(userMessage: "\(mySubstring!)")
        })
    }
    
    
    @IBAction func dismissSignUp(_ sender: Any) {
        RegisterUserName.text = ""
        RegisterPassword.text = ""
        RegisterConfirmPassword.text = ""
        RegisterEmailAddress.text = ""
        
        animateOut(myView: SignUpView)
        animateIn(myView: LogInView)
    }
    
    ////////////// Functions and utils ////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    
    fileprivate func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    fileprivate func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            let OkActionButton = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                DispatchQueue.main.async {
                }
            })
            alertController.addAction(OkActionButton)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func animateIn(myView: UIView) {
        self.view.addSubview(myView)
        myView.center = self.view.center
        myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        myView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            myView.alpha = 1
            myView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut (myView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            myView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success:Bool) in
            myView.removeFromSuperview()
        }
    }
    
    
    fileprivate func emptyTheRegisterViewTextFields(){
        self.RegisterUserName.text = ""
        self.RegisterPassword.text = ""
        self.RegisterConfirmPassword.text = ""
        self.RegisterEmailAddress.text = ""
    }
    
}
extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
