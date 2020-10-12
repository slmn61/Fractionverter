//
//  CellView.swift
//  Fractionverter
//
//  Created by selman birinci on 10/6/20.
//

import UIKit

class Cell: UITableViewCell{
    @IBOutlet weak var fraction: UILabel!
    @IBOutlet weak var decimal: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
    
}
