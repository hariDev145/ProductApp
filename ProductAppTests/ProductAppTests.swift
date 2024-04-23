//
//  ProductAppTests.swift
//  ProductAppTests
//
//  Created by 2714476 on 13/04/24.
//

import XCTest
@testable import ProductApp

final class ProductAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // Testing ProductListViewController Interactor to Presenter flow
    func test1_InteractorToPresenter(){
        let interactor = ProductListInteractor()
        let mockPresenter = MockPresenter()
        interactor.presenter = 	mockPresenter
        
        interactor.loadJsonDataFromBundle()
        XCTAssertTrue(mockPresenter.presenterCalled)
    }
    
    
    
    // Testing ProductListViewController Presenter to View flow
    func test2_PresenterToViewUpdate(){
        let presenter = ProductListPresenter()
        let mockView = MockView()
        presenter.view = mockView
        
        var productsList: ProductsList?
        if let url = Bundle.main.url(forResource: "ProductJson", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                productsList = try decoder.decode(ProductsList.self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
        presenter.fetchProductListSuccess(productsList: productsList!)
        XCTAssertTrue(mockView.viewCalled)
    }
    
    
    
    
    // Testing ProductListViewController Entity
    func test3_ProductListEntity(){
        let product = Product(id: 1, title: "iPhone 9", description: "An apple mobile which is nothing like apple", price: 549, discountPercentage: 12.96, rating: 4.69, stock: 94, brand: "Apple", category: "smartphones", thumbnail: "https://cdn.dummyjson.com/product-images/1/thumbnail.jpg", images: [])
        
        XCTAssertEqual(product.id, 1)
        XCTAssertEqual(product.brand, "Apple")
        XCTAssertEqual(product.price, 549)
    }
    
    
    
    
    // Testing ProductListViewController Presenter to Router flow
    func test4_PresenterToRouter(){
        let router = MockRouter()
        let presenter = ProductListPresenter()
        presenter.router = router
        
        presenter.navigateToCartModule()
        
        XCTAssertTrue(ProductAppTests.MockRouter.routerCalled)
    }
    
    
    
    
    // Testing ProductListViewController View to Presenter flow
    func test5_ViewToPresenter(){
        let view = ProductListViewController()
        let presenter = MockViewToPresenter()
        view.presenter = presenter as? any InteractorToPresenterProductListProtocol & ViewToPresenterProductListProtocol
        
        let cellHgt = presenter.tableViewCellHeight()
        
        XCTAssertEqual(cellHgt, 160)
    }
    
    
    
    
    
    /*   func testExample() throws {
     // This is an example of a functional test case.
     // Use XCTAssert and related functions to verify your tests produce the correct results.
     // Any test you write for XCTest can be annotated as throws and async.
     // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
     // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
     }
     
     func testPerformanceExample() throws {
     // This is an example of a performance test case.
     self.measure {
     // Put the code you want to measure the time of here.
     }
     }*/
    
}







extension ProductAppTests {
    
    class MockPresenter: InteractorToPresenterProductListProtocol{
        var presenterCalled = false
        
        func fetchProductListSuccess(productsList:ProductsList) {
            presenterCalled = true
        }
        
        func fetchProductListFailure(error: Error) {
            presenterCalled = true
        }
    }
    
    
    class MockView: PresenterToViewProductListProtocol{
        var viewCalled = false
        
        func didFetchProductListSuccess(loadMore: Bool) {
            viewCalled = true
        }
        
        func didFetchProductListFailure(error: String) {
            viewCalled = true
        }
        
        func showActivity() {}
        func hideActivity() {}
        func networkError() {}
    }
    
    
    
    class MockRouter: PresenterToRouterProductListProtocol{
        static var routerCalled = false
        
        static func createProductListModule() -> UINavigationController? {
            routerCalled = true
            return nil
        }
        
        func pushToProductDetail(on view: (any ProductApp.PresenterToViewProductListProtocol)?, with product: ProductApp.Product) {
            ProductAppTests.MockRouter.routerCalled = true
        }
        
        func pushToCartViewModule(on view: (any ProductApp.PresenterToViewProductListProtocol)?) {
            ProductAppTests.MockRouter.routerCalled = true
        }
    }
    
    
    
    class MockViewToPresenter: ViewToPresenterProductListProtocol{
        var view: (PresenterToViewProductListProtocol)?
        var interactor: (PresenterToInteractorProductListProtocol)?
        var router: (PresenterToRouterProductListProtocol)?
        
        func viewDidLoad() {}
        func setUpFooterView(tableview: UITableView) {}
        func loadMoreItemsAction() {}
        func numberOfRowsInSection() -> Int {
            return 0}
        func setCell(tableview: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            return cell}
        func didSelectRowAt(index: Int) {}
        func navigateToCartModule() {}
        
        
        func tableViewCellHeight() -> CGFloat {
            Constants.Product.cellHeight
        }
    }
    
}






