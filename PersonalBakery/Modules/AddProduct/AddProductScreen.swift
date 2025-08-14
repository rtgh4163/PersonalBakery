
import SwiftUI
import PhotosUI

struct AddProductScreen: View {
    @State private var text = ""
    @State private var cost = ""
    @State private var isInStock = true
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.dismiss) private var dismiss
    let dataViewModel: DataViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Button(action: {
                    showingImagePicker = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 43, green: 36, blue: 48))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 91, green: 78, blue: 100), lineWidth: 1)
                            )
                            .frame(height: 200)
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(12)
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(red: 175, green: 175, blue: 175))
                                Text("Tap to add photo")
                                    .foregroundColor(Color(red: 175, green: 175, blue: 175))
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                        }
                    }
                }
                .padding(.bottom, 32)
                .padding(.horizontal, 52)
            
                Text("Item name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                HStack {
                    TextField("", text: $text, prompt:
                                Text("Cake")
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
                .padding(.top, 8)
                
                Text("Cost")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.top, 24)
                    
                HStack {
                    TextField("", text: $cost, prompt:
                                Text("120")
                                    .foregroundColor(Color.init(red: 175, green: 175, blue: 175))
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    )
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    
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
                .padding(.top, 8)
                
                HStack {
                    Text("In stock:")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    Toggle("", isOn: $isInStock)
                        .toggleStyle(SwitchToggleStyle(tint: Color(red: 238, green: 26, blue: 160)))
                }
                .padding(.top, 24)
                
                Button {
                    addProduct()
                } label: {
                    Text("Add item")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(
                    LinearGradient(colors: [
                        Color.init(red: 238, green: 26, blue: 160),
                        Color.init(red: 206, green: 0, blue: 79)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(99)
                .padding(.top, 32)
                .disabled(text.isEmpty || cost.isEmpty)
                .opacity(text.isEmpty || cost.isEmpty ? 0.6 : 1.0)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RadialGradient(colors: [
                    Color.init(red: 63, green: 22, blue: 42),
                    Color.init(red: 20, green: 9, blue: 27)
                ], center: .bottom, startRadius: 100, endRadius: 400)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add item")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func addProduct() {
        guard !text.isEmpty, let costValue = Double(cost) else { return }
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        dataViewModel.addProduct(name: text, cost: costValue, isInStock: isInStock, imageData: imageData)
        dismiss()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

#Preview {
    AddProductScreen(dataViewModel: DataViewModel())
}
