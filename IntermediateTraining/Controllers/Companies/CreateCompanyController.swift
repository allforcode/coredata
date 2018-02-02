//
//  CreateCompanyController.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 13/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit
import CoreData

class CreateCompanyController: UIViewController, UITextFieldDelegate {
    
    //MARK: - propertyies
    var delegate: EntityDelegate?
    
    var company: Company? {
        didSet {
            guard let editCompany = company else { return }
            nameTextField.text = editCompany.name
            
            if let founded = editCompany.founded {
                datePicker.date = founded
            }
            
            if let imageData = CompanyCell.imageCache.object(forKey: company?.name as NSString!) {
                companyImageView.image = UIImage(data: Data(referencing: imageData))
            }
        }
    }
    
    //MARK: - subviews
    let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Text"
        //enable auto layout
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = .date
        dp.locale = Locale.current
        return dp
    }()
    
    lazy var companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty").withRenderingMode(.alwaysOriginal))
        iv.layer.cornerRadius = iv.frame.height / 2
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.darkBlue.cgColor
        iv.layer.borderWidth = 2
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCompanyImage)))
        return iv
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: - overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .darkBlue
        navigationItem.title = self.company == nil ? "Create Company" : "Edit Company"
        
        setupSaveButton(#selector(handleSaveButton))
    }
    
    //MARK: - setup
    func setupUI(){
        let margins = view.layoutMarginsGuide
        
        //setup top container view
        let lightBlueBackgroundView = setupLightBlueBackgroundView(margins, height: 350)
        
        //company imageView
        lightBlueBackgroundView.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: lightBlueBackgroundView.topAnchor, constant: 8).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: lightBlueBackgroundView.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //setup nameLabel
        lightBlueBackgroundView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //setup nameTextField
        lightBlueBackgroundView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 4).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        //setup datePicker
        lightBlueBackgroundView.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
    }
    
    //MARK: - delegates - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSaveButton()
        return true
    }
}

extension CreateCompanyController {
    //MARK: - handlers
    @objc private func handleSaveButton(){
        self.company == nil ? createCompany() : updateCompany()
    }
    
    @objc private func handleCompanyImage(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.navigationController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func updateCompany(){
        guard let editCompany = self.company, let name = nameTextField.text else { return }
        let founded = datePicker.date
        let context = CoreDataManager.shared.persistenContainer.viewContext
        editCompany.name = name
        editCompany.founded = founded
        
        if let image = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(image, 0.4)
            editCompany.imageData = imageData
        }
        
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save company", saveErr)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func createCompany(){
        guard let name = nameTextField.text else { return }
        let founded = datePicker.date
        let context = CoreDataManager.shared.persistenContainer.viewContext
        //insert a new object
        let newCompany = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context) as! Company
        //set property for this object
        newCompany.setValue(name, forKey: "name")
        newCompany.setValue(founded, forKey: "founded")
        
        if let image = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(image, 0.4)
            newCompany.setValue(imageData, forKey: "imageData")
        }
        
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save company", saveErr)
        }
        navigationController?.popViewController(animated: true)
    }
}
