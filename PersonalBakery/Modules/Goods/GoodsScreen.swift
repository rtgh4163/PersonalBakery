
import SwiftUI

struct GoodsScreen: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var searchText = ""
    @State private var showingAddProduct = false
    
    var filteredProducts: [Product] {
        dataViewModel.searchProducts(query: searchText)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("GOODS")
                    .foregroundStyle(
                        LinearGradient(colors: [
                            .white,
                            Color.init(red: 255, green: 218, blue: 236)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .font(.system(size: 36, weight: .bold, design: .default))
                
                Spacer()
                
                Button {
                    showingAddProduct = true
                } label: {
                    Image(.plusImag)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 40, height: 40)
            }
            
            HStack {
                TextField("", text: $searchText, prompt:
                            Text("Search products")
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
            .padding(.top, 24)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(filteredProducts, id: \.objectID) { product in
                        GoodsItemView(viewModel: GoodsItemViewModel(
                            id: product.id?.uuidString ?? "",
                            name: product.name ?? "Unknown",
                            price: dataViewModel.formatPrice(product.cost),
                            isInStock: product.isInStock,
                            imageData: product.imageData
                        ))
                        .frame(height: 280)
                        .contextMenu {
                            Button(role: .destructive) {
                                dataViewModel.deleteProduct(product)
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(Color.red)
                            }
                        }
                    }
                }
                .padding(.vertical, 12)
            }
        }
        .padding(.horizontal ,16)
        .padding(.top ,16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(colors: [
                Color.init(red: 63, green: 22, blue: 42),
                Color.init(red: 20, green: 9, blue: 27)
            ], center: .bottom, startRadius: 100, endRadius: 400)
        )
        .sheet(isPresented: $showingAddProduct) {
            AddProductScreen(dataViewModel: dataViewModel)
        }

        .onAppear {
            dataViewModel.loadData()
        }
    }
}



#Preview {
    GoodsScreen()
        .environmentObject(DataViewModel())
}
