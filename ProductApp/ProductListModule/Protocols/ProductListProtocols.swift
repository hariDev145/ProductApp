//
//  ProductListProtocols.swift
//  ProductApp
//
//  Created by 2714476 on 13/04/24.
//

import UIKit

protocol ViewToPresenterProductListProtocol{
    var view: PresenterToViewProductListProtocol? {get set}
    var interactor: PresenterToInteractorProductListProtocol? {get set}
    var router: PresenterToRouterProductListProtocol? {get set}
    
    func viewDidLoad()
    func setUpFooterView(tableview:UITableView)
    func loadMoreItemsAction()
    func numberOfRowsInSection() -> Int
    func setCell(tableview: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell
    func didSelectRowAt(index: Int)
    func tableViewCellHeight() -> CGFloat
    func navigateToCartModule()
}


protocol PresenterToViewProductListProtocol: AnyObject {
    func didFetchProductListSuccess(loadMore:Bool)
    func didFetchProductListFailure(error: String)
    func showActivity()
    func hideActivity()
    func networkError()
}

protocol PresenterToInteractorProductListProtocol {
    var presenter: InteractorToPresenterProductListProtocol? {get set}
    func fetchProductList(limit:Int, skip:Int)
}

protocol InteractorToPresenterProductListProtocol: AnyObject {
    func fetchProductListSuccess(productsList: ProductsList)
    func fetchProductListFailure(error: Error)
}


protocol PresenterToRouterProductListProtocol {
    static func createProductListModule() -> UINavigationController?
    func pushToProductDetail(on view: PresenterToViewProductListProtocol?, with product: Product)
    func pushToCartViewModule(on view: PresenterToViewProductListProtocol?)
}
