
import SwiftUI

struct OrdersScreen: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var showingAddOrder = false
    
    let filterOptions = ["All", "Current", "Ready", "Unfinished"]
    
    var filteredOrders: [Order] {
        let orders = dataViewModel.searchOrders(query: searchText)
        if selectedFilter == "All" {
            return orders
        } else {
            return orders.filter { $0.status == selectedFilter }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("ORDERS")
                    .foregroundStyle(
                        LinearGradient(colors: [
                            .white,
                            Color.init(red: 255, green: 218, blue: 236)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .font(.system(size: 36, weight: .bold, design: .default))
                
                Spacer()
                
                Button {
                    showingAddOrder = true
                } label: {
                    Image(.plusImag)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 40, height: 40)
            }
            
            HStack {
                TextField("", text: $searchText, prompt:
                            Text("Search orders")
                                .foregroundColor(Color.init(red: 175, green: 175, blue: 175))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                )
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
            .padding(.top, 24)
            
            HStack(spacing: 12) {
                ForEach(filterOptions, id: \.self) { status in
                    Button(action: {
                        selectedFilter = status
                    }) {
                        Text(status)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(selectedFilter == status
                                          ? Color(red: 255, green: 65, blue: 103)
                                          : Color(red: 80, green: 65, blue: 90))
                            )
                    }
                }
                Spacer()
            }
            .padding(.top, 16)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(filteredOrders, id: \.objectID) { order in
                        MainItemView(viewModel: MainItemViewModel(
                            id: order.id?.uuidString ?? "",
                            name: order.clientName ?? "Unknown",
                            product: order.productName ?? "Unknown",
                            status: getStatusFromString(order.status ?? "Current"),
                            price: dataViewModel.formatPrice(order.price),
                            date: dataViewModel.formatDate(order.orderDate)
                        ))
                        .contextMenu {
                            Button(role: .destructive) {
                                dataViewModel.deleteOrder(order)
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
        .sheet(isPresented: $showingAddOrder) {
            AddOrderScreen(dataViewModel: dataViewModel)
        }

        .onAppear {
            dataViewModel.loadData()
        }
    }
    
    private func getStatusFromString(_ status: String) -> Status {
        switch status.lowercased() {
        case "ready":
            return .ready
        case "current":
            return .current
        case "unfinished":
            return .unfinished
        default:
            return .none
        }
    }
}

#Preview {
    OrdersScreen()
        .environmentObject(DataViewModel())
}
