

import SwiftUI


    struct CurrencyPicker: View {
       @State private var selectedCurrency = "USD"

       let availableCurrencies: [String] = {
           let locales = Locale.availableIdentifiers.map { Locale(identifier: $0) }
           return locales.compactMap { $0.currency?.identifier }
       }()

       var body: some View {
           Picker("", selection: $selectedCurrency) {
               ForEach(availableCurrencies, id: \.self) { currencyCode in
                   Text("\(currencyName(currencyCode: currencyCode)) (\(currencyCode))")
                      .tag(currencyCode)
               }
           }
           .pickerStyle(MenuPickerStyle())
           .colorMultiply(.black)
       }

       func currencyName(currencyCode: String) -> String {
           let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode]))
           return locale.localizedString(forCurrencyCode: currencyCode) ?? currencyCode
       }
    }




#Preview {
    CurrencyPicker()
}
