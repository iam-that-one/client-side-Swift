//
//  ViewModel.swift
//  Front-end
//
//  Created by Abdullah Alnutayfi on 07/08/2022.
//

import SwiftUI
import Foundation
import UIKit
class ViewModel : ObservableObject{
    @Published var toTos : [ToDoPOST] = []

    func http_request(HTTP_METHOD: String,id : String?,toDoTitle : String?, toDoDes : String?, endPoint : String?){
       let  url = URL(string: "http://localhost:2000/toDos/\(endPoint ?? "")")!
        var request = URLRequest(url: url)
        request.setValue("authToken",forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTP_METHOD
        if HTTP_METHOD != "GET"{
            let encoder = JSONEncoder()
            let body = ToDoPOST(_id:id ?? "" ,toDoTitle: toDoTitle ?? "", toDoDes: toDoDes ?? "", date: dateFormater.string(from: Date()))
                let jsonData = try? encoder.encode(body.self)
                request.httpBody = jsonData
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request ){(data, _, error) in
            if let error = error {
                print(error)
            }else{
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    if HTTP_METHOD == "GET"{
                    do{
                        let result = try JSONDecoder().decode([ToDoPOST].self, from: data)
                        print(result)
                        DispatchQueue.main.async {
                            self.toTos = []
                            self.toTos = result
                        }
                    }catch{
                        print(error)
                      }
                   }
                }
            }
        }
        task.resume()
    }
    var dateFormater : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en")
        formatter.timeStyle = .medium
        return formatter
    }()
}

