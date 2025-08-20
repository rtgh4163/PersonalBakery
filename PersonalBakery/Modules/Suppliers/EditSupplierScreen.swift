import SwiftUI

struct EditSupplierScreen: View {
    let supplier: Supplier
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var phoneNumber: String
    @State private var email: String
    @State private var address: String
    @State private var contactPerson: String
    @State private var website: String
    @State private var notes: String
    @State private var rating: Int16
    @State private var status: String
    @State private var showingDeleteAlert = false
    
    let statusOptions = ["Active", "Inactive"]
    
    init(supplier: Supplier) {
        self.supplier = supplier
        _name = State(initialValue: supplier.name ?? "")
        _phoneNumber = State(initialValue: supplier.phoneNumber ?? "")
        _email = State(initialValue: supplier.email ?? "")
        _address = State(initialValue: supplier.address ?? "")
        _contactPerson = State(initialValue: supplier.contactPerson ?? "")
        _website = State(initialValue: supplier.website ?? "")
        _notes = State(initialValue: supplier.notes ?? "")
        _rating = State(initialValue: supplier.rating)
        _status = State(initialValue: supplier.status ?? "Active")
    }
    
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
                            actionButtonsSection
                        }
                        .padding(.vertical, 20)
                        .padding(.bottom, 50)
                    }
                }
            }
            .alert("Delete Supplier", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteSupplier()
                }
            } message: {
                Text("Are you sure you want to delete this supplier? This action cannot be undone.")
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
    }
    
    private var headerView: some View {
        HStack {
            Text("EDIT SUPPLIER")
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
                
                statusSection
                ratingSection
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium, design: .rounded))
            
            Picker("Status", selection: $status) {
                ForEach(statusOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
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
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            updateButton
            deleteButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    private var updateButton: some View {
        Button {
            updateSupplier()
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Update Supplier")
            }
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 52, green: 199, blue: 89))
            )
        }
        .disabled(name.isEmpty || phoneNumber.isEmpty)
        .opacity(name.isEmpty || phoneNumber.isEmpty ? 0.6 : 1.0)
    }
    
    private var deleteButton: some View {
        Button {
            showingDeleteAlert = true
        } label: {
            HStack {
                Image(systemName: "trash.circle.fill")
                Text("Delete Supplier")
            }
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 255, green: 59, blue: 48))
            )
        }
    }
    
    private var backgroundGradient: some View {
        RadialGradient(colors: [
            Color.init(red: 63, green: 22, blue: 42),
            Color.init(red: 20, green: 9, blue: 27)
        ], center: .bottom, startRadius: 100, endRadius: 400)
    }
    
    private func updateSupplier() {
        dataViewModel.updateSupplier(
            supplier,
            name: name,
            phoneNumber: phoneNumber,
            email: email.isEmpty ? nil : email,
            address: address.isEmpty ? nil : address,
            contactPerson: contactPerson.isEmpty ? nil : contactPerson,
            website: website.isEmpty ? nil : website,
            notes: notes.isEmpty ? nil : notes,
            rating: rating,
            status: status
        )
        
        dismiss()
    }
    
    private func deleteSupplier() {
        dataViewModel.deleteSupplier(supplier)
        dismiss()
    }
}

#Preview {
    EditSupplierScreen(supplier: Supplier())
        .environmentObject(DataViewModel())
}
