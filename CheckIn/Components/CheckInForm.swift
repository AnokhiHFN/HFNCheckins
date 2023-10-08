import SwiftUI

protocol CheckInFormDelegate: AnyObject {
    func checkinButtonPressed()
}

struct SwiftUIView: View {
    weak var delegate: CheckInFormDelegate?
    @Binding var batch: String // Use Binding
    @State private var fullName = ""
    @State private var selectedAgeRange = 0
    @State private var gender = "Male"
    @State private var city = ""
    @State private var state = ""
    @State private var mobile = ""
    @State private var email = ""
    @State private var dorm = ""
    
    let ageRanges = [
        "0-20",
        "20-40",
        "40-60",
        "60-80",
        "80-100"
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
                }
                
                Section {
                    TextField("Mobile", text: $mobile)
                    
                    TextField("Email", text: $email)
                    
                    TextField("Dorm", text: $dorm)
                }
                
                Section {
                    HStack {
                        VStack {
                            Button(action: {
                                
                            }){
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
        
       
    }
       
       
}
