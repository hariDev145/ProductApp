//
//  ProductListTableViewCell.swift
//  ProductApp
//
//  Created by 2714476 on 14/04/24.
//

import UIKit
import AlamofireImage

class ProductListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var product_ThumbNailImg: UIImageView!
    @IBOutlet weak var product_BrandLbl: UILabel!
    @IBOutlet weak var product_TitleLbl: UILabel!
    @IBOutlet weak var product_PriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setData(product:Product){
        self.product_BrandLbl.text = product.brand
        self.product_TitleLbl.text = product.title
        self.product_PriceLbl.text = "$\(String(product.price))"
        product_ThumbNailImg.layer.cornerRadius = 6.0
        product_ThumbNailImg.clipsToBounds = true
        let url = URL(string: product.thumbnail)!
        // let placeholderImage = UIImage(named: "placeholder")!
        product_ThumbNailImg.af_setImage(withURL: url)
    }
}
