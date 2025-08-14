
import SwiftUI

struct ClientsScreen: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var searchText = ""
    @State private var showingAddClient = false
    
    var filteredClients: [Client] {
        dataViewModel.searchClients(query: searchText)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("CLIENTS")
                    .foregroundStyle(
                        LinearGradient(colors: [
                            .white,
                            Color.init(red: 255, green: 218, blue: 236)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .font(.system(size: 36, weight: .bold, design: .default))
                
                Spacer()
                
                Button {
                    showingAddClient = true
                } label: {
                    Image(.plusImag)
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 40, height: 40)
            }
            
            HStack {
                TextField("", text: $searchText, prompt:
                            Text("Search clients")
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
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(filteredClients, id: \.objectID) { client in
                        ClientsItemView(viewModel: ClientsItemViewModel(
                            id: client.id?.uuidString ?? "",
                            name: client.name ?? "Unknown",
                            number: client.phoneNumber ?? "No phone",
                            countOrders: "\(dataViewModel.getClientOrderCount(client)) Orders",
                            recentOrders: getRecentOrdersForClient(client)
                        ))
                        .contextMenu {
                            Button(role: .destructive) {
                                dataViewModel.deleteClient(client)
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
        .sheet(isPresented: $showingAddClient) {
            AddClientScreen(dataViewModel: dataViewModel)
        }

        .onAppear {
            dataViewModel.loadData()
        }
    }
    
    private func getRecentOrdersForClient(_ client: Client) -> [String] {
        let clientOrders = dataViewModel.orders.filter { order in
            order.clientName == client.name
        }.sorted { order1, order2 in
            (order1.orderDate ?? Date()) > (order2.orderDate ?? Date())
        }
        
        return clientOrders.prefix(3).map { order in
            "\(order.productName ?? "Unknown") - \(order.status ?? "Current")"
        }
    }
}



#Preview {
    ClientsScreen()
        .environmentObject(DataViewModel())
}
