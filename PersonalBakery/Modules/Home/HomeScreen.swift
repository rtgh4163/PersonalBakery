
import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var showingAddOrder = false
    @State private var showingWarehouse = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("HOME")
                    .foregroundStyle(
                        LinearGradient(colors: [
                            .white,
                            Color.init(red: 255, green: 218, blue: 236)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .font(.system(size: 36, weight: .bold, design: .default))
                
                Spacer()
                
                Button {
                    showingWarehouse = true
                } label: {
                    Image(.boxImag)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 40, height: 40)
            }
            
            HStack(spacing: 12) {
                VStack(spacing: 4) {
                    Text("Active orders")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                    Text("\(dataViewModel.activeOrdersCount)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                        .font(.system(size: 36, weight: .bold, design: .default))
                    Text("current")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.system(size: 20, weight: .medium, design: .default))
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    RadialGradient(colors: [
                        Color.init(red: 106, green: 36, blue: 82),
                        Color.init(red: 64, green: 26, blue: 51)
                    ], center: .bottom, startRadius: 10, endRadius: 200)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(colors: [
                            Color.init(red: 106, green: 36, blue: 82),
                            Color.init(red: 64, green: 26, blue: 51)
                        ], startPoint: .bottom, endPoint: .top), lineWidth: 6)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(spacing: 4) {
                    Text("Total clients")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                    Text("\(dataViewModel.clients.count)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                        .font(.system(size: 36, weight: .bold, design: .default))
                    Text("registered")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.system(size: 20, weight: .medium, design: .default))
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    RadialGradient(colors: [
                        Color.init(red: 106, green: 36, blue: 82),
                        Color.init(red: 64, green: 26, blue: 51)
                    ], center: .bottom, startRadius: 10, endRadius: 200)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(colors: [
                            Color.init(red: 106, green: 36, blue: 82),
                            Color.init(red: 64, green: 26, blue: 51)
                        ], startPoint: .bottom, endPoint: .top), lineWidth: 6)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.top, 24)
            
            VStack(spacing: 4) {
                Text("Total revenue")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white.opacity(0.7))
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                Text(dataViewModel.formatPrice(dataViewModel.totalRevenue))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white)
                    .font(.system(size: 36, weight: .bold, design: .default))
                Text("completed")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white.opacity(0.7))
                    .font(.system(size: 20, weight: .medium, design: .default))
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RadialGradient(colors: [
                    Color.init(red: 106, green: 36, blue: 82),
                    Color.init(red: 64, green: 26, blue: 51)
                ], center: .bottom, startRadius: 10, endRadius: 200)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(LinearGradient(colors: [
                        Color.init(red: 106, green: 36, blue: 82),
                        Color.init(red: 64, green: 26, blue: 51)
                    ], startPoint: .bottom, endPoint: .top), lineWidth: 6)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.top, 14)
            
            Text("Recent orders")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(
                    LinearGradient(colors: [
                        .white,
                        Color.init(red: 255, green: 218, blue: 236)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 32)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(Array(dataViewModel.orders.prefix(5)), id: \.objectID) { order in
                        MainItemView(viewModel: MainItemViewModel(
                            id: order.id?.uuidString ?? "",
                            name: order.clientName ?? "Unknown",
                            product: order.productName ?? "Unknown",
                            status: .none,
                            price: dataViewModel.formatPrice(order.price),
                            date: dataViewModel.formatDate(order.orderDate)
                        ))
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
        .sheet(isPresented: $showingWarehouse) {
            WarehouseScreen(dataViewModel: dataViewModel)
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
    HomeScreen()
        .environmentObject(DataViewModel())
}
