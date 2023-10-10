//
//  Environment.swift
//  FirebaseDB
//
//  Created by Владислава on 10.10.23.
//

import Foundation
import FirebaseDatabase

struct Environment {
    static let ref = Database.database(url: "https://testproject-b42c4-default-rtdb.firebaseio.com/").reference()
}

