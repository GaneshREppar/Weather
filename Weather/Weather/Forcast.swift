//
//  Petitions.swift
//  Project07_Ditto
//
//  Created by Ganesh Eppar on 10/04/23.
//

import Foundation

struct Forcast: Codable {
    var cod: String
    var message: Int
    var cnt: Int
    var list: [List]
    var city: City
}
