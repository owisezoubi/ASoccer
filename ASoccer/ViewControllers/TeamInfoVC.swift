//
//  TeamInfoVC.swift
//  ASoccer
//
//  Created by owise zoubi on 06/07/2019.
//

import UIKit

class TeamInfoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var ClubName: UILabel!
    @IBOutlet weak var Country: UILabel!
    @IBOutlet weak var StadiumName: UILabel!
    @IBOutlet weak var StadiumCity: UILabel!
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var FoundedYear: UILabel!
    @IBOutlet weak var CoachName: UILabel!
    
    var teamID: String?
    var competition: Competition?

    
    var teamInfo: TeamInfo?
    var currentTeamInfo: TeamInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //football class contains the codeless functions in Backendless server
        //getTeamInfoDataJsonData() method returning raw json data as planned in backendless Codeless method that created there
        //getJsonData will parse the JSON from backendless.getTeamInfoDataJsonData to an Array of CompetitionStanding(struct)
        getTeamInfoJsonData()
        
        fillingTheDataIntoLabels()
    }
    
    
    @IBAction func goBackToCompetitionStanding(_ sender: Any) {
        if CheckInternet.Connection(){
            var vc = self.storyboard?.instantiateViewController(withIdentifier: "CompetitionStandingVC") as!    CompetitionStandingVC
            vc.competition = competition
            dismiss(animated: true, completion: nil)
        } else {
            displayMessage(userMessage: "Connection Lost, Please reconnect to the Internet")
        }
    }
    
    
    
   fileprivate func getTeamInfoJsonData(){
    var teamInfo = Football.sharedInstance.getTeamInfobyId(teamID: teamID!)
    if JSONSerialization.isValidJSONObject(teamInfo){
            if JSONSerialization.isValidJSONObject(teamInfo){
                let jsonData = try? JSONSerialization.data(withJSONObject: teamInfo)
                guard let data = jsonData else {return}
                do {
                    teamInfo = try JSONDecoder().decode(TeamInfo.self, from: data)
                } catch let jsonErr{
                    print("Error serializing json:", jsonErr )
                }
                self.currentTeamInfo = (teamInfo as! TeamInfo)
                } else {
                    displayMessage(userMessage: "There is no data to show, try again later")
                }
        } else{
            displayMessage(userMessage: "There is no data to show, try again later")
        }
    }

    fileprivate func fillingTheDataIntoLabels(){
        ClubName.text = currentTeamInfo?.name
        Country.text = currentTeamInfo?.country
        
        StadiumName.text = currentTeamInfo?.venue_name
        //make the StadiumCity Label in lines to fit in the small screens
        StadiumName.lineBreakMode = NSLineBreakMode.byWordWrapping
        StadiumName.numberOfLines = 0

        
        StadiumCity.text = currentTeamInfo?.venue_city
        //make the StadiumCity Label in lines to fit in the small screens
        StadiumCity.lineBreakMode = NSLineBreakMode.byWordWrapping
        StadiumCity.numberOfLines = 0

        capacity.text = currentTeamInfo?.venue_capacity
        FoundedYear.text = currentTeamInfo?.founded
        
        CoachName.text = currentTeamInfo?.coach_name
        //make the CoachName Label in lines to fit in the small screens
        CoachName.lineBreakMode = NSLineBreakMode.byWordWrapping
        CoachName.numberOfLines = 0
    }
    
    
    ////////////// Comllection View ///////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (currentTeamInfo?.squad!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamInfoCollectionViewCell", for: indexPath) as! TeamInfoCollectionViewCell
        
        cell.playerName?.text = currentTeamInfo?.squad![indexPath.row].name
        //make the TeamName Label in lines to fit in the small screens
        cell.playerName.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.playerName.numberOfLines = 0
        
        cell.playerAge?.text = currentTeamInfo?.squad![indexPath.row].number
        
        return cell
    }
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    ////////////// Functions and utils ////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    //////////////                   //////////////
    
    
        fileprivate func displayMessage(userMessage:String) -> Void {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error accurred", message: userMessage, preferredStyle: .alert)
                
                let OkActionButton = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                    DispatchQueue.main.async {
//                        self.dismiss(animated: true, completion: nil)
                    }
                })
                alertController.addAction(OkActionButton)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
}
