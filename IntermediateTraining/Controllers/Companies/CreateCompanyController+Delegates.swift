//
//  CreateCompanyController+Delegates.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 21/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit
import CoreData

extension CreateCompanyController:  UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    //MARK: - delegates - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //UIImagePickerControllerEditedImage
            companyImageView.image = editedImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //UIImagePickerControllerOriginalImage
            companyImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
