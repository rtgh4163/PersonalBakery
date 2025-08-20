
import Foundation
import CoreData
import SwiftUI

class DataViewModel: ObservableObject {
    @Published var clients: [Client] = []
    @Published var products: [Product] = []
    @Published var orders: [Order] = []
    @Published var warehouseItems: [WarehouseItem] = []
    @Published var activeOrdersCount: Int = 0
    @Published var totalRevenue: Double = 0.0
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadData()
    }
    
    func loadData() {
        clients = coreDataManager.fetchClients()
        products = coreDataManager.fetchProducts()
        orders = coreDataManager.fetchOrders()
        warehouseItems = coreDataManager.fetchWarehouseItems()
        suppliers = coreDataManager.fetchSuppliers()
        purchases = coreDataManager.fetchPurchases()
        updateStatistics()
    }
    
    func updateStatistics() {
        activeOrdersCount = coreDataManager.getActiveOrdersCount()
        totalRevenue = coreDataManager.getTotalRevenue()
    }
    
    func addClient(name: String, phoneNumber: String) {
        let client = coreDataManager.createClient(name: name, phoneNumber: phoneNumber)
        clients.append(client)
        objectWillChange.send()
    }
    
    func deleteClient(_ client: Client) {
        coreDataManager.deleteClient(client)
        if let index = clients.firstIndex(of: client) {
            clients.remove(at: index)
        }
        objectWillChange.send()
    }
    
    func getClientOrderCount(_ client: Client) -> Int {
        return coreDataManager.getClientOrderCount(client)
    }
    
    func addProduct(name: String, cost: Double, isInStock: Bool, imageData: Data? = nil, description: String? = nil) {
        let product = coreDataManager.createProduct(name: name, cost: cost, isInStock: isInStock, imageData: imageData, description: description)
        products.append(product)
        objectWillChange.send()
    }
    
    func deleteProduct(_ product: Product) {
        coreDataManager.deleteProduct(product)
        if let index = products.firstIndex(of: product) {
            products.remove(at: index)
        }
        objectWillChange.send()
    }
    
    func updateProductStock(_ product: Product, isInStock: Bool) {
        product.isInStock = isInStock
        coreDataManager.save()
        objectWillChange.send()
    }
    
    func addOrder(clientName: String, productName: String, status: String, price: Double, orderDate: Date, deliveryDate: Date? = nil, notes: String? = nil, client: Client? = nil, product: Product? = nil) {
        let order = coreDataManager.createOrder(clientName: clientName, productName: productName, status: status, price: price, orderDate: orderDate, deliveryDate: deliveryDate, notes: notes, client: client, product: product)
        orders.append(order)
        updateStatistics()
        objectWillChange.send()
    }
    
    func deleteOrder(_ order: Order) {
        coreDataManager.deleteOrder(order)
        if let index = orders.firstIndex(of: order) {
            orders.remove(at: index)
        }
        updateStatistics()
        objectWillChange.send()
    }
    
    func updateOrderStatus(_ order: Order, newStatus: String) {
        order.status = newStatus
        coreDataManager.save()
        updateStatistics()
        objectWillChange.send()
    }
    
    func getOrders(withStatus status: String) -> [Order] {
        return coreDataManager.fetchOrders(withStatus: status)
    }
    
    func addWarehouseItem(name: String, quantity: Int32, unit: String? = nil, minQuantity: Int32 = 0) {
        let item = coreDataManager.createWarehouseItem(name: name, quantity: quantity, unit: unit, minQuantity: minQuantity)
        warehouseItems.append(item)
        objectWillChange.send()
    }
    
    func deleteWarehouseItem(_ item: WarehouseItem) {
        coreDataManager.deleteWarehouseItem(item)
        if let index = warehouseItems.firstIndex(of: item) {
            warehouseItems.remove(at: index)
        }
        objectWillChange.send()
    }
    
    func updateWarehouseItemQuantity(_ item: WarehouseItem, newQuantity: Int32) {
        coreDataManager.updateWarehouseItemQuantity(item, newQuantity: newQuantity)
        objectWillChange.send()
    }
    
    func searchClients(query: String) -> [Client] {
        if query.isEmpty {
            return clients
        }
        return clients.filter { client in
            client.name?.localizedCaseInsensitiveContains(query) == true ||
            client.phoneNumber?.localizedCaseInsensitiveContains(query) == true
        }
    }
    
    func searchProducts(query: String) -> [Product] {
        if query.isEmpty {
            return products
        }
        return products.filter { product in
            product.name?.localizedCaseInsensitiveContains(query) == true
        }
    }
    
    func searchOrders(query: String) -> [Order] {
        if query.isEmpty {
            return orders
        }
        return orders.filter { order in
            order.clientName?.localizedCaseInsensitiveContains(query) == true ||
            order.productName?.localizedCaseInsensitiveContains(query) == true
        }
    }
    
    func formatPrice(_ price: Double) -> String {
        return String(format: "%.2f", price)
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date)
    }
    
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        return phoneNumber
    }
    
    func getStatusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "ready":
            return .green
        case "current":
            return .blue
        case "unfinished":
            return .orange
        default:
            return .gray
        }
    }
    
    func getStatusText(_ status: String) -> String {
        switch status.lowercased() {
        case "ready":
            return "Ready"
        case "current":
            return "Current"
        case "unfinished":
            return "Unfinished"
        default:
            return status
        }
    }
    
    func getRevenueForTimeRange(_ timeRange: StatisticsScreen.TimeRange) -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        var startDate: Date
        
        switch timeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .quarter:
            startDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        return orders
            .filter { $0.orderDate ?? .now >= startDate && $0.status?.lowercased() == "ready" }
            .reduce(0) { $0 + $1.price }
    }
    
    func getOrdersCountForTimeRange(_ timeRange: StatisticsScreen.TimeRange) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        var startDate: Date
        
        switch timeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .quarter:
            startDate = calendar.date(byAdding: .month, value: -3, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        return orders.filter { $0.orderDate ?? .now >= startDate }.count
    }
    
    func getTopProducts(limit: Int = 5) -> [Product] {
        return Array(products.prefix(limit))
    }
    
    func getTopClients(limit: Int = 5) -> [Client] {
        return clients.sorted { getClientOrderCount($0) > getClientOrderCount($1) }
            .prefix(limit)
            .map { $0 }
    }
    
    func getRecentOrders(limit: Int = 10) -> [Order] {
        return orders.sorted { ($0.orderDate ?? Date()) > ($1.orderDate ?? Date()) }
            .prefix(limit)
            .map { $0 }
    }
    
    @Published var suppliers: [Supplier] = []
    @Published var purchases: [Purchase] = []
    
    func loadSupplierData() {
        suppliers = coreDataManager.fetchSuppliers()
        purchases = coreDataManager.fetchPurchases()
    }
    
    func addSupplier(name: String, phoneNumber: String, email: String? = nil, address: String? = nil, contactPerson: String? = nil, website: String? = nil, notes: String? = nil, rating: Int16 = 5) {
        let supplier = coreDataManager.createSupplier(name: name, phoneNumber: phoneNumber, email: email, address: address, contactPerson: contactPerson, website: website, notes: notes, rating: rating)
        suppliers.append(supplier)
        objectWillChange.send()
    }
    
    func deleteSupplier(_ supplier: Supplier) {
        coreDataManager.deleteSupplier(supplier)
        if let index = suppliers.firstIndex(of: supplier) {
            suppliers.remove(at: index)
        }
        objectWillChange.send()
    }
    
    func updateSupplierStatus(_ supplier: Supplier, newStatus: String) {
        coreDataManager.updateSupplierStatus(supplier, newStatus: newStatus)
        objectWillChange.send()
    }
    
    func updateSupplierRating(_ supplier: Supplier, newRating: Int16) {
        coreDataManager.updateSupplierRating(supplier, newRating: newRating)
        objectWillChange.send()
    }
    
    func updateSupplier(_ supplier: Supplier, name: String, phoneNumber: String, email: String?, address: String?, contactPerson: String?, website: String?, notes: String?, rating: Int16, status: String) {
        supplier.name = name
        supplier.phoneNumber = phoneNumber
        supplier.email = email
        supplier.address = address
        supplier.contactPerson = contactPerson
        supplier.website = website
        supplier.notes = notes
        supplier.rating = rating
        supplier.status = status
        
        coreDataManager.save()
        objectWillChange.send()
    }
    
    func addPurchase(supplier: Supplier, itemName: String, quantity: Int32, amount: Double, unit: String? = nil, orderDate: Date, deliveryDate: Date? = nil, notes: String? = nil, status: String = "Pending") {
        let purchase = coreDataManager.createPurchase(supplier: supplier, itemName: itemName, quantity: quantity, amount: amount, unit: unit, orderDate: orderDate, deliveryDate: deliveryDate, notes: notes, status: status)
        purchases.append(purchase)
        objectWillChange.send()
    }
    
    func deletePurchase(_ purchase: Purchase) {
        coreDataManager.deletePurchase(purchase)
        if let index = purchases.firstIndex(of: purchase) {
            purchases.remove(at: index)
        }
        objectWillChange.send()
    }
    
    func updatePurchaseStatus(_ purchase: Purchase, newStatus: String) {
        coreDataManager.updatePurchaseStatus(purchase, newStatus: newStatus)
        objectWillChange.send()
    }
    
    func getSupplierPurchaseCount(_ supplier: Supplier) -> Int {
        return coreDataManager.getSupplierPurchaseCount(supplier)
    }
    
    func getSupplierTotalSpent(_ supplier: Supplier) -> Double {
        return coreDataManager.getSupplierTotalSpent(supplier)
    }
    
    func searchSuppliers(query: String) -> [Supplier] {
        if query.isEmpty {
            return suppliers
        }
        return suppliers.filter { supplier in
            supplier.name?.localizedCaseInsensitiveContains(query) == true ||
            supplier.phoneNumber?.localizedCaseInsensitiveContains(query) == true ||
            supplier.email?.localizedCaseInsensitiveContains(query) == true
        }
    }
    
    func searchPurchases(query: String) -> [Purchase] {
        if query.isEmpty {
            return purchases
        }
        return purchases.filter { purchase in
            purchase.itemName?.localizedCaseInsensitiveContains(query) == true ||
            purchase.supplier?.name?.localizedCaseInsensitiveContains(query) == true
        }
    }
} 
