//
//  Service.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 29/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Service {
    
    private init() {}
    
    static let shared = Service()
    
    private let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer(){
        print("downloadCompaniesFromServer")
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = CoreDataManager.shared.persistenContainer.viewContext
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print("Failed to download companies", err)
                    return
                }

                guard let data = data else { return }
                let jsonDecoder = JSONDecoder()
                
                do {
                    let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                    let numberOfCompanies = jsonCompanies.count
                    var processed = 0
                    
                    jsonCompanies.forEach({ (jsonCompany) in
                        print(jsonCompany.name)
                        
                        if let url = URL(string: jsonCompany.photoUrl) {
                            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                                if let err = error {
                                    print(err)
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    let company = Company(context: privateContext)
                                    company.name = jsonCompany.name
                                    print("get photo url for \(company.name!)")
                                    company.founded = Date.get(dateString: jsonCompany.founded, format: "MM/dd/yyyy")
                                    company.imageData = data
                                    
                                    if let nsData = data as NSData? {
                                        CompanyCell.imageCache.setObject(nsData, forKey: company.name as NSString!)
                                        print("save imageData for \(company.name!)")
                                    }
                                    
                                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                                        print(" - \(jsonEmployee.name)")
                                        let employee = Employee(context: privateContext)
                                        employee.name = jsonEmployee.name
                                        employee.type = jsonEmployee.type
                                        employee.detail = EmployeeInformation(context: privateContext)
                                        employee.detail?.birthday = Date.get(dateString: jsonEmployee.birthday, format: "MM/dd/yyyy")
                                        employee.company = company
                                    })
                                    
                                    processed += 1
                                    
                                    if processed >= numberOfCompanies {
                                        do {
                                            try privateContext.save()
                                            try privateContext.parent?.save()
                                            print("context saved")
                                        }catch let err {
                                            print(err)
                                        }
                                    }
                                }
                            }).resume()
                        }
                    })
                }catch let err {
                    print(err)
                }
            }.resume()
        }
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    let photoUrl: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
