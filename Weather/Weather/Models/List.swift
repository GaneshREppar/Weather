//
//  Petition.swift
//  Project07_Ditto
//
//  Created by Ganesh Eppar on 10/04/23.
//

import Foundation

struct List: Codable {
    var dt: Int
    var main: TempDetails
    var weather: [Weather]
    var dt_txt: String
}
