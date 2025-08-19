
import SwiftUI

struct AddWarehouseItemScreen: View {
    @State private var itemName = ""
    @State private var quantity = 1
    @Environment(\.dismiss) private var dismiss
    var onAddItem: ((String, Int) -> Void)?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("Item name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                HStack {
                    TextField("", text: $itemName, prompt:
                                Text("Cream")
                                    .foregroundColor(Color.init(red: 175, green: 175, blue: 175))
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    )
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                hideKeyboard()
                            }
                        }
                    }
                    
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
                .padding(.top, 8)
                
                            HStack {
                Text("Amount:")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                
                Spacer()
                
                HStack(spacing: 6) {
                    Button(action: {
                        if quantity > 1 {
                            quantity -= 1
                        }
                    }) {
                        Image(.minus)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 50, height: 50)
                    
                    Text("\(quantity)")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .frame(width: 80, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 43, green: 36, blue: 48))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 91, green: 78, blue: 100), lineWidth: 1)
                                )
                        )
                    
                    Button(action: {
                        quantity += 1
                    }) {
                        Image(.plus)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: 50, height: 50)
                }
            }
            .padding(.top, 24)
                
                Button {
                    if !itemName.isEmpty {
                        onAddItem?(itemName, quantity)
                        dismiss()
                    }
                } label: {
                    Text("Add item")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    LinearGradient(colors: [
                        Color(red: 238, green: 26, blue: 160),
                        Color(red: 206, green: 0, blue: 79)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(16)
                .padding(.top, 40)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [
                    Color(red: 20, green: 9, blue: 27),
                    Color(red: 63, green: 22, blue: 42)
                ], startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add item")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }
        }
    }
}

#Preview {
    AddWarehouseItemScreen()
} 
