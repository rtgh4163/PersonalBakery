import SwiftUI

struct AddSupplierScreen: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var address = ""
    @State private var contactPerson = ""
    @State private var website = ""
    @State private var notes = ""
    @State private var rating: Int16 = 5
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            basicInformationSection
                            additionalInformationSection
                            addButtonSection
                        }
                        .padding(.vertical, 20)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
    }
    
    private var headerView: some View {
        HStack {
            Text("ADD SUPPLIER")
                .foregroundStyle(
                    LinearGradient(colors: [
                        .white,
                        Color.init(red: 255, green: 218, blue: 236)
                    ], startPoint: .top, endPoint: .bottom)
                )
                .font(.system(size: 28, weight: .bold, design: .default))
            
            Spacer()
            
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(Color(red: 255, green: 65, blue: 103))
            .font(.system(size: 16, weight: .medium, design: .rounded))
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
    
    private var basicInformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Company Name *",
                    text: $name,
                    placeholder: "Enter company name"
                )
                
                CustomTextField(
                    title: "Phone Number *",
                    text: $phoneNumber,
                    placeholder: "Enter phone number"
                )
                
                CustomTextField(
                    title: "Email",
                    text: $email,
                    placeholder: "Enter email address"
                )
                
                CustomTextField(
                    title: "Address",
                    text: $address,
                    placeholder: "Enter address"
                )
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var additionalInformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Additional Information")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            
            VStack(spacing: 12) {
                CustomTextField(
                    title: "Contact Person",
                    text: $contactPerson,
                    placeholder: "Enter contact person name"
                )
                
                CustomTextField(
                    title: "Website",
                    text: $website,
                    placeholder: "Enter website URL"
                )
                
                CustomTextField(
                    title: "Notes",
                    text: $notes,
                    placeholder: "Enter additional notes"
                )
                
                ratingSection
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium, design: .rounded))
            
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        rating = Int16(star)
                    } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .foregroundColor(star <= rating ? Color(red: 255, green: 193, blue: 7) : .white.opacity(0.3))
                            .font(.title2)
                    }
                }
                
                Spacer()
                
                Text("\(rating)/5")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
        }
    }
    
    private var addButtonSection: some View {
        Button {
            addSupplier()
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Supplier")
            }
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 255, green: 65, blue: 103))
            )
        }
        .disabled(name.isEmpty || phoneNumber.isEmpty)
        .opacity(name.isEmpty || phoneNumber.isEmpty ? 0.6 : 1.0)
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var backgroundGradient: some View {
        RadialGradient(colors: [
            Color.init(red: 63, green: 22, blue: 42),
            Color.init(red: 20, green: 9, blue: 27)
        ], center: .bottom, startRadius: 100, endRadius: 400)
    }
    
    private func addSupplier() {
        dataViewModel.addSupplier(
            name: name,
            phoneNumber: phoneNumber,
            email: email.isEmpty ? nil : email,
            address: address.isEmpty ? nil : address,
            contactPerson: contactPerson.isEmpty ? nil : contactPerson,
            website: website.isEmpty ? nil : website,
            notes: notes.isEmpty ? nil : notes,
            rating: rating
        )
        dismiss()
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium, design: .rounded))
            
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 106, green: 36, blue: 82).opacity(0.3))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 106, green: 36, blue: 82), lineWidth: 1)
                )
        }
    }
}

#Preview {
    AddSupplierScreen()
        .environmentObject(DataViewModel())
}
