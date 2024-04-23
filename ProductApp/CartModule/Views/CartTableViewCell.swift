//
//  CartTableViewCell.swift
//  ProductApp
//
//  Created by 2714476 on 18/04/24.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cartProduct_ThumbNailImg: UIImageView!
    @IBOutlet weak var cartProduct_BrandLbl: UILabel!
    @IBOutlet weak var cartProduct_TitleLbl: UILabel!
    @IBOutlet weak var cartProduct_PriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(product:Product){
        self.cartProduct_BrandLbl.text = product.brand
        self.cartProduct_TitleLbl.text = product.title
        self.cartProduct_PriceLbl.text = "$\(String(product.price))"
        cartProduct_ThumbNailImg.layer.cornerRadius = 6.0
        cartProduct_ThumbNailImg.clipsToBounds = true
        let url = URL(string: product.thumbnail)!
        // let placeholderImage = UIImage(named: "placeholder")!
        cartProduct_ThumbNailImg.af_setImage(withURL: url)
    }
    
}
