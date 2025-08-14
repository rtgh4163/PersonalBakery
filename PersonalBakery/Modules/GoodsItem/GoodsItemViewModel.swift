
import Foundation
import UIKit

final class GoodsItemViewModel: ObservableObject {
    @Published var id: String
    @Published var name: String
    @Published var price: String
    @Published var isInStock: Bool
    @Published var imageData: Data?
    
    init(id: String, name: String, price: String, isInStock: Bool, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.isInStock = isInStock
        self.imageData = imageData
    }
}
