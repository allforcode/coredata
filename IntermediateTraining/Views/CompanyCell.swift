//
//  CompanyCell.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 21/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit


class CompanyCell: UITableViewCell {
    
    static let imageCache = NSCache<NSString, NSData>()
    var company: Company? {
        didSet {
            if let company = self.company {
                print("didset a company for \(company.name!)")
                var textString: String = ""
        
                if let name = company.name, let founded = company.founded {
                    let dateString = founded.localDateString(.medium)
                    textString = "\(name) (\(dateString))"
                }else{
                    textString = company.name ?? ""
                }
        
                nameFoundedDateLabel.text = textString

                guard let nsName = company.name as NSString? else { return }
                print("get cache key for \(company.name!)")

                if let companyImageData = CompanyCell.imageCache.object(forKey: nsName) {
                    print("get image from cache for \(company.name!)")
                    DispatchQueue.main.async {
                        let data = Data(referencing: companyImageData)
                        self.companyImageView.image = UIImage(data: data)
                    }
                }else{
                    if let photoData = company.imageData, let companyImage = UIImage(data: photoData){
                        print("get image from data for \(company.name!)")
                        CompanyCell.imageCache.setObject(photoData as NSData, forKey: nsName)
                        DispatchQueue.main.async {
                            self.companyImageView.image = companyImage
                        }
                    }
                }
            }
        }
    }

    let companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let l = UILabel()
        l.text = "Name"
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.teelColor
        
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
