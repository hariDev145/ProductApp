//
//  ViewController.swift
//  ProductApp
//
//  Created by 2714476 on 13/04/24.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productList_TblView: UITableView!
    @IBOutlet weak var cartBtn: UIButton!
    
    var presenter: (ViewToPresenterProductListProtocol & InteractorToPresenterProductListProtocol)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUpView()
        presenter?.setUpFooterView(tableview: productList_TblView)
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cartCount = UserDefaults.standard.integer(forKey: Constants.cartCountKey)
        showBadge(count: cartCount)
    }
    
    func setupUpView() {
        self.title = Constants.productListTitle
        productList_TblView.backgroundColor = .clear
        productList_TblView.separatorColor = UIColor.white
    }
    
    lazy var badgeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = .white
        label.font = label.font.withSize(10)
        label.backgroundColor = .systemRed
        return label
    }()
    
    func showBadge(count: Int) {
        badgeLabel.text = "\(count)"
        cartBtn.addSubview(badgeLabel)
        
        if count != 0 {
            badgeLabel.isHidden = false }else{
                badgeLabel.isHidden = true}
        let constraints = [
            badgeLabel.leftAnchor.constraint(equalTo: cartBtn.centerXAnchor, constant: 2),
            badgeLabel.topAnchor.constraint(equalTo: cartBtn.topAnchor, constant: 0),
            badgeLabel.widthAnchor.constraint(equalToConstant: 16),
            badgeLabel.heightAnchor.constraint(equalToConstant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @IBAction func cartBtnAction(_ sender: Any) {
        presenter?.navigateToCartModule()
    }
    
}




extension ProductListViewController: PresenterToViewProductListProtocol {
    
    func didFetchProductListSuccess(loadMore:Bool) {
        productList_TblView?.reloadData()
        if !loadMore{
            productList_TblView.tableFooterView = nil}
    }
    
    func didFetchProductListFailure(error: String) {
        print("Error description:: \(error)")
    }
    
    func showActivity() {
        Utility.showActivityIndicator(view: view, targetVC: self)
    }
    
    func hideActivity() {
        Utility.hideActivityIndicator(view: view)
    }
    
    func networkError() {
        self.showAlertView()
    }
}

