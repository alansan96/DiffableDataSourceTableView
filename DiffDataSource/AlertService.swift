//
//  AlertService.swift
//  DiffDataSource
//
//  Created by Alan Santoso on 14/10/20.
//

import Foundation
import UIKit

struct AlertService {
    
    func createUserAlert(completion: @escaping(String) ->()) -> UIAlertController{
        let alert = UIAlertController(title: "Create Yser", message: nil, preferredStyle: .alert)
        alert.addTextField{ $0.placeholder = "Enter user's name"}
        let action = UIAlertAction(title: "Save", style: .default) { (_) in
            let userName = alert.textFields?.first?.text ?? ""
            completion(userName)
        }
        alert.addAction(action)
        
        return alert
    }
    
}
