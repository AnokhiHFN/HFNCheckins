import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestore

protocol CheckInFormDelegate: AnyObject {
    func checkinButtonPressed(with checkInData: CheckInData)
}

struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
            
        } else {
            content.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }
}

@available(iOS 14.0, *)
struct SwiftUIView: View {
    
    @Environment(\.presentationMode) var presentationMode
    weak var delegate: CheckInFormDelegate?
    @Binding var event: String // Use Binding
    @Binding var batch: String // Use Binding
    @Binding var email: String // Use Binding
    @Binding var mobile: String // Use Binding
    @State private var fullName = ""
    @State private var ageGroup = "0"
    @State private var gender: String = "Not Selected"
    @State private var city = ""
    @State private var state = ""
    @State private var country = ""
    @State private var dorm = ""
    @State private var isCheckinButtonEnabled = false // Added state for button
    @State private var dormAndBertAllocation = ""

    
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
                }.listRowBackground(Color("formColor"))

                
                Section {
                    TextField("Full Name", text: $fullName)
                    HStack {
                        VStack {
                            Picker("Age", selection: $ageGroup) {
                                ForEach(0..<ageRanges.count, id: \.self) { index in
                                    Text(ageRanges[index]).tag(ageRanges[index])
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .frame(width: 130)
                        }.listRowBackground(Color("formColor"))
                        
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
                }.listRowBackground(Color("formColor"))
                
                Section {
                    TextField("City", text: $city)
                    
                    TextField("State", text: $state)
                    
                    TextField("Country", text: $country) // Added country field
                }.listRowBackground(Color("formColor"))
                Section {
                    TextField(mobilePlaceholder, text: $mobile)
                        .disabled(isMobileFieldDisabled)
                    
                    TextField(emailPlaceholder, text: $email)
                        .disabled(isEmailFieldDisabled)
                    
                    TextField("Dorm", text: $dorm)
                }.listRowBackground(Color("formColor"))
                
                Section {
                    HStack {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("buttonColor"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .onTapGesture {
                                // Dismiss the current view (SwiftUIView)
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                        
                        Text("Check-in")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("buttonColor"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .onTapGesture {
                                let checkInData = CheckInData(
                                    event: event,
                                    batch: batch,
                                    fullName: fullName,
                                    mobile: mobile,
                                    email: email,
                                    ageGroup: ageGroup,
                                    gender: gender,
                                    city: city,
                                    state: state,
                                    country: country,
                                    timestamp: DateUtility.getCurrentTimestamp(),
                                    dormAndBerthAllocation: dorm
                                )
                                delegate?.checkinButtonPressed(with: checkInData)
                            }
                            .disabled(!isCheckinButtonEnabled)
                            .opacity(isCheckinButtonEnabled ? 1.0 : 0.5)
                    }
                    
                    
                }.listRowBackground(Color("formColor")) // section
                
                
                
            } // form
            .modifier(FormHiddenBackground())
            .listRowBackground(Color("formColor"))
            .cornerRadius(10)
            .padding(10)
           .background(
                Image("Background") // Replace with your image name
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
            )
            
        } // vstack
        
        .onAppear {
            // Check if the required fields are filled to enable the button

            updateCheckinButtonState()
            
            }// Add your background color

                .onChange(of: batch, perform: { newValue in
                    // Watch for changes in the batch field
                    updateCheckinButtonState()
                })
                .onChange(of: fullName, perform: { newValue in
                    // Watch for changes in the fullName field
                    updateCheckinButtonState()
                })
                .onChange(of: ageGroup, perform: { newValue in
                    // Watch for changes in the ageGroup field
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
        
    } // SwiftUIView
    
    private func updateCheckinButtonState() {
        // Handle "0" as a special case
        let isValidAgeGroup = ageGroup != nil && ageGroup != "0"
        isCheckinButtonEnabled = !batch.isEmpty &&
                                !fullName.isEmpty &&
                                isValidAgeGroup &&
                                gender != "Not Selected" &&
                                !city.isEmpty &&
                                !state.isEmpty &&
                                !country.isEmpty
    }
}
