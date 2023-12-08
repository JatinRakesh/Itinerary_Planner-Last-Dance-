import SwiftUI
import MapKit

struct ItineraryDetailsView: View {
    
    @Binding var itinerary: Itinerary
    @ObservedObject var itineraryManager: ItineraryManager
    @State var additemtransit = false
    @State private var showSheet = false
    @State private var selectedDate = Date()
    @State private var isDatesExpanded = true
    @State private var showBudget = false
    @State private var size = false
    var numberOfDays: Int {
        Calendar.current.calculateDaysBetween(itinerary.startdate, and: itinerary.enddate)
    }
    
    var body: some View {
        VStack {
            List(1..<(numberOfDays+1), id: \.self) { day in
                Section(day1(day:day,startdate:itinerary.startdate)) {
                    ForEach(itinerary.places.filter { doesItineraryFallOnDate(date: dateFromDayNumber(day), place: $0) }) { place in
                        NavigationLink(destination: PlaceDetailView(place: placeBinding(place), itinerary: itinerary)) {
                            HStack(alignment: .top) {
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text(place.placename)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                }
                                
                                Text(place.address)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(place.startDate, formatter: dateFormatter)")
                            }
                        }
                    }
                }
            }
            Hiding(itinerary:$itinerary)
                .frame(maxHeight:size ? 300 : 0)
            
        }
        .toolbar {
            ToolbarItem {
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem{
                Button {
                    size = size ? false : true
                    
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
            
        }
        .onAppear {
            print(itinerary.places)
        }
        .navigationTitle(itinerary.country)
        .sheet(isPresented: $showSheet) {
            SearchView(itinerary: $itinerary)
            
        }
        .sheet(isPresented: $showBudget){
            Hiding(itinerary:$itinerary)
                .presentationDetents([.medium])
        }
    }

    func dateFromDayNumber(_ dayNumber: Int) -> Date {
        print("day \(dayNumber)")
        return itinerary.startdate.advanced(by: TimeInterval((dayNumber - 1) * 24 * 60 * 60))
    }
    
    func day1(day:Int,startdate: Date) -> String {
        var dateComponents = DateComponents()
        dateComponents.day = (day-1)
        guard let newDate = Calendar.current.date(byAdding: dateComponents, to: startdate) else {
            fatalError("Failed to calculate new date")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE, d MM")
        return dateFormatter.string(from: newDate)
    }
    private func filteredPlaces(day: Int, itinerary: Itinerary) -> [Itinerary.Place] {
        return itinerary.places.filter { doesItineraryFallOnDate(date: dateFromDayNumber(day), place: $0) }
    }
    
    func placeBinding(_ place: Itinerary.Place) -> Binding<Itinerary.Place> {
        Binding(
            get: {
                place
            },
            set: { newValue in
                if let index = itinerary.places.firstIndex(where: { $0.id == newValue.id }) {
                    itinerary.places[index] = newValue
                }
            }
        )
    }
    
    
    
    
    func doesItineraryFallOnDate(date: Date, place: Itinerary.Place) -> Bool {
        let dateComponents = Calendar.current.dateComponents([.day,.month,.year], from: date)
        let day = dateComponents.day!
        let month = dateComponents.month!
        let year = dateComponents.year!
        
        let midnightOfDay = DateComponents(year:year, month: month, day: day, hour: 0, minute: 0, second: 0)
        let lastSecondOfDay = DateComponents(year:year, month: month, day: day, hour: 23, minute: 59, second: 59)
        
        
        let midnight = Calendar.current.date(from: midnightOfDay) ?? Date()
        let lastSecond = Calendar.current.date(from: lastSecondOfDay) ?? Date()
        
        let test = (midnight...lastSecond).contains(place.startDate)
        if test {
            print("Date \(place.startDate)")
            return test
        } else {
            return false
        }
    }
}

extension Calendar {
    func calculateDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        return numberOfDays.day! + 1
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
//extension View {
//    func eraseToAnyView() -> AnyView {
//        return AnyView(self)
//    }
//}
