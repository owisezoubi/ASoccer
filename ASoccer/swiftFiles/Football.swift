//
//  Football.swift
//  ASoccer
//
//  Created by owise zoubi on 04/07/2019.
//

import Foundation

class Football : NSObject {
    let SERVICE_NAME = "Football"
    
    let backendless = Backendless.sharedInstance()!
    
    static let sharedInstance : Football = {
        let instance = Football()
        return instance
    }()
    
    // sync
    
    func getCompetitionStandingbyId(competitionID: String) -> Any {
        
        return backendless.customService.invoke(SERVICE_NAME, method:"getCompetitionStandingbyId", args:[competitionID]) as! Any
    }
    
    func getAllCompetitions() -> Any {
        
        return backendless.customService.invoke(SERVICE_NAME, method:"getAllCompetitions", args:[]) as! Any
    }
    
    func getTeamInfobyId(teamID: String) -> Any {
        
        return backendless.customService.invoke(SERVICE_NAME, method:"getTeamInfobyId", args:[teamID]) as! Any
    }
    
    // async
    
    func getCompetitionStandingbyId(competitionID: String, response responseBlock:@escaping(Any?)->(), error errorBlock:@escaping(Fault?)->()) -> Void {
        backendless.customService.invoke(SERVICE_NAME, method:"getCompetitionStandingbyId", args:[competitionID], response:responseBlock, error:errorBlock)
    }
    
    func getAllCompetitions(response responseBlock:@escaping(Any?)->(), error errorBlock:@escaping(Fault?)->()) -> Void {
        backendless.customService.invoke(SERVICE_NAME, method:"getAllCompetitions", args:[], response:responseBlock, error:errorBlock)
    }
    
    func getTeamInfobyId(teamID: String, response responseBlock:@escaping(Any?)->(), error errorBlock:@escaping(Fault?)->()) -> Void {
        backendless.customService.invoke(SERVICE_NAME, method:"getTeamInfobyId", args:[teamID], response:responseBlock, error:errorBlock)
    }
    
}

