import SwiftUI

struct SupplierRowView: View {
    let supplier: Supplier
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var showingEditSupplier = false
    @State private var showingSupplierDetails = false
    @State private var showingAddPurchase = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(supplier.name ?? "Unknown")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        
                        Spacer()
                        
                        Text(supplier.status ?? "Unknown")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(supplier.status == "Active" ? 
                                          Color(red: 52, green: 199, blue: 89) : 
                                          Color(red: 255, green: 59, blue: 48))
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        if let phone = supplier.phoneNumber, !phone.isEmpty {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.caption)
                                Text(phone)
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                            }
                        }
                        
                        if let email = supplier.email, !email.isEmpty {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.caption)
                                Text(email)
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                            }
                        }
                        
                        if let address = supplier.address, !address.isEmpty {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.caption)
                                Text(address)
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                            }
                        }
                    }
                    
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= (supplier.rating) ? "star.fill" : "star")
                                .foregroundColor(star <= (supplier.rating) ? Color(red: 255, green: 193, blue: 7) : .white.opacity(0.3))
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Text("\(supplier.rating)/5")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                    }
                }
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("\(dataViewModel.getSupplierPurchaseCount(supplier))")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text("Orders")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                
                VStack(spacing: 4) {
                    Text(dataViewModel.formatPrice(dataViewModel.getSupplierTotalSpent(supplier)))
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text("Spent")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                
                Spacer()
            }
            .padding(.top, 12)
            
            HStack(spacing: 12) {
                Button {
                    showingSupplierDetails = true
                } label: {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Details")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 88, green: 86, blue: 214))
                    )
                }
                
                Button {
                    showingAddPurchase = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Purchase")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 255, green: 65, blue: 103))
                    )
                }
                
                Spacer()
                
                Button {
                    showingEditSupplier = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundColor(Color(red: 255, green: 193, blue: 7))
                        .font(.title2)
                }
            }
            .padding(.top, 16)
        }
        .padding(16)
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
        .sheet(isPresented: $showingEditSupplier) {
            EditSupplierScreen(supplier: supplier)
                .environmentObject(dataViewModel)
        }
        .sheet(isPresented: $showingSupplierDetails) {
            SupplierDetailsScreen(supplier: supplier)
                .environmentObject(dataViewModel)
        }
        .sheet(isPresented: $showingAddPurchase) {
            AddPurchaseScreen(supplier: supplier)
                .environmentObject(dataViewModel)
        }
    }
}

#Preview {
    SupplierRowView(supplier: Supplier())
        .environmentObject(DataViewModel())
        .preferredColorScheme(.dark)
}

