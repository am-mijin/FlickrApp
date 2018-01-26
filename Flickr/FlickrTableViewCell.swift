//
//  TableViewCell.swift
//  Flickr
//
//  Created by Mijin Cho on 24/01/2018.
//  Copyright © 2018 Mijin Cho. All rights reserved.
//

import UIKit

class FlickrTableViewCell: UITableViewCell {
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
