//
//  CoreDataTests.swift
//  ProductAppTests
//
//  Created by 2714476 on 20/04/24.
//

import XCTest
import CoreData
@testable import ProductApp

final class CoreDataTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    var products = [Product]()
    
    override func setUpWithError() throws {
        coreDataManager = CoreDataManager.shared
        productArray()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    //Testing proper initialization of CoreDataManager class
    func test1_Init_CoreDataManager(){
        let instance = CoreDataManager.shared
        XCTAssertNotNil( instance )
    }
    
    
    //Testing NSPersistentContainer initializes successfully
    func test2_CoreDataStackInitialization() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.persistentContainer.viewContext
        XCTAssertNotNil(coreDataStack)
    }
    
    
    //Testing to insert records in Product
    func test3_InsertProducts() async throws{
        let result = await coreDataManager.asyncCoreDataProductsInsert(context: coreDataManager.mainManagedObjectContext, products: products)
        XCTAssertTrue(result)
    }
    
    
    //Testing to fetch all products
    func test4_RetrieveAllProducts() {
        let products = coreDataManager.retrieveAllProducts()
        XCTAssertEqual(products?.count, 3)
    }
    
    
    //Testing to avoid adding duplication of products
    func test5_AvoidAddingDuplicationProducts(){
        let product_1 = coreDataManager.insertObject(product: products[0])
        XCTAssertFalse(product_1.objectSaved)
    }
    
    
    //Testing to delete a product
    func test6_DeleteProduct() {
        let products = coreDataManager.fetchAllObjects()
        var productsTemp = [Products]()
        productsTemp.append(products[0])
        
        coreDataManager.deleteObject(object: products[0])
        XCTAssertFalse(coreDataManager.checkProduct(byId: Int(productsTemp[0].id)))
    }
    
    
    //Testing to delete all products
    func test7_DeleteAllProducts(){
        coreDataManager.deleteAllObjects()
        let products = coreDataManager.fetchAllObjects()
        XCTAssertTrue(products.count == 0)
    }
    
    
    //Test Array
    func productArray(){
        products = [
            Product(id: 1, title: "iPhone 9", description: "An apple mobile which is nothing like apple", price: 549, discountPercentage: 12.96, rating: 4.69, stock: 94, brand: "Apple", category: "smartphones", thumbnail: "https://cdn.dummyjson.com/product-images/1/thumbnail.jpg", images: []),
            
            Product(id: 2, title: "iPhone X", description: "SIM-Free, Model A19211 6.5-inch Super Retina HD display with OLED technology A12 Bionic chip with ...", price: 899, discountPercentage: 17.94, rating: 4.44, stock: 34, brand: "Apple", category: "smartphones", thumbnail: "https://cdn.dummyjson.com/product-images/2/thumbnail.jpg", images: []),
            
            Product(id: 3, title: "Samsung Universe 9", description: "Samsung's new variant which goes beyond Galaxy to the Universe", price: 1249, discountPercentage: 15.46, rating: 4.09, stock: 36, brand: "Samsung", category: "smartphones", thumbnail: "https://cdn.dummyjson.com/product-images/3/thumbnail.jpg", images: [])
        ]
    }
    
    /* func testExample() throws {
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


