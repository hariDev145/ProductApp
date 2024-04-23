//
//  ProductListPresenter.swift
//  ProductApp
//
//  Created by 2714476 on 13/04/24.
//

import UIKit
import Alamofire

class ProductListPresenter: ViewToPresenterProductListProtocol {
    
    var products = [Product]()
    var limit = 10
    var skip = 0
    var totalItems = 0
    var footerView = UIView()
    var loadMoreBtn = UIButton()
    var activityIndicator = UIActivityIndicatorView()
    var localJsonLoadLimit = 0
    var tableViewRef = UITableView()
    var productDetail:Product?
    
    weak var view: PresenterToViewProductListProtocol?
    var interactor: PresenterToInteractorProductListProtocol?
    var router: PresenterToRouterProductListProtocol?

    
    func viewDidLoad() {
        fetchProducts()
    }
    
    func fetchProducts(){
        if (NetworkReachabilityManager()?.isReachable == true){
            tableViewRef.isHidden = true
            view?.showActivity()
            interactor?.fetchProductList(limit: limit, skip: skip)
            skip = 10
        }else{
            loadMoreBtn.isHidden = true
            view?.networkError()
        }
    }
    
    func loadMoreItemsAction(){
        skip += 10
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.interactor?.fetchProductList(limit: self.limit, skip: self.skip)
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return products.count
        //return 10
    }
    
    func tableViewCellHeight() -> CGFloat {
        return Constants.Product.cellHeight
    }
    
    func setCell(tableview: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: Constants.Product.productCellIdentifier, for: indexPath) as? ProductListTableViewCell {
            cell.selectionStyle = .none
            cell.setData(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func didSelectRowAt(index: Int) {
        productDetail = self.products[index]
        if let productDetail = productDetail {
            router?.pushToProductDetail(on: view, with: productDetail)
        }
    }
    
    func navigateToCartModule(){
        router?.pushToCartViewModule(on: view)
    }
    
    
    func setUpFooterView(tableview:UITableView){
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 50))
        activityIndicator.backgroundColor = .clear
        activityIndicator.center = footerView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        footerView.addSubview(activityIndicator)
        loadMoreBtn = UIButton(frame: CGRect(x:0 , y: 0, width:UIScreen.main.bounds.width, height: footerView.frame.size.height))
        loadMoreBtn.setTitle("Load More", for: .normal)
        loadMoreBtn.titleLabel?.font = UIFont(name: "Futura", size: 17.0)
        loadMoreBtn.setTitleColor(.orange, for: .normal)
        loadMoreBtn.addTarget(self, action: #selector(self.loadMoreBtnAction(sender:)), for: .touchUpInside)
        footerView.addSubview(loadMoreBtn)
        tableview.tableFooterView = footerView
        tableViewRef = tableview
    }
    
    @objc func loadMoreBtnAction(sender:UIButton){
        activityIndicator.startAnimating()
        loadMoreBtn.isHidden = true
        tableViewRef.isUserInteractionEnabled = false
        loadMoreItemsAction()
        
    }
    
}






extension ProductListPresenter: InteractorToPresenterProductListProtocol {
    
    func fetchProductListSuccess(productsList: ProductsList){
        activityIndicator.stopAnimating()
        tableViewRef.isHidden = false
        tableViewRef.isUserInteractionEnabled = true
        totalItems = productsList.total
        let products:[Product] = productsList.products
        //if let products = products {
        if products.count != 0 {
            
            //Condition for parsing Bundle JSON file response
            for i in localJsonLoadLimit...localJsonLoadLimit+9 {
                self.products.append(products[i])
            }
            localJsonLoadLimit += 10
            /////////////////////////////////////////////////////
            
            //Condition for parsing Api JSON response
//              for i in 0..<products.count-1{
//             self.products.append(products[i])
//             }
            //////////////////////////////////////////////
            
            var loadMoreEnable = Bool()
            if skip == totalItems{
                loadMoreEnable = false}
            else{
                loadMoreBtn.isHidden = false
                loadMoreEnable = true}
            view?.hideActivity()
            view?.didFetchProductListSuccess(loadMore: loadMoreEnable)
        }
        
    }
    
    
    func fetchProductListFailure(error: Error) {
        view?.hideActivity()
        view?.didFetchProductListFailure(error: "Product List fetch error \(error)")
    }
    
}

