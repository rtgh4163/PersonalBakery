
import SwiftUI

struct WarehouseScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddItem = false
    let dataViewModel: DataViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(dataViewModel.warehouseItems, id: \.objectID) { item in
                            WarehouseItemView(item: item, dataViewModel: dataViewModel)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddItem = true
                    }) {
                        Image(.plusImag)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 40, height: 40)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Warehouse")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddWarehouseItemScreen { name, quantity in
                    dataViewModel.addWarehouseItem(name: name, quantity: Int32(quantity))
                }
            }
            .onAppear {
                dataViewModel.loadData()
            }
        }
    }
}

struct WarehouseItemView: View {
    let item: WarehouseItem
    let dataViewModel: DataViewModel
    @State private var showingEditSheet = false
    @State private var editedQuantity = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name ?? "Unknown")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            }
            
            Spacer()
            
            Text("\(item.quantity)")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold, design: .rounded))

        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(colors: [
                        Color(red: 79, green: 70, blue: 93),
                        Color(red: 69, green: 54, blue: 73)
                    ], startPoint: .top, endPoint: .bottom)
                )
        )
        .sheet(isPresented: $showingEditSheet) {
            EditQuantitySheet(itemName: item.name ?? "Unknown", quantity: $editedQuantity) {
                if let newQuantity = Int32(editedQuantity) {
                    dataViewModel.updateWarehouseItemQuantity(item, newQuantity: newQuantity)
                }
            }
        }
    }
}

struct EditQuantitySheet: View {
    let itemName: String
    @Binding var quantity: String
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Edit Quantity")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Item: \(itemName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Quantity", text: $quantity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                
                Button("Save") {
                    onSave()
                    dismiss()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color(red: 238, green: 26, blue: 160))
                .cornerRadius(8)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    WarehouseScreen(dataViewModel: DataViewModel())
} 
