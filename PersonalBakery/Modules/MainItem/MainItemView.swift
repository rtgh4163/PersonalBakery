
import SwiftUI

struct MainItemView: View {
    private var viewModel: MainItemViewModel
    
    init(viewModel: MainItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(.cakeIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
            
            VStack(spacing: 0) {
                Text(viewModel.name)
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 4) {
                    Text(viewModel.product)
                        .foregroundStyle(Color.init(red: 255, green: 38, blue: 142))
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .textCase(.uppercase)
                    switch viewModel.status {
                    case .none:
                        Text("1")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.clear)
                    case .ready:
                        Text("·")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .black, design: .rounded))
                        Text("Ready")
                            .foregroundStyle(Color.init(red: 197, green: 255, blue: 125))
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                        Spacer()
                    case .current:
                        Text("·")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .black, design: .rounded))
                        Text("Current")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                        Spacer()
                    case .unfinished:
                        Text("·")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .black, design: .rounded))
                        Text("Unfinished")
                            .foregroundStyle(Color.init(red: 255, green: 169, blue: 47))
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                        Spacer()
                    }
                }
            }
            
            VStack(spacing: 0) {
                Text(viewModel.price)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text(viewModel.date)
                    .foregroundStyle(.white.opacity(0.7))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
        }
        .padding(12)
        .background(
            LinearGradient(colors: [
                Color.init(red: 86, green: 52, blue: 123),
                Color.init(red: 61, green: 45, blue: 77)
            ], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(12)
    }
}

#Preview {
    MainItemView(viewModel: .init(id: "", name: "Bob Marley", product: "CAKE", status: .ready, price: "$120", date: "12.12.12"))
}
