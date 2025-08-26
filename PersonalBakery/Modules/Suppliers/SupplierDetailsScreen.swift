import SwiftUI

struct SupplierDetailsScreen: View {
    let supplier: Supplier
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("SUPPLIER DETAILS")
                        .foregroundStyle(
                            LinearGradient(colors: [
                                .white,
                                Color.init(red: 255, green: 218, blue: 236)
                            ], startPoint: .top, endPoint: .bottom)
                        )
                        .font(.system(size: 28, weight: .bold, design: .default))
                    
                    Spacer()
                    
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 255, green: 65, blue: 103))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(supplier.name ?? "Unknown")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                    
                                    Text(supplier.status ?? "Unknown")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(supplier.status == "Active" ? 
                                                      Color(red: 52, green: 199, blue: 89) : 
                                                      Color(red: 255, green: 59, blue: 48))
                                        )
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 4) {
                                    HStack {
                                        ForEach(1...5, id: \.self) { star in
                                            Image(systemName: star <= (supplier.rating) ? "star.fill" : "star")
                                                .foregroundColor(star <= (supplier.rating) ? Color(red: 255, green: 193, blue: 7) : .white.opacity(0.3))
                                                .font(.title3)
                                        }
                                    }
                                    
                                    Text("\(supplier.rating)/5")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                }
                            }
                            
                            VStack(spacing: 12) {
                                if let phone = supplier.phoneNumber, !phone.isEmpty {
                                    DetailRow(icon: "phone.fill", title: "Phone", value: phone)
                                }
                                
                                if let email = supplier.email, !email.isEmpty {
                                    DetailRow(icon: "envelope.fill", title: "Email", value: email)
                                }
                                
                                if let address = supplier.address, !address.isEmpty {
                                    DetailRow(icon: "location.fill", title: "Address", value: address)
                                }
                                
                                if let contactPerson = supplier.contactPerson, !contactPerson.isEmpty {
                                    DetailRow(icon: "person.fill", title: "Contact Person", value: contactPerson)
                                }
                                
                                if let website = supplier.website, !website.isEmpty {
                                    DetailRow(icon: "globe", title: "Website", value: website)
                                }
                                
                                if let notes = supplier.notes, !notes.isEmpty {
                                    DetailRow(icon: "note.text", title: "Notes", value: notes)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 106, green: 36, blue: 82).opacity(0.3))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(LinearGradient(colors: [
                                    Color.init(red: 106, green: 36, blue: 82),
                                    Color.init(red: 64, green: 26, blue: 51)
                                ], startPoint: .bottom, endPoint: .top), lineWidth: 2)
                        )
                        .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            StatCard(
                                title: "Total Orders",
                                value: "\(dataViewModel.getSupplierPurchaseCount(supplier))",
                                icon: "cart.fill",
                                color: Color(red: 88, green: 86, blue: 214)
                            )
                            
                            StatCard(
                                title: "Total Spent",
                                value: dataViewModel.formatPrice(dataViewModel.getSupplierTotalSpent(supplier)),
                                icon: "dollarsign.circle.fill",
                                color: Color(red: 255, green: 65, blue: 103)
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Purchases")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .padding(.horizontal, 16)
                            
                            let supplierPurchases = dataViewModel.purchases.filter { $0.supplier == supplier }
                            if supplierPurchases.isEmpty {
                                Text("No purchases yet")
                                    .foregroundColor(.white.opacity(0.6))
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 40)
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(Array(supplierPurchases.prefix(5)), id: \.objectID) { purchase in
                                        PurchaseRow(purchase: purchase)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RadialGradient(colors: [
                    Color.init(red: 63, green: 22, blue: 42),
                    Color.init(red: 20, green: 9, blue: 27)
                ], center: .bottom, startRadius: 100, endRadius: 400)
            )
        }
        .navigationBarHidden(true)
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.7))
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                
                Text(value)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
            
            Spacer()
        }
    }
}

struct PurchaseRow: View {
    let purchase: Purchase
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(purchase.itemName ?? "Unknown")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                
                Text("Qty: \(purchase.quantity) \(purchase.unit ?? "units")")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                
                if let date = purchase.orderDate {
                    Text(dataViewModel.formatDate(date))
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(dataViewModel.formatPrice(purchase.amount))
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                Text(purchase.status ?? "Unknown")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 106, green: 36, blue: 82))
                    )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 106, green: 36, blue: 82).opacity(0.3))
        )
    }
    
    private var dataViewModel: DataViewModel {
        DataViewModel()
    }
}

#Preview {
    SupplierDetailsScreen(supplier: Supplier())
        .environmentObject(DataViewModel())
}

