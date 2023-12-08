//
//  Itineraries.swift
//  final 2
//
//  Created by Jhala family on 20/11/23.
//

import Foundation

struct Itinerary: Identifiable, Codable {
    var id = UUID()
    var country: String
    var startdate: Date
    var iscompleted: Bool
    var enddate: Date
    var days: Int
    var totalcost: Int = 0
    var currency: String 
    
    var places: [Place]
    struct Place: Identifiable, Codable {
        var id = UUID()
        var placename: String
        var details: String 
        var address: String
        var startDate: Date
        var endDate: Date
    }
}
