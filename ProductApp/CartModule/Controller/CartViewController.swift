//
//  CartViewController.swift
//  ProductApp
//
//  Created by 2714476 on 18/04/24.
//

import UIKit

class CartViewController: UIViewController {
    
    var presenter: (ViewToPresenterCartViewProtocol & InteractorToPresenterCartViewProtocol)?
    
    @IBOutlet weak var cart_TblView: UITableView!
    @IBOutlet weak var noProductsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.title = Constants.cartTitle
        cart_TblView.backgroundColor = .clear
        cart_TblView.separatorColor = UIColor.white
    }
}




extension CartViewController: PresenterToViewCartViewProtocol {
    
    func retrieveCartViewProductsSuccess(productsList: [Product]?) {
        if productsList?.count == 0{
            cart_TblView.isHidden = true
            noProductsLbl.isHidden = false
        }else{
            cart_TblView.isHidden = false
            noProductsLbl.isHidden = true
            presenter?.showDataInTableView(tableView: cart_TblView)
        }
        self.hideActivity()
    }
    
    func retrieveCartViewProductsFailure(isLoaded:Bool){
        self.hideActivity()
        if isLoaded == false{
            self.showToast(message: "Error in fetching data", font: .systemFont(ofSize: 12.0))
        }
    }
    
    func showActivity() {
        Utility.showActivityIndicator(view: view, targetVC: self)
    }
    
    func hideActivity() {
        Utility.hideActivityIndicator(view: view)
    }
    
}
