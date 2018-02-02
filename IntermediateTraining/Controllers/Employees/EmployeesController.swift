//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 21/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit
import CoreData 

class EmployeesController: UITableViewController, EntityDelegate {
    
    var company: Company? {
        didSet {
            if let company = self.company {
                self.navigationItem.title = company.name
            }
        }
    }
    
    var employees = [[Employee]]()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        setupPlusButton(#selector(handlePlusButton))
        self.employees = CoreDataManager.shared.fetchEmployees(company)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .teelColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        let employee = self.employees[indexPath.section][indexPath.row]
        var nameText = ""
        
        if let name = employee.name {
            nameText = name
        }
        
        if let birthday = employee.detail?.birthday {
            nameText = "\(nameText) (\(birthday.localDateString(.medium)))"
        }
        
        cell.textLabel?.text = nameText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employees[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.employees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = getTypeName(index: section)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func handlePlusButton(){
        let createEmployeeController = CreateEmployeeController()
        setBackButtonTitle("Cancel")
        createEmployeeController.delegate = self
        createEmployeeController.company = self.company
        navigationController?.pushViewController(createEmployeeController, animated: true)
    }
    
    //MARK: - delegates
    func didAdd(entity: NSManagedObject) {
        guard let employee = entity as? Employee, let type = employee.type else { return }
        let index = getTypeIndex(type: type)
        employees[index].append(employee)
        let indexPath = IndexPath(row: employees[index].count - 1, section: index)
        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    func didEdit(entity: NSManagedObject) {
        guard let employee = entity as? Employee, let type = employee.type else { return }
        let index = getTypeIndex(type: type)
        guard let row = self.employees[index].index(of: employee) else { return }
        let indexPath = IndexPath(row: row, section: index)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func getTypeIndex(type: String) -> Int {
        guard let employeeType = EmployeeType(rawValue: type) else { return 3 }
        return employeeType.hashValue
    }
    
    private func getTypeName(index: Int) -> String {
        return EmployeeType.from(hashValue: index).rawValue
    }
}
