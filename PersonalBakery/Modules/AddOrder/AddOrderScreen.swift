
import SwiftUI

struct AddOrderScreen: View {
    @State private var selectedClient = ""
    @State private var selectedProduct = ""
    @State private var selectedStatus = "Current"
    @State private var deliveryDate = Date()
    @State private var showingDeliveryDatePicker = false
    @Environment(\.dismiss) private var dismiss
    let dataViewModel: DataViewModel
    
    let statusOptions = ["Current", "Ready", "Unfinished"]
    
    var availableClients: [String] {
        dataViewModel.clients.map { $0.name ?? "" }.filter { !$0.isEmpty }
    }
    
    var availableProducts: [String] {
        dataViewModel.products.map { $0.name ?? "" }.filter { !$0.isEmpty }
    }
    
    var selectedProductPrice: Double {
        if let product = dataViewModel.products.first(where: { $0.name == selectedProduct }) {
            return product.cost
        }
        return 0.0
    }
    

    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Client")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                            Menu {
                                ForEach(availableClients, id: \.self) { client in
                                    Button(action: {
                                        selectedClient = client
                                    }) {
                                        HStack {
                                            Text(client)
                                                .foregroundColor(.white)
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                            Spacer()
                                            if selectedClient == client {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedClient.isEmpty ? "Select client" : selectedClient)
                                        .foregroundColor(selectedClient.isEmpty ? Color(red: 175, green: 175, blue: 175) : .white)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 99)
                                        .fill(Color(red: 43, green: 36, blue: 48))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 99)
                                                .stroke(Color(red: 91, green: 78, blue: 100), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Product")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                            Menu {
                                ForEach(availableProducts, id: \.self) { product in
                                    Button(action: {
                                        selectedProduct = product
                                    }) {
                                        HStack {
                                            Text(product)
                                                .foregroundColor(.white)
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                            Spacer()
                                            if selectedProduct == product {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedProduct.isEmpty ? "Select product" : selectedProduct)
                                        .foregroundColor(selectedProduct.isEmpty ? Color(red: 175, green: 175, blue: 175) : .white)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .medium))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 99)
                                        .fill(Color(red: 43, green: 36, blue: 48))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 99)
                                                .stroke(Color(red: 91, green: 78, blue: 100), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        if !selectedProduct.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Price")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                
                                HStack {
                                    Text(dataViewModel.formatPrice(selectedProductPrice))
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                    Spacer()
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 99)
                                        .fill(Color(red: 43, green: 36, blue: 48))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 99)
                                                .stroke(Color(red: 91, green: 78, blue: 100), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Status")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                            HStack(spacing: 12) {
                                ForEach(statusOptions, id: \.self) { status in
                                    Button(action: {
                                        selectedStatus = status
                                    }) {
                                        Text(status)
                                            .foregroundColor(.white)
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(selectedStatus == status
                                                          ? Color(red: 255, green: 65, blue: 103)
                                                          : Color(red: 80, green: 65, blue: 90))
                                            )
                                    }
                                }
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Delivery Date")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            
                            Button(action: {
                                showingDeliveryDatePicker = true
                            }) {
                                HStack {
                                    Text(dataViewModel.formatDate(deliveryDate))
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 99)
                                        .fill(Color(red: 43, green: 36, blue: 48))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 99)
                                                .stroke(Color(red: 91, green: 78, blue: 100), lineWidth: 1)
                                        )
                                )
                            }
                            .sheet(isPresented: $showingDeliveryDatePicker) {
                                CustomDatePickerView(
                                    selectedDate: $deliveryDate,
                                    isPresented: $showingDeliveryDatePicker
                                )
                            }
                        }
                        
                        Button {
                            addOrder()
                        } label: {
                            Text("Add Order")
                                .foregroundColor(.white)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(
                            LinearGradient(colors: [
                                Color.init(red: 238, green: 26, blue: 160),
                                Color.init(red: 206, green: 0, blue: 79)
                            ], startPoint: .top, endPoint: .bottom)
                        )
                        .cornerRadius(99)
                        .disabled(selectedClient.isEmpty || selectedProduct.isEmpty)
                        .opacity(selectedClient.isEmpty || selectedProduct.isEmpty ? 0.6 : 1.0)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RadialGradient(colors: [
                    Color.init(red: 63, green: 22, blue: 42),
                    Color.init(red: 20, green: 9, blue: 27)
                ], center: .bottom, startRadius: 100, endRadius: 400)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add order")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }
        }
    }
    
    private func addOrder() {
        guard !selectedClient.isEmpty && !selectedProduct.isEmpty else { return }
        
        dataViewModel.addOrder(
            clientName: selectedClient,
            productName: selectedProduct,
            status: selectedStatus,
            price: selectedProductPrice,
            orderDate: Date(),
            deliveryDate: deliveryDate,
            notes: nil
        )
        dismiss()
    }
}

#Preview {
    AddOrderScreen(dataViewModel: DataViewModel())
}

struct CustomDatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .colorScheme(.dark)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RadialGradient(colors: [
                    Color.init(red: 63, green: 22, blue: 42),
                    Color.init(red: 20, green: 9, blue: 27)
                ], center: .bottom, startRadius: 100, endRadius: 400)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select Delivery Date")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(Color(red: 255, green: 65, blue: 103))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
