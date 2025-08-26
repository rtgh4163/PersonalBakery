import SwiftUI

struct SuppliersScreen: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var showingAddSupplier = false
    @State private var searchText = ""
    @State private var selectedFilter: SupplierFilter = .all
    
    enum SupplierFilter: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case inactive = "Inactive"
    }
    
    var filteredSuppliers: [Supplier] {
        let searchResults = dataViewModel.searchSuppliers(query: searchText)
        
        switch selectedFilter {
        case .all:
            return searchResults
        case .active:
            return searchResults.filter { $0.status == "Active" }
        case .inactive:
            return searchResults.filter { $0.status == "Inactive" }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SUPPLIERS")
                    .foregroundStyle(
                        LinearGradient(colors: [
                            .white,
                            Color.init(red: 255, green: 218, blue: 236)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                    .font(.system(size: 36, weight: .bold, design: .default))
                
                Spacer()
                
                Button {
                    showingAddSupplier = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color(red: 255, green: 65, blue: 103))
                        .font(.title)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            VStack(spacing: 16) {
                HStack {
                    TextField("", text: $searchText, prompt:
                                Text("Search suppliers")
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
                    
                    if !searchText.isEmpty {
                        Button("Clear") {
                            searchText = ""
                        }
                        .foregroundColor(Color(red: 255, green: 65, blue: 103))
                        .font(.caption)
                    }
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
                .padding(.horizontal, 16)
                
                HStack(spacing: 12) {
                    ForEach(SupplierFilter.allCases, id: \.self) { filter in
                        Spacer()
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter.rawValue)
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedFilter == filter
                                              ? Color(red: 255, green: 65, blue: 103)
                                              : Color(red: 80, green: 65, blue: 90))
                                )
                        }
                    }
                    Spacer()
                }
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Total Suppliers",
                    value: "\(dataViewModel.suppliers.count)",
                    icon: "person.3.fill",
                    color: Color(red: 52, green: 199, blue: 89)
                )
                
                StatCard(
                    title: "Active Suppliers",
                    value: "\(dataViewModel.suppliers.filter { $0.status == "Active" }.count)",
                    icon: "checkmark.circle.fill",
                    color: Color(red: 255, green: 193, blue: 7)
                )
                
                StatCard(
                    title: "Total Purchases",
                    value: "\(dataViewModel.purchases.count)",
                    icon: "cart.fill",
                    color: Color(red: 88, green: 86, blue: 214)
                )
                
                StatCard(
                    title: "Total Spent",
                    value: dataViewModel.formatPrice(dataViewModel.purchases.reduce(0) { $0 + $1.amount }),
                    icon: "dollarsign.circle.fill",
                    color: Color(red: 255, green: 65, blue: 103)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(filteredSuppliers, id: \.objectID) { supplier in
                        SupplierRowView(supplier: supplier)
                            .environmentObject(dataViewModel)
                    }
                }
                .padding(.horizontal, 16)
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
        .sheet(isPresented: $showingAddSupplier) {
            AddSupplierScreen()
                .environmentObject(dataViewModel)
        }
        .onAppear {
            dataViewModel.loadData()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
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
                    .font(.system(size: 20, weight: .bold, design: .default))
                
                Text(title)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(
            RadialGradient(colors: [
                Color.init(red: 106, green: 36, blue: 82),
                Color.init(red: 64, green: 26, blue: 51)
            ], center: .bottom, startRadius: 10, endRadius: 200)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(LinearGradient(colors: [
                    Color.init(red: 106, green: 36, blue: 82),
                    Color.init(red: 64, green: 26, blue: 51)
                ], startPoint: .bottom, endPoint: .top), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SuppliersScreen()
        .environmentObject(DataViewModel())
}

