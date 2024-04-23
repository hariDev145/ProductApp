//
//  Constants.swift
//  ProductApp
//
//  Created by 2714476 on 13/04/24.
//

struct Constants {
    
    struct Product{
        static let cellHeight = 160.0
        static let footerHeight = 50.0
        static let productCellIdentifier = "ProductListTableViewCell"
        static let productApiUrl = "https://dummyjson.com/products"
    }
    
    struct CartProduct{
        static let cellHeight = 100.0
        static let cartCellIdentifier = "CartTableViewCell"
    }
    
    static let cartProductAddedMsg = "Added to cart successfully!"
    static let cartProductExistsMsg = "Product already exists in the cart!"
    static let somethingWrongMsg = "Something went wrong."
    static let cartCountKey = "cartCount"
    static let productListTitle = "ProductList"
    static let productDetailTitle = "ProductDetail"
    static let cartTitle = "Cart"
    static let productEntity = "Products"
    static let productImagesKey = "images"
    static let productListViewController = "ProductListViewController"
    static let storyboardName = "Main"
    static let productDetailViewController = "ProductDetailViewController"
    static let cartViewController = "CartViewController"
    
}



