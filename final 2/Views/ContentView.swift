//
//  ContentView.swift
//  final 2
//
//  Created by Jhala family on 20/11/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var itineraryManager = ItineraryManager()
    @State private var showSheet = false
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver: Bool = false
    
    var body: some View {
        if isWelcomeScreenOver == true {
            TabView{
                HomeView(itineraryManager: itineraryManager)
                    .tabItem{
                        Label("Home", systemImage: "house.fill")
                    }
                itineraryView(itineraryManager: itineraryManager)
                    .tabItem{
                        Label("Itineraries", systemImage: "list.clipboard.fill")
                    }
            }
        } else {
//       
            IntroPageView(isWelcomeScreenOver: $isWelcomeScreenOver)
           
        }
        
    }
}

#Preview {
    ContentView()
}
