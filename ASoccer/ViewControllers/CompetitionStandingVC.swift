//
//  CompetitionStandingVC.swift
//  ASoccer
//
//  Created by owise zoubi on 04/07/2019.
//

import UIKit

class CompetitionStandingVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    var competition: Competition?
    //array that contain all competitions from the JSON - still empty now
    var competitionStandingArray = [CompetitionStanding]()
    var currentCompetitionStandingArray = [CompetitionStanding]()
    
    
    @IBOutlet weak var CompetitionName: UILabel!
    @IBOutlet weak var CompetitionSeason: UILabel!
    @IBOutlet weak var competitionStandingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCompetitionStandingJsonData()
    }
    
    
    @IBAction func dismissToWelcomeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getCompetitionStandingJsonData(){
        let competitionStanding = Football.sharedInstance.getCompetitionStandingbyId(competitionID: competition!.id!)
        
        if JSONSerialization.isValidJSONObject(competitionStanding){
            let jsonData = try? JSONSerialization.data(withJSONObject: competitionStanding)
            guard let data = jsonData else {return}
            do {
                self.competitionStandingArray = try JSONDecoder().decode([CompetitionStanding].self, from: data)
                
            } catch let jsonErr{
                print("Error serializing json:", jsonErr )
            }
            currentCompetitionStandingArray = competitionStandingArray
            CompetitionSeason.text = competitionStandingArray[0].season
        } else {
            displayMessage(userMessage: "There is no data to show, try again later")
        }
        CompetitionName.text = competition?.name
    }
    
    
    
    ////////////// Table View /////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = UITableView.automaticDimension
        return currentCompetitionStandingArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "competitionStandingCell", for: indexPath) as! competitionStandingTableViewCell
        cell.teamGroup.isHidden = true
        cell.teamPosition.text = currentCompetitionStandingArray[indexPath.row].position
        cell.teamName.text = currentCompetitionStandingArray[indexPath.row].team_name
        
        //make the TeamName Label in lines to fit in the small screens
        cell.teamName.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.teamName.numberOfLines = 0
        
        cell.teamMP.text = currentCompetitionStandingArray[indexPath.row].round
        cell.teamW.text = currentCompetitionStandingArray[indexPath.row].overall_w
        cell.teamD.text = currentCompetitionStandingArray[indexPath.row].overall_d
        cell.teamL.text = currentCompetitionStandingArray[indexPath.row].overall_l
        cell.teamGS.text = currentCompetitionStandingArray[indexPath.row].overall_gs
        cell.teamGA.text = currentCompetitionStandingArray[indexPath.row].overall_ga
        cell.teamGD.text = currentCompetitionStandingArray[indexPath.row].gd
        cell.teamPts.text = currentCompetitionStandingArray[indexPath.row].points
        
        if currentCompetitionStandingArray[indexPath.row].comp_group !=  nil {
            
            if indexPath.row % 4 == 0 {
                cell.teamGroup.isHidden = false
                cell.backgroundColor = UIColor.init(hex: 46148204).withAlphaComponent(0.3)
                cell.teamGroup.text = currentCompetitionStandingArray[indexPath.row].comp_group
            } else {
                cell.backgroundColor = UIColor.white
            }
        } else {
            currentCompetitionStandingArray.sort { Int($0.position!)! < Int($1.position!)! }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
                    self.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(OkActionButton)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}
