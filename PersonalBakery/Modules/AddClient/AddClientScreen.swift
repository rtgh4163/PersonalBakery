

import SwiftUI

struct AddClientScreen: View {
    @State private var text = ""
    @State private var number = ""
    @Environment(\.dismiss) private var dismiss
    let dataViewModel: DataViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
            
            Text("Client name")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            HStack {
                TextField("", text: $text, prompt:
                            Text("Name")
                                .foregroundColor(Color.init(red: 175, green: 175, blue: 175))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                )
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .toolbar {
                }
                
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
            
            Text("Phone number")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .padding(.top, 24)
                
            HStack {
                TextField("", text: $number, prompt:
                            Text("Number")
                                .foregroundColor(Color.init(red: 175, green: 175, blue: 175))
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                )
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .keyboardType(.phonePad)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            hideKeyboard()
                        }
                    }
                }
                
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
            
            Button {
                addClient()
            } label: {
                Text("Add Client")
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
            .disabled(text.isEmpty || number.isEmpty)
            .opacity(text.isEmpty || number.isEmpty ? 0.6 : 1.0)
            
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
                    Text("Add Client")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }
        }
    }
    
    private func addClient() {
        guard !text.isEmpty && !number.isEmpty else { return }
        dataViewModel.addClient(name: text, phoneNumber: number)
        dismiss()
    }
}

#Preview {
    AddClientScreen(dataViewModel: DataViewModel())
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
