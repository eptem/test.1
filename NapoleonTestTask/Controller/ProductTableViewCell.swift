//
//  ProductTableViewCell.swift
//  NapoleonTestTask
//
//  Created by Артем Жорницкий on 26/03/2019.
//  Copyright © 2019 Артем Жорницкий. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    let newPriceColor = #colorLiteral(red: 1, green: 0.4937272626, blue: 0.5617902092, alpha: 1)
    
    @IBOutlet weak var ProductNameLabel: UILabel!
    
    @IBOutlet weak var productImage: UIImageView! {
        didSet {
        
            productImage.layer.masksToBounds = false
            productImage.layer.cornerRadius = 5
            productImage.clipsToBounds = true
            //productImage.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var bucketImage: UIImageView!
    
    @IBOutlet weak var oldPrice: UILabel! {
        didSet {
            oldPrice.textColor = UIColor.lightGray
        }
    }
    
    @IBOutlet weak var newPriceLabel: UILabel! {
        didSet {
            newPriceLabel.textColor = newPriceColor
        }
    }
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.layer.cornerRadius = priceLabel.frame.size.height / 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet {
            descriptionLabel.textColor = UIColor.lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(with label: String){
        let attributedString = NSMutableAttributedString(string: (label + "₽"))
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        oldPrice.attributedText = attributedString
    }
}
