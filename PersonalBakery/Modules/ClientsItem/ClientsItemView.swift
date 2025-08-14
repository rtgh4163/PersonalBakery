
import SwiftUI

struct ClientsItemView: View {
    private var viewModel: ClientsItemViewModel
    
    init(viewModel: ClientsItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(.clientIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
            
            VStack(spacing: 0) {
                Text(viewModel.name)
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 4) {
                    Text(viewModel.number)
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if !viewModel.recentOrders.isEmpty {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(viewModel.recentOrders.prefix(2), id: \.self) { order in
                            Text(order)
                                .foregroundStyle(.white.opacity(0.6))
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            Text(viewModel.countOrders)
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .bold, design: .rounded))
        }
        .padding(12)
        .background(
            LinearGradient(colors: [
                Color.init(red: 79, green: 70, blue: 93),
                Color.init(red: 69, green: 54, blue: 73)
            ], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(12)
    }
}

#Preview {
    ClientsItemView(viewModel: .init(id: "", name: "Bob Marley", number: "+48736464812", countOrders: "3 Orders"))
}
