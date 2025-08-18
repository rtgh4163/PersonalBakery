import SwiftUI
import Charts

struct StatisticsScreen: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedChartType: ChartType = .revenue
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case quarter = "Quarter"
        case year = "Year"
    }
    
    enum ChartType: String, CaseIterable {
        case revenue = "Revenue"
        case orders = "Orders"
        case products = "Products"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("STATISTICS")
                    .foregroundStyle(
                        LinearGradient(colors: [
                            .white,
                            Color.init(red: 255, green: 218, blue: 236)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .font(.system(size: 36, weight: .bold, design: .default))
                
                Spacer()
                
                Menu {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Button(range.rawValue) {
                            selectedTimeRange = range
                            dataViewModel.loadData()
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedTimeRange.rawValue)
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 106, green: 36, blue: 82))
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        MetricCard(
                            title: "Period Revenue",
                            value: dataViewModel.formatPrice(dataViewModel.getRevenueForTimeRange(selectedTimeRange)),
                            subtitle: selectedTimeRange.rawValue,
                            icon: "dollarsign.circle.fill",
                            color: Color(red: 255, green: 65, blue: 103)
                        )
                        
                        MetricCard(
                            title: "Period Orders",
                            value: "\(dataViewModel.getOrdersCountForTimeRange(selectedTimeRange))",
                            subtitle: selectedTimeRange.rawValue,
                            icon: "clock.fill",
                            color: Color(red: 255, green: 193, blue: 7)
                        )
                        
                        MetricCard(
                            title: "Total Clients",
                            value: "\(dataViewModel.clients.count)",
                            subtitle: "Registered",
                            icon: "person.2.fill",
                            color: Color(red: 52, green: 199, blue: 89)
                        )
                        
                        MetricCard(
                            title: "Products",
                            value: "\(dataViewModel.products.count)",
                            subtitle: "Available",
                            icon: "cube.box.fill",
                            color: Color(red: 88, green: 86, blue: 214)
                        )
                    }
                    .padding(.horizontal, 16)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("Top Performers")
                                .foregroundStyle(
                                    LinearGradient(colors: [
                                        .white,
                                        Color.init(red: 255, green: 218, blue: 236)
                                    ], startPoint: .top, endPoint: .bottom)
                                )
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        VStack(spacing: 12) {
                            Text("Top Products")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(Array(dataViewModel.getTopProducts(limit: 3)), id: \.objectID) { product in
                                TopPerformerRow(
                                    title: product.name ?? "Unknown",
                                    subtitle: "Cost: \(dataViewModel.formatPrice(product.cost))",
                                    value: "In Stock: \(product.isInStock ? "Yes" : "No")",
                                    color: Color(red: 88, green: 86, blue: 214)
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        VStack(spacing: 12) {
                            Text("Top Clients")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(Array(dataViewModel.getTopClients(limit: 3)), id: \.objectID) { client in
                                TopPerformerRow(
                                    title: client.name ?? "Unknown",
                                    subtitle: client.phoneNumber ?? "No phone",
                                    value: "Orders: \(dataViewModel.getClientOrderCount(client))",
                                    color: Color(red: 52, green: 199, blue: 89)
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("Recent Activity")
                                .foregroundStyle(
                                    LinearGradient(colors: [
                                        .white,
                                        Color.init(red: 255, green: 218, blue: 236)
                                    ], startPoint: .top, endPoint: .bottom)
                                )
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(Array(dataViewModel.getRecentOrders(limit: 5)), id: \.objectID) { order in
                                ActivityRow(
                                    title: order.clientName ?? "Unknown",
                                    subtitle: order.productName ?? "Unknown",
                                    date: dataViewModel.formatDate(order.orderDate),
                                    status: order.status ?? "Unknown",
                                    price: dataViewModel.formatPrice(order.price)
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
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
                    .onAppear {
                dataViewModel.loadData()
            }
            .onChange(of: selectedTimeRange) { _ in
                dataViewModel.loadData()
            }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Spacer()
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold, design: .default))
                
                Text(title)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                
                Text(subtitle)
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
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
                ], startPoint: .bottom, endPoint: .top), lineWidth: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TopPerformerRow: View {
    let title: String
    let subtitle: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                
                Text(subtitle)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 14, weight: .regular, design: .rounded))
            }
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white.opacity(0.8))
                .font(.system(size: 14, weight: .medium, design: .rounded))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 106, green: 36, blue: 82).opacity(0.3))
        )
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let date: String
    let status: String
    let price: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                
                Text(subtitle)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                
                Text(date)
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 12, weight: .regular, design: .rounded))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(price)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                
                Text(status)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 106, green: 36, blue: 82))
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 106, green: 36, blue: 82).opacity(0.3))
        )
    }
}

struct ChartContainer: View {
    let chartType: StatisticsScreen.ChartType
    let timeRange: StatisticsScreen.TimeRange
    let dataViewModel: DataViewModel
    
    var body: some View {
        VStack {
            switch chartType {
            case .revenue:
                RevenueChart(timeRange: timeRange, dataViewModel: dataViewModel)
            case .orders:
                OrdersChart(timeRange: timeRange, dataViewModel: dataViewModel)
            case .products:
                ProductsChart(timeRange: timeRange, dataViewModel: dataViewModel)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 106, green: 36, blue: 82).opacity(0.3))
        )
    }
}

struct RevenueChart: View {
    let timeRange: StatisticsScreen.TimeRange
    let dataViewModel: DataViewModel
    
    var body: some View {
        VStack {
            Text("Revenue Trend")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 255, green: 65, blue: 103).opacity(0.3))
                .overlay(
                    Text("Chart: \(timeRange.rawValue) Revenue")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                )
        }
    }
}

struct OrdersChart: View {
    let timeRange: StatisticsScreen.TimeRange
    let dataViewModel: DataViewModel
    
    var body: some View {
        VStack {
            Text("Orders Trend")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 255, green: 193, blue: 7).opacity(0.3))
                .overlay(
                    Text("Chart: \(timeRange.rawValue) Orders")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                )
        }
    }
}

struct ProductsChart: View {
    let timeRange: StatisticsScreen.TimeRange
    let dataViewModel: DataViewModel
    
    var body: some View {
        VStack {
            Text("Products Performance")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 88, green: 86, blue: 214).opacity(0.3))
                .overlay(
                    Text("Chart: \(timeRange.rawValue) Products")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                )
        }
    }
}

#Preview {
    StatisticsScreen()
        .environmentObject(DataViewModel())
}
