//
//  WelcomeVC.swift
//  ASoccer
//
//  Created by owise zoubi on 04/07/2019.
//

import UIKit

@available(iOS 11.0, *)
class WelcomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var welcomeViewCompetitionsTableView: UITableView!
    @IBOutlet weak var welcomeSearchBar: UISearchBar!
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet var WelcomeViewVisualEffecttView: UIVisualEffectView!
    @IBOutlet var GradientView: GradientView!
    @IBOutlet var ProfileView: UIView!
    @IBOutlet weak var WelcomeViewProfileButton: UIBarButtonItem!
    @IBOutlet weak var ProfileViewUserName: UILabel!
    @IBOutlet weak var ProfileViewEmailAddress: UILabel!
    
    //initializing the visual effect(blurr) when the dialog appears
    var effect:UIVisualEffect!
    
    let APP_ID = "79381585-46F6-FF64-FF68-E807D7763500"
    let API_KEY = "96EB250C-CED3-C79D-FFE2-170E13194400"
    
    var CompID = CompetitionStandingVC()
    let backendless = Backendless.sharedInstance()!
    
    //array that contain all competitions from the JSON - still empty now
    var competitionsArray = [Competition]()
    var currentCompetition = [Competition]()
    var cellIndexPath = Int()
    var lightBlur: UIBlurEffect? = nil
    var blurView: UIVisualEffectView? = nil
    var competitionStandingVC = CompetitionStandingVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backendless.initApp(APP_ID, apiKey: API_KEY)
        
        //football class contains the codeless functions in Backendless server
        //getsAllCompetitions() method returning raw json data as planned in backendless Codeless method that created there
        //getJsonData will parse the JSON from backendless.getAllCompetitions to an Array of Competition(struct)
        getCompetitionJsonData()
        
        //blur settings for ProfileView
        lightBlur = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: lightBlur)
        ProfileView.layer.cornerRadius = 20
    }
    
    
    @IBAction func dismissProfileView(_ sender: Any) {
        blurView!.removeFromSuperview()
        animateOut(myView: ProfileView)
        welcomeView.isHidden = false
    }
    
    
    @IBAction func openProfileView(_ sender: Any) {
        let currentUser : BackendlessUser! = backendless.userService.currentUser
        ProfileViewUserName.text = currentUser.getProperty("userName") as! String?
        ProfileViewEmailAddress.text = currentUser.email as String?
        
        
        GradientView.addSubview(blurView!)
        animateIn(myView: ProfileView)
        welcomeView.isHidden = true
    }
    
    
    @IBAction func WelcomeViewUserSignOut(_ sender: Any) {
        if CheckInternet.Connection(){
            let backendless = Backendless.sharedInstance()!
            backendless.userService.logout()
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Signing Out", message: "Are you sure?", preferredStyle: .alert)
                
                let YesActionButton = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction)   in
                    DispatchQueue.main.async {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC-ID")
                        self.present(newViewController, animated: true, completion: nil)
                    }
                })
                let NoActionButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alertController.addAction(YesActionButton)
                alertController.addAction(NoActionButton)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            displayMessage(userMessage: "Connection Lost, Please reconnect to the Internet")
        }
    }
    
    
    @IBAction func ProfileViewDeleteUser(_ sender: Any) {
        if CheckInternet.Connection(){
            let currentUser : BackendlessUser! = backendless.userService.currentUser
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: " DELETING ACCOUNT", message: "Are you sure??", preferredStyle: .alert)
                
                let YesActionButton = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        let dataStore = self.backendless.data.ofTable("Users")
                        dataStore?.remove(byId: currentUser!.objectId as String?,
                                          response: {
                                            (num : NSNumber?) -> () in
                                            print("user deleted")
                                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                            let newViewController: UIViewController =   storyBoard.instantiateViewController(withIdentifier: "LoginVC-ID")
                                            self.present(newViewController, animated: true, completion: nil)
                        },
                                          error: {
                                            (fault : Fault?) -> () in
                                            print("Server reported an error: \(String(describing: fault))")
                        })
                    }
                })
                let NoActionButton = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alertController.addAction(YesActionButton)
                alertController.addAction(NoActionButton)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            displayMessage(userMessage: "Connection Lost, Please reconnect to the Internet")
        }
    }
    
    
    //function that parsing the JSON data from Backendless.getAllCompetition to an Array of COmpetition struct
    func getCompetitionJsonData(){
        let competitions = Football.sharedInstance.getAllCompetitions()
        let jsonData = try? JSONSerialization.data(withJSONObject: competitions)
        guard let data = jsonData else {return}
        do {
            self.competitionsArray = try JSONDecoder().decode([Competition].self, from: data)
        } catch let jsonErr{
            print("Error serializing json:", jsonErr )
        }
        currentCompetition = competitionsArray
    }
    
    
    ////////////// Table View /////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCompetition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompetitionsTableViewCell
        cell.cellCompName.text = currentCompetition[indexPath.row].name
        cell.cellCompRegion.text = currentCompetition[indexPath.row].region
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if CheckInternet.Connection(){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompetitionStandingVC") as! CompetitionStandingVC
            vc.competition = currentCompetition[indexPath.row]
            self.present(vc, animated: true, completion: nil)
        } else {
            displayMessage(userMessage: "Connection Lost, Please reconnect to the Internet")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    ////////////// SearchBar //////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentCompetition = competitionsArray
            welcomeViewCompetitionsTableView.reloadData()
            return
        }
        
        currentCompetition = competitionsArray.filter { (competition) -> Bool in
            guard let text = searchBar.text else { return false }
            return competition.name!.contains(text)
        }
        welcomeViewCompetitionsTableView.reloadData()
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    ////////////// Functions and utils ////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    //////////////                   //////////////
    
    
    
    
    fileprivate func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    fileprivate func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OkActionButton = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in ()
            })
            alertController.addAction(OkActionButton)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    fileprivate func animateIn(myView: UIView) {
        self.view.addSubview(myView)
        myView.center = self.view.center
        
        myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        myView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            myView.alpha = 1
            myView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut (myView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            myView.alpha = 0
        }) { (success:Bool) in
            myView.removeFromSuperview()
        }
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
