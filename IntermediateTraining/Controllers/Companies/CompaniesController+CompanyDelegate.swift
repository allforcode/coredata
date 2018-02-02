//
//  CompaniesController+CompanyDelegate.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 21/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit
import CoreData

extension CompaniesController: NSFetchedResultsControllerDelegate {

    //MARK: - delegates
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("type: \(type.rawValue)")
        
        if let indexPath = indexPath {
            print("indexPath: \(indexPath)")
        }else{
            print("indexPath: nil")
        }
        
        if let newindexPath = newIndexPath {
            print("newindexPath: \(newindexPath)")
        }else{
            print("newindexPath: nil")
        }
        
        let company = anObject as! Company
        
        switch type {
        case .insert:
            company.setInitial()
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            company.setInitial()
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            //since name is the key of sortDescriptor, when modify name, it becomes move, the new
            //value actually saved, but the view doesn't update, so do following reload
            tableView.reloadData()
        }
    }
    
}

