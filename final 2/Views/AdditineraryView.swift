import SwiftUI

struct AddItineraryView: View {
    
    @Binding var itineraries: [Itinerary]
    @State private var countryname = ""
    var alignToControl: Bool = false
    @State var daysdefault = 0
    @State var totalcostdefault = 0
    @State var startdatedefault = Date()
    @State var enddatedefault = Date()
    @Environment(\.dismiss) var dismiss
    @State private var selectedCurrency = "USD"
    @State var error = false

    let availableCurrencies: [String] = {
        let locales = Locale.availableIdentifiers.map { Locale(identifier: $0) }
        return locales.compactMap { $0.currency?.identifier }
    }()
    
    var body: some View {
        VStack{
            NavigationView{
                Form {
                    Section("Itinerary Name") {
                        VStack{
                            TextField("Enter a title (Example: Trip to India)", text: $countryname)
                        }
                    }
                    
                    Section("Budget"){
                        HStack{
                            Text("Currency:")
                            Picker("", selection: $selectedCurrency) {
                                ForEach(availableCurrencies, id: \.self) { currencyCode in
                                    Text("\(currencyName(currencyCode: currencyCode)) (\(currencyCode))")
                                       .tag(currencyCode)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .colorMultiply(.black)
                        }
                        HStack {
                            Text("Budget:                                                 ")
                            Spacer()
                            
                            TextField("", value: $totalcostdefault, formatter: NumberFormatter())
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 90)
                                .alignmentGuide(.controlAlignment) { $0[.leading] }
                                .keyboardType(UIKeyboardType.numberPad)
                            
                            //                                Stepper("Enter budget", value: $totalcostdefault, in: 1...1000000000000000000)
                            //                                    .labelsHidden()
                            //                                    .foregroundColor(.blue)
                            Spacer()
                            
                            
                            
                                .alignmentGuide(.leading) {
                                    self.alignToControl
                                    ? $0[.controlAlignment]
                                    : $0[.leading]
                                }
                        }
                    }
                    
                    
                    
                    Section("Dates"){
                        VStack{
                            DatePicker("Start:",selection: $startdatedefault, in: Date()..., displayedComponents: .date)
                            DatePicker("End:",selection: $enddatedefault, in: Date()..., displayedComponents: .date)
                                .onChange(of: [startdatedefault, enddatedefault]) { _ in
                                    updateNumberOfDays()
                                }
                            HStack {
                                Text("Number of days:                        ")
                                Spacer()
                                TextField("", value: $daysdefault, formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth:90)
                                    .foregroundColor(.blue)
                                    .alignmentGuide(.controlAlignment) { $0[.leading]}
                                    .disabled(true)
                                
                                Spacer()
                            }
                            .alignmentGuide(.leading) {
                                self.alignToControl
                                ? $0[.controlAlignment]
                                : $0[.leading]
                            }
                        }
                    }
                    
                    
                    Section {
                        Button("Save", role: .none) {
                            if startdatedefault > enddatedefault{
                                error = true
                                
                            }
                            else{let newitinerary = Itinerary(country: countryname, startdate: startdatedefault, iscompleted: false, enddate: enddatedefault, days: daysdefault, totalcost: totalcostdefault, currency: selectedCurrency, places: [] )
                                print("hello world")
                                print(newitinerary)
                                itineraries.append(newitinerary)
                                dismiss()
                                }
                            
                        }
                        Button("Cancel", role: .destructive) {
                            dismiss()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar{
                    ToolbarItem(placement: .principal){
                        Text("Add Itinerary").font(.title)
                            .bold()
                    }
                }
                
                
                
            }
            
            
            
        }
        .alert(isPresented:$error){Alert(
            title: Text("Invalid Start Date"),
            message: Text("Change Start Date to be lower than End Date."),
            
            dismissButton: .default(Text("OK")) {
                                error = false
                            }
        )}
    }
    
    
    
    
    private func updateNumberOfDays() {
        let numberOfDays = Calendar.current.numberOfDaysBetween(startdatedefault, and: enddatedefault)
        daysdefault = numberOfDays
    }
    
    
    func currencyName(currencyCode: String) -> String {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode]))
        return locale.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
    }
}



extension HorizontalAlignment {
    private enum ControlAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.center]
        }
    }
    static let controlAlignment = HorizontalAlignment(ControlAlignment.self)
}


extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1 // <1>
    }
}
