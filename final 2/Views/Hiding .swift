
import SwiftUI

struct Hiding: View {
    @State var showingSection1 = true
    @Binding var itinerary: Itinerary
    @State var showAlert = false
    let availableCurrencies: [String] = {
        let locales = Locale.availableIdentifiers.map { Locale(identifier: $0) }
        return locales.compactMap { $0.currency?.identifier }
    }()
    
    var body: some View {
        List {
            Section(
                header: SectionHeader(
                    title: "Additional Info"
                    //                    isOn: $showingSection1,
                    //                    onLabel: "Hide",
                    //                    offLabel: "Show"
                )
            ) {
                if showingSection1 {
                    ConteView()
                    HStack{
                        Text("Currency:")
                        
                        Picker("", selection: $itinerary.currency) {
                            ForEach(availableCurrencies, id: \.self) { currencyCode in
                                Text("\(currencyName(currencyCode: currencyCode)) (\(currencyCode))")
                                    .tag(currencyCode)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .colorMultiply(.black)
                        
                    }
                    VStack{
                        HStack{
                            Text("Budget:")
                            Spacer()
                            Text("\(itinerary.totalcost)")
                        }
                        DatePicker("Start", selection: $itinerary.startdate, in: Date()...,displayedComponents: .date)
                            .datePickerStyle(DefaultDatePickerStyle())
                            .onChange(of: [itinerary.startdate, itinerary.enddate]) { _ in
                                if itinerary.startdate > itinerary.enddate {
                                    showAlert = true
                                }
                            }

                            }
                        DatePicker("End", selection: $itinerary.enddate, in: Date()...,displayedComponents: .date)
                            .datePickerStyle(DefaultDatePickerStyle())
                            }
                   
                     }
            .alert(isPresented: $showAlert) {
                 Alert(title: Text("Error"), message: Text("Start date cannot be later than end date"), dismissButton: .default(Text("OK")))
                    
                    }
                    
                    
                }
//                           
                
            }
            
            
            
            
        }
        func currencyName(currencyCode: String) -> String {
            let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode]))
            return locale.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
        }
    
    
    
    
    
    
    struct SectionHeader: View {
        
        @State var title: String
        //    @Binding var isOn: Bool
        //    @State var onLabel: String
        //    @State var offLabel: String
        
        var body: some View {
            //        Button(action: {
            //            withAnimation {
            //                isOn.toggle()
            //            }
            //        }, label: {
            //            if isOn {
            //                Text(onLabel)
            //            } else {
            //                Text(offLabel)
            //            }
            //        })
            //        .font(Font.caption)
            //        .foregroundColor(.accentColor)
            //        .frame(maxWidth: .infinity, alignment: .trailing)
            //        .overlay(
            //            Text(title),
            //            alignment: .leading
            Text(title)
                .multilineTextAlignment(.leading)
            
            
            
        }
    }
    
    struct ConteView: View {
        @State private var isImporting = false
        
        var body: some View {
            Button("Import Documents") {
                isImporting = true
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.item], allowsMultipleSelection: true) { result in
                switch result {
                case .success(let urls):
                    for url in urls {
                        print(url.path)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    
    

