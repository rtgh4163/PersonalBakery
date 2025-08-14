
import Foundation

enum Status {
    case none
    case ready
    case current
    case unfinished
}

final class MainItemViewModel: ObservableObject {
    @Published var id: String
    @Published var name: String
    @Published var product: String
    @Published var status: Status
    @Published var price: String
    @Published var date: String
    
    init(id: String, name: String, product: String, status: Status, price: String, date: String) {
        self.id = id
        self.name = name
        self.product = product
        self.status = status
        self.price = price
        self.date = date
    }
}
