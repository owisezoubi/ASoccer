//
//  TeamInfoVC.swift
//  ASoccer
//
//  Created by owise zoubi on 06/07/2019.
//

import UIKit

class TeamInfoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
   
    
    
    
    @IBOutlet weak var TransferInTableView: UITableView!
    @IBOutlet weak var TransferOutTableView: UITableView!
    @IBOutlet weak var SideLinedTableView: UITableView!
    
    
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
        
//        TransferOutTableView.delegate = self
//        TransferOutTableView.dataSource = self
//        TransferInTableView.delegate = self
//        TransferInTableView.dataSource = self
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
        
        capacity.text = currentTeamInfo?.venue_capacity
        FoundedYear.text = currentTeamInfo?.founded
        
        CoachName.text = currentTeamInfo?.coach_name
        //make the CoachName Label in lines to fit in the small screens
        CoachName.lineBreakMode = NSLineBreakMode.byWordWrapping
        CoachName.numberOfLines = 0
    }

    /////////////  Tables View /////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == TransferInTableView{
            return (currentTeamInfo?.transfers_in!.count)!
        }
        if tableView == TransferOutTableView{
            return (currentTeamInfo?.transfers_out!.count)!
        }
        if tableView == SideLinedTableView{
            return (currentTeamInfo?.sidelined!.count)!
        }
        displayMessage(userMessage: "something went wrong with loading one of the Tables, please Retry Again Later")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TeamInfoTransferInTableViewCell()
        
        if tableView == TransferInTableView{
            cell = TransferInTableView.dequeueReusableCell(withIdentifier: "TeamInfoTransferInTableViewCell", for: indexPath) as! TeamInfoTransferInTableViewCell
            
            if currentTeamInfo?.transfers_in != nil {
                cell.name?.text = currentTeamInfo?.transfers_in![indexPath.row].name
                //make the name Label in lines to fit in the small screens
                cell.name.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.name.numberOfLines = 0
            
                cell.fromClub?.text = currentTeamInfo?.transfers_in![indexPath.row].from_team
                //make the fromClub Label in lines to fit in the small screens
                cell.fromClub.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.fromClub.numberOfLines = 0
                
                cell.date?.text = currentTeamInfo?.transfers_in![indexPath.row].date
                cell.type?.text = currentTeamInfo?.transfers_in![indexPath.row].type
            } else {
                cell.name?.text = "there is no Transfer In in the meantime :)"
            }
            return cell
        }
        
        if tableView == TransferOutTableView{
            let TransferOutCell = TransferOutTableView.dequeueReusableCell(withIdentifier: "TeamInfoTransferOutTableViewCell", for: indexPath) as! TeamInfoTransferOutTableViewCell
            
            if currentTeamInfo?.transfers_out != nil {
                TransferOutCell.name?.text = currentTeamInfo?.transfers_out![indexPath.row].name
                //make the name Label in lines to fit in the small screens
                TransferOutCell.name.lineBreakMode = NSLineBreakMode.byWordWrapping
                TransferOutCell.name.numberOfLines = 0
                
                
                TransferOutCell.toClub?.text = currentTeamInfo?.transfers_out![indexPath.row].to_team
                //make the toClub Label in lines to fit in the small screens
                TransferOutCell.toClub.lineBreakMode = NSLineBreakMode.byWordWrapping
                TransferOutCell.toClub.numberOfLines = 0
                
                TransferOutCell.date?.text = currentTeamInfo?.transfers_out![indexPath.row].date
                TransferOutCell.type?.text = currentTeamInfo?.transfers_out![indexPath.row].type
            } else {
                TransferOutCell.name?.text = "there is no Transfer Out in the meantime :)"
            }
            return TransferOutCell
        }
        
        if tableView == SideLinedTableView{
             let SideLinedCell = SideLinedTableView.dequeueReusableCell(withIdentifier: "TeamInfoSideLinedTableViewCell", for: indexPath) as! TeamInfoSideLinedTableViewCell
            if currentTeamInfo?.sidelined != nil {
                SideLinedCell.name?.text = currentTeamInfo?.sidelined![indexPath.row].name
                //make the name Label in lines to fit in the small screens
                SideLinedCell.name.lineBreakMode = NSLineBreakMode.byWordWrapping
                SideLinedCell.name.numberOfLines = 0
                
                SideLinedCell.startDate?.text = currentTeamInfo?.sidelined![indexPath.row].startdate
                SideLinedCell.endDate?.text = SideLinedCell.endDate?.text == nil ? currentTeamInfo?.sidelined![indexPath.row].enddate : "unknown"
            
                SideLinedCell.Desc?.text = currentTeamInfo?.sidelined![indexPath.row].description
                //make the description Label in lines to fit in the small screens
                SideLinedCell.Desc.lineBreakMode = NSLineBreakMode.byWordWrapping
                SideLinedCell.Desc.numberOfLines = 0
            } else {
                SideLinedCell.name?.text = "there is no SideLined in the meantime :)"
            }
            return SideLinedCell
        }
        
        return cell
    }
    
    
    
    
    
    ////////////// Collection View ///////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (currentTeamInfo?.squad!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamInfoCollectionViewCell", for: indexPath) as! TeamInfoCollectionViewCell
        
        cell.playerName?.text = currentTeamInfo?.squad![indexPath.row].name
        //make the TeamName Label in lines to fit in the small screens
        cell.playerName.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.playerName.numberOfLines = 0
        
        cell.playerNumber?.text = currentTeamInfo?.squad![indexPath.row].number
        print(currentTeamInfo?.squad![indexPath.row].number)
        
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
