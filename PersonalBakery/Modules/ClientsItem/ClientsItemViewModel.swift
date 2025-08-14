
import Foundation

final class ClientsItemViewModel: ObservableObject {
    @Published var id: String
    @Published var name: String
    @Published var number: String
    @Published var countOrders: String
    @Published var recentOrders: [String] = []
    
    init(id: String, name: String, number: String, countOrders: String, recentOrders: [String] = []) {
        self.id = id
        self.name = name
        self.number = number
        self.countOrders = countOrders
        self.recentOrders = recentOrders
    }
}
