//
//  TeamInfo.swift
//  ASoccer
//
//  Created by owise zoubi on 05/07/2019.
//

import Foundation

struct TeamInfo: Decodable{
    let coach_name: String?
    let coach_id: String?
    let country: String?
    let founded: String?
    let is_national: String?
    let leagues: String?
    let name: String?
    let sidelined: [SideLined]?
    let squad: [Squad]?
    let statistics: [Statistics]?
    let teamid: String?
    let transfers_in: [TransfersIn]?
    let transfers_out: [TransfersOut]?
    let venue_address: String?
    let venue_capacity: String?
    let venue_city: String?
    let venue_id: String?
    let venue_name: String?
    let venue_surface: String?
}



struct TransfersOut: Decodable {
    let date: String?
    let id: String?
    let name: String?
    let team_id: String?
    let to_team: String?
    let type: String?
}


struct TransfersIn: Decodable {
    let date: String?
    let from_team: String?
    let id: String?
    let name: String?
    let team_id: String?
    let type: String?
}


struct Statistics: Decodable {
    let avg_first_goal_conceded: String?
    let avg_first_goal_conceded_away: String?
    let avg_first_goal_conceded_home: String?
    let avg_first_goal_scored: String?
    let avg_first_goal_scored_away: String?
    let avg_first_goal_scored_home: String?
    let avg_goals_per_game_conced: String?
    let avg_goals_per_game_conceded_aw: String?
    let avg_goals_per_game_conceded_ho: String?
    let avg_goals_per_game_scor: String?
    let avg_goals_per_game_scored_aw: String?
    let avg_goals_per_game_scored_ho: String?
    let biggest_defeat: String?
    let biggest_defeat_away: String?
    let biggest_defeat_home: String?
    let clean_shee: String?
    let clean_sheets_aw: String?
    let clean_sheets_ho: String?
    let draws: String?
    let draws_away: String?
    let draws_home: String?
    let failed_to_score: String?
    let failed_to_score_away: String?
    let failed_to_score_home: String?
    let oal: String?
    let goals_away: String?
    let goals_conceded: String?
    let goals_conceded_away: String?
    let goals_conceded_home: String?
    let goals_home: String?
    let osse: String?
    let losses_away: String?
    let losses_home: String?
    let an: String?
    let scoring_minutes_0_15_cnt: String?
    let scoring_minutes_0_15_pct: String?
    let scoring_minutes_15_30_cnt: String?
    let scoring_minutes_15_30_pct: String?
    let scoring_minutes_30_45_cnt: String?
    let scoring_minutes_30_45_pct: String?
    let scoring_minutes_45_60_cnt: String?
    let scoring_minutes_45_60_pct: String?
    let scoring_minutes_60_75_cnt: String?
    let scoring_minutes_60_75_pct: String?
    let scoring_minutes_75_90_cnt: String?
    let scoring_minutes_75_90_pct: String?
    let wins: String?
    let wins_away: String?
    let wins_home: String?

}


struct Squad: Decodable {
    let age: String?
    let appearences: String?
    let assists: String?
    let goals: String?
    let id: String?
    let injured: String?
    let lineups: String?
    let minutes: String?
    let name: String?
    let number: String?
    let position: String?
    let redcards: String?
    let substitute_in: String?
    let substitute_out: String?
    let substitutes_on_bench: String?
    let yellowcards: String?
    let yellowred: String?
}

struct SideLined: Decodable {
    let description: String?
    let enddate: String?
    let id: String?
    let name: String?
    let startdate: String?
}

