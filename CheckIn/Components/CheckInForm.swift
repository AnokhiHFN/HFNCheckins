import SwiftUI

protocol CheckInFormDelegate: AnyObject {
    func checkinButtonPressed()
}

@available(iOS 14.0, *)
struct SwiftUIView: View {
    @Environment(\.presentationMode) var presentationMode
    weak var delegate: CheckInFormDelegate?
    @Binding var batch: String // Use Binding
    @Binding var email: String // Use Binding
    @Binding var mobile: String // Use Binding
    @State private var fullName = ""
    @State private var selectedAgeRange = 0
    @State private var gender: String = "Not Selected"
    @State private var city = ""
    @State private var state = ""
    @State private var country = ""
    @State private var dorm = ""
    @State private var isCheckinButtonEnabled = false // Added state for button
    
    var mobilePlaceholder: String {
        if email.isEmpty {
            return "Phone Number"
        } else {
            return "Phone Number (Optional)"
        }
    }
    
    var emailPlaceholder: String {
        if mobile.isEmpty {
            return "Email"
        } else {
            return "Email (Optional)"
        }
    }
    
    var isEmailFieldDisabled: Bool {
        return !email.isEmpty
    }
    
    var isMobileFieldDisabled: Bool {
        return !mobile.isEmpty
    }
    
    let ageRanges = [
        "0",
        "0-4",
        "5-9",
        "10-14",
        "15-19",
        "20-24",
        "25-29",
        "30-34",
        "35-39",
        "40-44",
        "45-49",
        "50-54",
        "55-59",
        "60-64",
        "65-69",
        "79-74",
        "75-79",
        "80-84",
        "85-89",
        "90-94",
        "95-99",
        "100+"
    ]

    var body: some View {
        VStack {
            // Your existing content here
            
            // Add a divider or some space between existing content and the form
            Divider()
            
            Form {
                Section {
                    TextField("Batch", text: $batch)
                        .disabled(true)
                }
                
                Section {
                    TextField("Full Name", text: $fullName)
                    
                    HStack {
                        VStack {
                            Picker("Age", selection: $selectedAgeRange) {
                                ForEach(0..<ageRanges.count, id: \.self) { index in
                                    Text(ageRanges[index]).tag(index)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .frame(width: 130)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Picker("Gender", selection: $gender) {
                                Text("Select Gender").tag("Not Selected") // Placeholder option
                                Text("Male").tag("Male")
                                Text("Female").tag("Female")
                                Text("Unspecified").tag("Unspecified")
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .frame(width: 170)
                        }
                    }
                }
                
                Section {
                    TextField("City", text: $city)
                    
                    TextField("State", text: $state)
                    
                    TextField("Country", text: $country) // Added country field
                }
                
                Section {
                    TextField(mobilePlaceholder, text: $mobile)
                        .disabled(isMobileFieldDisabled)
                    
                    TextField(emailPlaceholder, text: $email)
                        .disabled(isEmailFieldDisabled)
                    
                    TextField("Dorm", text: $dorm)
                }
                
                Section {
                    HStack {
                        VStack {
                            Button(action: {
                                // Dismiss the current view (SwiftUIView)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("buttonColor"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    
                    HStack {
                        VStack {
                            Button(action: {
                                delegate?.checkinButtonPressed()
                            }){
                                Text("Check-in")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("buttonColor"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)

                            }
                            .disabled(!isCheckinButtonEnabled)
                            .opacity(isCheckinButtonEnabled ? 1.0 : 0.5) // Change opacity based on the state// Disable the button based on the state
                        }
                    }
                }
                
            }
            .cornerRadius(10)
            .padding(10)
            .background(
                       Image("Background") // Replace with your image name
                           .resizable()
                           .scaledToFill()
                           .frame(maxWidth: .infinity, maxHeight: .infinity)
                           .edgesIgnoringSafeArea(.all)
                   )
        }// Cover the entire screen
        
        .onAppear {
            // Check if the required fields are filled to enable the button
            updateCheckinButtonState()
            }

                .onChange(of: batch, perform: { newValue in
                    // Watch for changes in the batch field
                    updateCheckinButtonState()
                })
                .onChange(of: fullName, perform: { newValue in
                    // Watch for changes in the fullName field
                    updateCheckinButtonState()
                })
                .onChange(of: selectedAgeRange, perform: { newValue in
                    // Watch for changes in the selectedAgeRange field
                    updateCheckinButtonState()
                })
                .onChange(of: gender, perform: { newValue in
                    // Watch for changes in the gender field
                    updateCheckinButtonState()
                })
                .onChange(of: city, perform: { newValue in
                    // Watch for changes in the city field
                    updateCheckinButtonState()
                })
                .onChange(of: state, perform: { newValue in
                    // Watch for changes in the state field
                    updateCheckinButtonState()
                })
                .onChange(of: country, perform: { newValue in
                    // Watch for changes in the country field
                    updateCheckinButtonState()
                })
        
    }
    private func updateCheckinButtonState() {
        print("update Checking Button State")
        print("gender is nil? \(gender)")
        isCheckinButtonEnabled = !batch.isEmpty &&
                                !fullName.isEmpty &&
                                selectedAgeRange > 0 &&
                                gender != "Not Selected" &&
                                !city.isEmpty &&
                                !state.isEmpty &&
                                !country.isEmpty
        print("isCheckinButtonEnabled: \(isCheckinButtonEnabled)")
    }
}
