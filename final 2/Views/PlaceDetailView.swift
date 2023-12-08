//
//  PlaceDetailView.swift
//  final 2
//
//  Created by James Toh on 29/11/23.
//


    import SwiftUI

    struct PlaceDetailView: View {
        @Binding var place: Itinerary.Place
        @State var itinerary: Itinerary
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text(place.placename)
                    .font(.title)
                    .fontWeight(.bold)

                Text(place.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Group{
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date Range")
                            .font(.headline)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack{
                            Text("Budget")
                                .font(.headline)
                            Text("\(itinerary.totalcost)")
                        }
                      

                    }
                    .padding()

                    Text("Duration: (place.durationInMinutes) minutes")
                    // or
                    // Text("Duration: (place.durationInHours) hours")

                    Spacer()
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
            .navigationTitle(place.placename)
        }
    }
