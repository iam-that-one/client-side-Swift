//
//  Models.swift
//  Front-end
//
//  Created by Abdullah Alnutayfi on 10/08/2022.
//

import Foundation

struct ToDoPOST: Codable, Identifiable{
    let _id : String
    var id : String{
        _id
    }
    let toDoTitle : String
    let toDoDes : String
    let date : String
}
