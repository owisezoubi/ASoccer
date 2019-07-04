//
//  CompetitionStanding.swift
//  ASoccer
//
//  Created by owise zoubi on 04/07/2019.
//

import Foundation
import UIKit

struct CompetitionStanding: Decodable {
    let comp_id: String?
    let season: String?
    let round: String?
    let stage_id: String?
    let comp_group: String?
    let country: String?
    let team_id: String?
    let team_name: String?
    let status: String?
    let recent_form: String?
    let position: String?
    let overall_gp: String?
    let overall_w: String?
    let overall_d: String?
    let overall_l: String?
    let overall_gs:String?
    let overall_ga: String?
    let home_gp: String?
    let home_w: String?
    let home_d: String?
    let home_l: String?
    let home_gs: String?
    let home_ga: String?
    let away_gp: String?
    let away_w: String?
    let away_d: String?
    let away_l: String?
    let away_gs: String?
    let away_ga: String?
    let gd: String?
    let points: String?
    let description: String?
}

