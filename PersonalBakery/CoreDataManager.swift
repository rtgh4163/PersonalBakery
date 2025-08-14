
import CoreData
import Foundation

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersonalBakery")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("\(error)")
            }
        }
    }
    
    func createClient(name: String, phoneNumber: String) -> Client {
        let client = Client(context: context)
        client.id = UUID()
        client.name = name
        client.phoneNumber = phoneNumber
        client.createdAt = Date()
        save()
        return client
    }
    
    func fetchClients() -> [Client] {
        let request: NSFetchRequest<Client> = Client.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Client.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func deleteClient(_ client: Client) {
        context.delete(client)
        save()
    }
    
    func createProduct(name: String, cost: Double, isInStock: Bool, imageData: Data? = nil, description: String? = nil) -> Product {
        let product = Product(context: context)
        product.id = UUID()
        product.name = name
        product.cost = cost
        product.isInStock = isInStock
        product.imageData = imageData
        product.productDescription = description
        product.createdAt = Date()
        save()
        return product
    }
    
    func fetchProducts() -> [Product] {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Product.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func deleteProduct(_ product: Product) {
        context.delete(product)
        save()
    }
    
    func createOrder(clientName: String, productName: String, status: String, price: Double, orderDate: Date, deliveryDate: Date? = nil, notes: String? = nil, client: Client? = nil, product: Product? = nil) -> Order {
        let order = Order(context: context)
        order.id = UUID()
        order.clientName = clientName
        order.productName = productName
        order.status = status
        order.price = price
        order.orderDate = orderDate
        order.deliveryDate = deliveryDate
        order.notes = notes
        order.client = client
        order.product = product
        order.createdAt = Date()
        
        if let client = client {
            client.addToOrders(order)
        }
        if let product = product {
            product.addToOrders(order)
        }
        
        save()
        return order
    }
    
    func fetchOrders() -> [Order] {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Order.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func fetchOrders(withStatus status: String) -> [Order] {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@", status)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Order.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func deleteOrder(_ order: Order) {
        context.delete(order)
        save()
    }
    
    func createWarehouseItem(name: String, quantity: Int32, unit: String? = nil, minQuantity: Int32 = 0) -> WarehouseItem {
        let item = WarehouseItem(context: context)
        item.id = UUID()
        item.name = name
        item.quantity = quantity
        item.unit = unit
        item.minQuantity = minQuantity
        item.createdAt = Date()
        item.updatedAt = Date()
        save()
        return item
    }
    
    func fetchWarehouseItems() -> [WarehouseItem] {
        let request: NSFetchRequest<WarehouseItem> = WarehouseItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WarehouseItem.name, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func updateWarehouseItemQuantity(_ item: WarehouseItem, newQuantity: Int32) {
        item.quantity = newQuantity
        item.updatedAt = Date()
        save()
    }
    
    func deleteWarehouseItem(_ item: WarehouseItem) {
        context.delete(item)
        save()
    }
    
    func getActiveOrdersCount() -> Int {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.predicate = NSPredicate(format: "status IN %@", ["Current", "Ready"])
        
        do {
            return try context.count(for: request)
        } catch {
            print("\(error)")
            return 0
        }
    }
    
    func getTotalRevenue() -> Double {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@", "Ready")
        
        do {
            let orders = try context.fetch(request)
            return orders.reduce(0) { $0 + $1.price }
        } catch {
            print("\(error)")
            return 0
        }
    }
    
    func getClientOrderCount(_ client: Client) -> Int {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        request.predicate = NSPredicate(format: "clientName == %@", client.name ?? "")
        
        do {
            return try context.count(for: request)
        } catch {
            print("\(error)")
            return 0
        }
    }
    

} 
