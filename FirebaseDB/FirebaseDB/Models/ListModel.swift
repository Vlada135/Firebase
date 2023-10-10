//
//  ListModel.swift
//  FirebaseDB
//
//  Created by Владислава on 10.10.23.
//

import Foundation

struct List: Editable {
    var id: String?
    let title: String
    let doctor: String?
    let clinic: String
    let subtitle: String?
    let date: Date
    
    
    var asDict: [String: Any] {
        var dict = [String: Any]()
        dict["title"] = title
        dict["doctor"] = doctor
        dict["clinic"] = clinic
        dict["subtitle"] = subtitle
        dict["date"] = date.timeIntervalSince1970
        return dict
    }
    
    init(
        id: String? = nil,
        title: String,
        doctor: String? = nil,
        clinic: String,
        subtitle: String? = nil,
        date: Date
    ) {
        self.id = id
        self.title = title
        self.doctor = doctor
        self.clinic = clinic
        self.subtitle = subtitle
        self.date = date
    }
    
    init(key: String, dict: [String: Any]) throws {
        guard let title = dict["title"] as? String,
              let clinic = dict["clinic"] as? String,
              let date = dict["date"] as? Double
        else {
            let error = "Parsing contact error"
            print("[Contact parser] \(error)")
            throw error
        }
        
            self.id = key
            self.title = title
            self.doctor = dict["doctor"] as? String
            self.clinic = clinic
            self.subtitle = dict["subtitle"] as? String
            self.date = Date(timeIntervalSince1970: date)
    }
}

extension String: Error {}

protocol Editable {
    var id: String? { get }
}

