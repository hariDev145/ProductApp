//
//  CoreDataManager.swift
//  ProductApp
//
//  Created by 2714476 on 19/04/24.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
     var mainManagedObjectContext: NSManagedObjectContext = {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         return appDelegate.persistentContainer.viewContext
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainManagedObjectContext
        return privateContext
    }()
    
    func saveMainContext() {
        if mainManagedObjectContext.hasChanges {
            do {
                try mainManagedObjectContext.save()
            } catch {
                print("Error saving main managed object context: \(error)")
            }
        }
    }
    
    func savePrivateContext() {
        if privateManagedObjectContext.hasChanges {
            do {
                try privateManagedObjectContext.save()
            } catch {
                print("Error saving private managed object context: \(error)")
            }
        }
    }
    
    func saveChanges() {
        //savePrivateContext()
        mainManagedObjectContext.performAndWait {
            saveMainContext()
        }
    }
    
    /*private func mergeChangesFromPrivateContext() {
     mainManagedObjectContext.performAndWait {
     do {
     try mainManagedObjectContext.save()
     } catch {
     print("Error saving main managed object context after merging changes: \(error)")
     }
     }
     }*/
    
    func saveData<T: NSManagedObject>(objects: [T]) {
        mainManagedObjectContext.perform {
            // Insert the objects into the private context
            for object in objects {
                self.mainManagedObjectContext.insert(object)
            }
            
            // Save changes to the private context and merge to the main context
           self.saveChanges()
        }
    }
    
    func updateData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Update the objects in the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    // If the object is already in the private context, update it directly
                    object.managedObjectContext?.refresh(object, mergeChanges: true)
                } else {
                    // If the object is not in the private context, fetch and update it
                    let fetchRequest = NSFetchRequest<T>(entityName: object.entity.name!)
                    fetchRequest.predicate = NSPredicate(format: "SELF == %@", object)
                    fetchRequest.fetchLimit = 1
                    
                    if let fetchedObject = try? self.privateManagedObjectContext.fetch(fetchRequest).first {
                        
                        // fetchedObject.setValuesForKeys(object.dictionaryWithValues(forKeys: object.entity.attributesByName.keys.map{ $0.rawValue }))
                    }
                }
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
    
    func deleteData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Delete the objects from the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    self.privateManagedObjectContext.delete(object)
                } else {
                    if let objectInContext = self.privateManagedObjectContext.object(with: object.objectID) as? T {
                        self.privateManagedObjectContext.delete(objectInContext)
                    }
                }
            }
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
    
    func deleteObject<T: NSManagedObject>(object: T) {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        let objs = try! mainManagedObjectContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            if object.objectID == obj.objectID{
                mainManagedObjectContext.delete(obj)
            }
        }
        try! mainManagedObjectContext.save()
    }
    
    
    func deleteAllObjects() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        let objs = try! mainManagedObjectContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mainManagedObjectContext.delete(obj)
        }
        try! mainManagedObjectContext.save()
    }
    
    
    
    
    func checkProduct(byId id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1
        
        var product = [Products]()
        mainManagedObjectContext.performAndWait {
            do {
                product = try mainManagedObjectContext.fetch(fetchRequest)
            } catch {
                print("Error fetching specific product data: \(error)")
            }
        }
        
        if product.count == 0{
            return false
        }
        return true
    }
    
    
    func asyncCoreDataProductsInsert(context: NSManagedObjectContext, products:[Product]) async -> Bool {
        var storeProducts = [Products]()

        await context.perform {
            for prodObject in products{
                let productsExists = self.checkProduct(byId: Int(prodObject.id))
                if !productsExists{
                    let productObj = NSEntityDescription.insertNewObject(forEntityName: Constants.productEntity, into: self.mainManagedObjectContext) as! Products
                    productObj.id = Int16(prodObject.id)
                    productObj.title = prodObject.title
                    productObj.prod_description = prodObject.description
                    productObj.price = Int32(prodObject.price)
                    productObj.discountPercentage = prodObject.discountPercentage
                    productObj.rating = Float(prodObject.rating)
                    productObj.stock = Int32(prodObject.stock)
                    productObj.brand = prodObject.brand
                    productObj.category = prodObject.category
                    productObj.thumbnail = prodObject.thumbnail
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: prodObject.images, requiringSecureCoding: true)
                        productObj.setValue(data, forKey: Constants.productImagesKey)
                    }catch{
                        print(error)
                        // return (objectExists:false, objectSaved:false)
                    }
                    storeProducts.append(productObj)
                    // return (objectExists:false, objectSaved:true)
                }
                // return (objectExists:true, objectSaved:false)
            }
            for object in storeProducts {
                self.mainManagedObjectContext.insert(object)
            }
            self.saveChanges()
        }
        
        if products.count != retrieveAllProducts()?.count{
            return false
        }
        return true
    }
    
    func insertObject(product:Product) -> (objectExists:Bool, objectSaved:Bool){
        let productsExists = checkProduct(byId: product.id)
        if !productsExists{
            let productObj = NSEntityDescription.insertNewObject(forEntityName: Constants.productEntity, into: mainManagedObjectContext) as! Products
            productObj.id = Int16(product.id)
            productObj.title = product.title
            productObj.prod_description = product.description
            productObj.price = Int32(product.price)
            productObj.discountPercentage = product.discountPercentage
            productObj.rating = Float(product.rating)
            productObj.stock = Int32(product.stock)
            productObj.brand = product.brand
            productObj.category = product.category
            productObj.thumbnail = product.thumbnail
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: product.images, requiringSecureCoding: true)
                productObj.setValue(data, forKey: Constants.productImagesKey)
            }catch{
                print(error)
                return (objectExists:false, objectSaved:false)
            }
            saveData(objects: [productObj])
            return (objectExists:false, objectSaved:true)
        }
        return (objectExists:true, objectSaved:false)
    }
    
    func insertMultipleObjects(products:[Product]) {//} -> (objectExists:Bool, objectSaved:Bool){
        var storeProducts = [Products]()
        for prodObject in products{
            let productsExists = checkProduct(byId: prodObject.id)
            if !productsExists{
                let productObj = NSEntityDescription.insertNewObject(forEntityName: Constants.productEntity, into: mainManagedObjectContext) as! Products
                productObj.id = Int16(prodObject.id)
                productObj.title = prodObject.title
                productObj.prod_description = prodObject.description
                productObj.price = Int32(prodObject.price)
                productObj.discountPercentage = prodObject.discountPercentage
                productObj.rating = Float(prodObject.rating)
                productObj.stock = Int32(prodObject.stock)
                productObj.brand = prodObject.brand
                productObj.category = prodObject.category
                productObj.thumbnail = prodObject.thumbnail
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: prodObject.images, requiringSecureCoding: true)
                    productObj.setValue(data, forKey: Constants.productImagesKey)
                }catch{
                    print(error)
                    // return (objectExists:false, objectSaved:false)
                }
                storeProducts.append(productObj)
                // return (objectExists:false, objectSaved:true)
            }
            // return (objectExists:true, objectSaved:false)
        }
        saveData(objects: storeProducts)

    }
    
    
    func fetchAllObjects() -> [Products]{
        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        
        var products = [Products]()
        mainManagedObjectContext.performAndWait {
            do {
                products = try mainManagedObjectContext.fetch(fetchRequest)
            } catch {
                print("Error fetching data: \(error)")
            }
        }
        return products
    }
    
    
    func retrieveAllProducts() -> [Product]? {
        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        
        var products = [Products]()
        var productArray = [Product]()
        mainManagedObjectContext.performAndWait {
            do {
                products = try mainManagedObjectContext.fetch(fetchRequest)
                
                for prodObj in products {
                    var imageArray = [String]()
                    
                    do{
                        let data = prodObj.value(forKey: Constants.productImagesKey) as! NSData
                        let unarchievedData = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data as Data) as? [String]
                        // let unarchievedData = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
                        // let arrayObject = unarchievedData as? [String]
                        
                        if let imgArr = unarchievedData{
                            imageArray = imgArr
                        }
                    }catch{
                        print(error)
                    }
                    
                    let product = Product(id: Int(prodObj.id), title: prodObj.title ?? "", description: prodObj.prod_description ?? "", price: Int(prodObj.price), discountPercentage: prodObj.discountPercentage, rating: Double(prodObj.rating), stock: Int(prodObj.stock), brand: prodObj.brand ?? "", category: prodObj.category ?? "", thumbnail: prodObj.thumbnail ?? "", images: imageArray)
                    
                    productArray.append(product)
                }
                
            } catch {
                print("Error fetching data: \(error)")
            }
        }
        
        return productArray
    }
    
    
    
    
}
