//
//  CoreDataManager.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 14/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistenContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntermediateTrainingModels")
        container.loadPersistentStores(completionHandler: { (desc, error) in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        })
        return container
    }()
    
    func fetchCompanies() -> [Company]{
        print("fetchCompanies")
        let context = persistenContainer.viewContext
        let request = NSFetchRequest<Company>(entityName: "Company")
        var companies = [Company]()
        do{
            companies = try context.fetch(request)
        }catch let fetchErr {
            print("Failed to fetch companies", fetchErr)
        }
        return companies
    }
    
    func fetchEmployees(_ company: Company?) -> [[Employee]]{
        print("fetchEmployees")
        
        var allEmmployees = [[Employee]]()
//        let startTime = Date.timeIntervalSinceReferenceDate
        
        if let company = company, let employees = company.employees?.allObjects as? [Employee] {
            
            let employeeTypes = [
                EmployeeType.Executive.rawValue,
                EmployeeType.SeniorManagement.rawValue,
                EmployeeType.TeamLeader.rawValue,
                EmployeeType.Staff.rawValue
            ]
            
            employeeTypes.forEach({ (employeeType) in
                allEmmployees.append( employees.filter({ (e) -> Bool in
                    let type = e.type ?? EmployeeType.Staff.rawValue
                    return type == employeeType
                }))
            })

//            var executive = [Employee]()
//            var seniorManagement = [Employee]()
//            var teamLeader = [Employee]()
//            var staff = [Employee]()
//
//            employees.forEach({ (employee) in
//                let employeeType = employee.type ?? ""
//
//                switch employeeType {
//                case EmployeeType.Executive.rawValue:
//                    executive.append(employee)
//                case EmployeeType.SeniorManagement.rawValue:
//                    seniorManagement.append(employee)
//                case EmployeeType.TeamLeader.rawValue:
//                    teamLeader.append(employee)
//                default:
//                    staff.append(employee)
//                }
//            })
//
//
//
//           allEmmployees = [executive, seniorManagement, teamLeader, staff]
        }
//        let endTime = Date.timeIntervalSinceReferenceDate
//        print(endTime - startTime)
        return allEmmployees
    }
    
    func createEmployee(_ dictionary: [String: Any], company: Company) -> (employee: Employee?, error: Error?) {
        let context = persistenContainer.viewContext
        //insert a new object
        let newEmployee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        //set property for this object
//        newEmployee.setValue(name, forKey: "name")
        
        guard let name = dictionary["name"] as? String, let birthday = dictionary["birthday"] as? Date, let type = dictionary["type"] as? String else { return (nil, nil)}
        
        newEmployee.name = name
        newEmployee.type = type
        newEmployee.company = company
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employeeInformation.birthday = birthday
        newEmployee.detail = employeeInformation
        
        do {
            try context.save()
            print("Employee saved")
            return (newEmployee, nil)
        } catch let saveErr {
            print("Failed to save company", saveErr)
            return (nil, saveErr)
        }
    }
    
    func deleteAll(){
        do {
            let context = persistenContainer.viewContext
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = context
            let requestForCompany: NSFetchRequest<Company> = Company.fetchRequest()
            let companies = try privateContext.fetch(requestForCompany)
            companies.forEach({ (company) in
                print("will delete company: \(company.name ?? "")")
                if let employees = company.employees?.allObjects as? [Employee] {
                    employees.forEach({ (employee) in
                        print(" - will delete employee: \(company.name ?? "")")
                        privateContext.delete(employee)
                    })
                    privateContext.delete(company)
                }
            })
            try privateContext.save()
            try privateContext.parent?.save()
        }catch let err {
            print(err)
        }
    }
    
    func batchDelete(){
        do {
            let context = persistenContainer.viewContext
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = context
            var fetchRequest: NSFetchRequest<NSFetchRequestResult> = Company.fetchRequest()
            var batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            try privateContext.execute(batchDeleteRequest)
            print("all companies should be removed")
            fetchRequest = Employee.fetchRequest()
            batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)


            try privateContext.execute(batchDeleteRequest)
            print("all employees should be removed")
            
            privateContext.reset()
            privateContext.parent?.reset()

        }catch let err {
            print(err)
        }
    }
}
