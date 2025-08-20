import SwiftUI

struct AddPurchaseScreen: View {
    let supplier: Supplier
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var itemName = ""
    @State private var quantity: String = ""
    @State private var unit = ""
    @State private var amount: String = ""
    @State private var orderDate = Date()
    @State private var deliveryDate = Date()
    @State private var notes = ""
    @State private var status = "Pending"
    
    let statusOptions = ["Pending", "Ordered", "Delivered", "Cancelled"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("ADD PURCHASE")
                        .foregroundStyle(
                            LinearGradient(colors: [
                                .white,
                                Color.init(red: 255, green: 218, blue: 236)
                            ], startPoint: .top, endPoint: .bottom)
                        )
                        .font(.system(size: 28, weight: .bold, design: .default))
                    
                    Spacer()
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 255, green: 65, blue: 103))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                VStack(spacing: 12) {
                    Text("Supplier: \(supplier.name ?? "Unknown")")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    if let phone = supplier.phoneNumber, !phone.isEmpty {
                        Text("Phone: \(phone)")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 106, green: 36, blue: 82).opacity(0.3))
                )
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Item Information")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            
                            VStack(spacing: 12) {
                                CustomTextField(
                                    title: "Item Name *",
                                    text: $itemName,
                                    placeholder: "Enter item name"
                                )
                                
                                HStack(spacing: 12) {
                                    CustomTextField(
                                        title: "Quantity *",
                                        text: $quantity,
                                        placeholder: "Enter quantity"
                                    )
                                    
                                    CustomTextField(
                                        title: "Unit",
                                        text: $unit,
                                        placeholder: "e.g., kg, pcs"
                                    )
                                }
                                
                                CustomTextField(
                                    title: "Amount *",
                                    text: $amount,
                                    placeholder: "Enter amount"
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Order Details")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            
                            VStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Order Date")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                    
                                    DatePicker("", selection: $orderDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                        .colorScheme(.dark)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Expected Delivery Date")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                    
                                    DatePicker("", selection: $deliveryDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                        .labelsHidden()
                                        .colorScheme(.dark)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Status")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                    
                                    Picker("Status", selection: $status) {
                                        ForEach(statusOptions, id: \.self) { option in
                                            Text(option).tag(option)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                                
                                CustomTextField(
                                    title: "Notes",
                                    text: $notes,
                                    placeholder: "Enter additional notes"
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        Button {
                            addPurchase()
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Purchase")
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 255, green: 65, blue: 103))
                            )
                        }
                        .disabled(itemName.isEmpty || quantity.isEmpty || amount.isEmpty)
                        .opacity(itemName.isEmpty || quantity.isEmpty || amount.isEmpty ? 0.6 : 1.0)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
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
    
    private func addPurchase() {
        guard let quantityInt = Int32(quantity),
              let amountDouble = Double(amount) else { return }
        
        dataViewModel.addPurchase(
            supplier: supplier,
            itemName: itemName,
            quantity: quantityInt,
            amount: amountDouble,
            unit: unit.isEmpty ? nil : unit,
            orderDate: orderDate,
            deliveryDate: deliveryDate,
            notes: notes.isEmpty ? nil : notes,
            status: status
        )
        dismiss()
    }
}

#Preview {
    AddPurchaseScreen(supplier: Supplier())
        .environmentObject(DataViewModel())
}
