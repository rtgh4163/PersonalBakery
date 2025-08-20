
import SwiftUI

struct MainTabView: View {
    @StateObject private var dataViewModel = DataViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                HomeScreen()
                    .environmentObject(dataViewModel)
                    .tag(0)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                OrdersScreen()
                    .environmentObject(dataViewModel)
                    .tag(1)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                ClientsScreen()
                    .environmentObject(dataViewModel)
                    .tag(2)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                GoodsScreen()
                    .environmentObject(dataViewModel)
                    .tag(3)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                StatisticsScreen()
                    .environmentObject(dataViewModel)
                    .tag(4)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                
                SuppliersScreen()
                    .environmentObject(dataViewModel)
                    .tag(5)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color(red: 69, green: 53, blue: 59))
                    .frame(height: 1)
                
                HStack(spacing: 0) {
                    TabButton(
                        icon: .init("home"),
                        title: "Home",
                        isSelected: selectedTab == 0
                    ) {
                        selectedTab = 0
                    }
                    
                    TabButton(
                        icon: .init("orders"),
                        title: "Orders",
                        isSelected: selectedTab == 1
                    ) {
                        selectedTab = 1
                    }
                    
                    TabButton(
                        icon: .init("clients"),
                        title: "Clients",
                        isSelected: selectedTab == 2
                    ) {
                        selectedTab = 2
                    }
                    
                    TabButton(
                        icon: .init("goods"),
                        title: "Goods",
                        isSelected: selectedTab == 3
                    ) {
                        selectedTab = 3
                    }
                    
                    TabButton(
                        icon: Image(systemName: "chart.bar.fill"),
                        title: "Stats",
                        isSelected: selectedTab == 4
                    ) {
                        selectedTab = 4
                    }
                    
                    TabButton(
                        icon: Image(systemName: "truck.box.fill"),
                        title: "Suppliers",
                        isSelected: selectedTab == 5
                    ) {
                        selectedTab = 5
                    }
                }
                .background(Color(red: 28/255, green: 12/255, blue: 29/255))
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea(.container, edges: .top)
    }
}

struct TabButton: View {
    let icon: Image
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? Color(red: 255, green: 65, blue: 103) : Color(red: 184, green: 142, blue: 156))
                
                Text(title)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? Color(red: 255, green: 65, blue: 103) : Color(red: 184, green: 142, blue: 156))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

#Preview {
    MainTabView()
} 
