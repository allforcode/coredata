//
//  CreateEmployeeController.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 21/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    var delegate: EntityDelegate?
    
    var company: Company?
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Name"
        //enable auto layout
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let l = UILabel()
        l.text = "Birthday"
        //enable auto layout
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/DD/YYYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let employeeTypeSegmentedControl: UISegmentedControl = {
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManagement.rawValue,
            EmployeeType.TeamLeader.rawValue,
            EmployeeType.Staff.rawValue
        ]
        
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 3
        sc.tintColor = .darkBlue
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create Employee"
        setupSaveButton(#selector(handleSaveButton))
        let margins = view.layoutMarginsGuide
        let lightBlueBackgroundView = setupLightBlueBackgroundView(margins, height: 150)
        
        //setup nameLabel
        lightBlueBackgroundView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //setup nameTextField
        lightBlueBackgroundView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 4).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        //setup birthdayLabel
        lightBlueBackgroundView.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //setup birthdayTextField
        lightBlueBackgroundView.addSubview(birthdayTextField)
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor, constant: 4).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        
        //setup employeeTypeSegmentedControl
        lightBlueBackgroundView.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: birthdayLabel.leftAnchor).isActive = true
        employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        employeeTypeSegmentedControl.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor, constant: -16).isActive = true
    }
    
    //MARK: - handlers
    @objc func handleSaveButton(){
        guard let name = nameTextField.text, let company = self.company else { return }
        guard let birthdayString = birthdayTextField.text else {
            Helper.showOkAlert(title: "Empty Birthday", message: "You have not entered a birthday.", controller: self)
            return
        }
        
        if birthdayString == "" {
            Helper.showOkAlert(title: "Empty Birthday", message: "You have not entered a birthday.", controller: self)
            return
        }
        
        guard let birthday = Date.get(dateString: birthdayString, format: "MM/dd/yyyy") else {
            Helper.showOkAlert(title: "Bad Date", message: "Birthday date entered not valid", controller: self)
            return
        }
        
        let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) ?? EmployeeType.Staff.rawValue
            
        let employeeDic: [String : Any] = [
            "name": name,
            "type": employeeType,
            "birthday":birthday
        ]
        
        let creationResult = CoreDataManager.shared.createEmployee(employeeDic, company: company)
        if let err = creationResult.error {
            print(err)
        }else{
            if let employee = creationResult.employee {
                delegate?.didAdd(entity: employee)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
