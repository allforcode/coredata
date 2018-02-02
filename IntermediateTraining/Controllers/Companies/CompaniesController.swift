//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 13/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    let companyCellId = "companyCellId"

    lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        let context = CoreDataManager.shared.persistenContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "initial", ascending: true)
        ]
        
        let frc = NSFetchedResultsController<Company>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "initial", cacheName: nil)
        
        frc.delegate = self
        
        do { try frc.performFetch() } catch let err { print(err) }
        
        return frc
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationStyle()
        setupPlusButton(#selector(handlePlusButton))
        setupTableView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: companyCellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    //MARK: - setup
    private func setupTableView(){
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: companyCellId)
    }
    
    private func setupNavigationStyle(){
        view.backgroundColor = .white
        navigationItem.title = "Companies"

        setBackButtonTitle("Cancel")
        setupResetButton(#selector(handleReset))
    }
}

extension CompaniesController {
    
    //MARK: - handlers
    @objc private func handlePlusButton(){
        let createCompanyController = CreateCompanyController()
//        createCompanyController.delegate = self
        navigationController?.pushViewController(createCompanyController, animated: true)
    }
    
    @objc private func handleRefresh(){
        Service.shared.downloadCompaniesFromServer()
        self.refreshControl?.endRefreshing()
    }
    
    @objc private func handleReset(){
        print("reset")
        if let count = fetchedResultsController.fetchedObjects?.count {
            if count > 0 {
                let confirmController = UIAlertController(title: "Warning", message: "All companies will be removed", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: self.handleRemoveAll)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { ( _ ) in
                    confirmController.dismiss(animated: true, completion: nil)
                }
                confirmController.addAction(cancelAction)
                confirmController.addAction(okAction)
                present(confirmController, animated: true, completion: nil)
            }
        }
    }
    
    private func handleRemoveAll( _ action: UIAlertAction){
        CoreDataManager.shared.deleteAll()
//        CoreDataManager.shared.batchDelete()
//        try? fetchedResultsController.performFetch()
//        tableView.reloadData()
    }
}

