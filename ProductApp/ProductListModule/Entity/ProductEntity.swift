//
//  ProductEntity.swift
//  ProductApp
//
//  Created by 2714476 on 13/04/24.
//

import Foundation

// MARK: - ProductsList
struct ProductsList: Decodable {
    let products: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Decodable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
}
