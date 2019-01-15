//
//  EtudiantTableViewCell.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 11/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit

class EtudiantTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var niveauLabel: UILabel!
    @IBOutlet weak var filiereLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
