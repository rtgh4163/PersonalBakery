
import SwiftUI

struct GoodsItemView: View {
    private var viewModel: GoodsItemViewModel
    
    init(viewModel: GoodsItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(12)
            } else {
                Image(.defaultCake)
                    .resizable()
                    .frame(height: 140)
                    .cornerRadius(12)
            }
            
            HStack {
                Text(viewModel.name)
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .textCase(.uppercase)
                Spacer()
                Text(viewModel.price)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .textCase(.uppercase)
            }
            .padding(.top, 12)
            
            Text(viewModel.isInStock ? "in stock" : "out of stock")
                .foregroundStyle(viewModel.isInStock ? Color.init(red: 255, green: 38, blue: 142) : Color.red)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 2)
            
            Spacer()
        }
        .padding(12)
        .background(
            RadialGradient(colors: [
                Color.init(red: 106, green: 36, blue: 82),
                Color.init(red: 64, green: 26, blue: 51)
            ], center: .bottom, startRadius: 10, endRadius: 200)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(LinearGradient(colors: [
                    Color.init(red: 157, green: 87, blue: 133),
                    Color.init(red: 71, green: 34, blue: 58)
                ], startPoint: .bottom, endPoint: .top), lineWidth: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    GoodsItemView(viewModel: GoodsItemViewModel(
        id: "1",
        name: "Cake",
        price: "120",
        isInStock: true
    ))
    .padding()
}
