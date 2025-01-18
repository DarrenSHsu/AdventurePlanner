//
//  DestinationDetails.swift
//  AdventurePlanner
//
//  Created by Darren Hsu and Osman Balci on 4/25/24.
//  Copyright © 2024 Darren Hsu. All rights reserved.
//

import SwiftUI
import MapKit


fileprivate var destLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct DestinationDetails: View {
    
    //--------------
    // Progress View
    //--------------
    @State private var showProgressView = false
    
    @State private var showAlertMessage = false
    
    // Input Parameter
    let dest: Destination
    
    //---------
    // Map View
    //---------
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    @State private var selectedMapStyleIndex = 0
    
    var body: some View {
        
        destLocationCoordinate = CLLocationCoordinate2D(latitude: dest.latitude, longitude: dest.longitude)
        
        return AnyView(
            Form {
                Section(header: Text("")) {
                    NavigationLink(destination: createPDF(dest: dest)) {
                        HStack {
                            Image(systemName: "printer")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Generate printable PDF")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                if (dest.name != dest.city) {
                    Section(header: Text("Location Name")) {
                        Text(dest.name)
                    }
                }
                Section(header: Text("City Name")) {
                    Text(dest.city)
                }
                if (dest.region != "") {
                    Section(header: Text("Region")) {
                        Text(dest.region)
                    }
                }
                Section(header: Text("Country")) {
                    Text(dest.country)
                }
                Section(header: Text("Country Flag Image"), footer: Text("Official Flag of the Country").italic()) {
                    
                    getImageFromUrl(url: "https://flagcdn.com/w320/\(dest.countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                        // Flag image is obtained from the API with width of 320
                        .frame(minWidth: 300, maxWidth: 320, alignment: .center)
                        .contextMenu {
                            Button(action: {        // Context Menu Item
                                // Copy the flag image to universal clipboard for pasting elsewhere
                                UIPasteboard.general.image = getUIImageFromUrl(url: "https://flagcdn.com/w320/\(dest.countryCode.lowercased()).png", defaultFilename: "ImageUnavailable")
                                
                                showAlertMessage = true
                                alertTitle = "Flag Image is Copied to Clipboard"
                                alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                            }) {
                                Image(systemName: "doc.on.doc")
                                Text("Copy")
                            }
                        }
                }
                Section(header: Text("Population")) {
                    Text("About \(dest.population) People")
                }
                Section(header: Text("Select Map Style")) {
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    NavigationLink(destination: DestLocationOnMap(dest: dest, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Trip Location on Map")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                Section(header: Text("Update Covid Information")) {
                    HStack {
                        Spacer()
                        Button("Update") {
                            showProgressView = true
                            
                            searchApi(covid: dest.covidData ?? DestCovid(checkTime: "", activeCases: "", country: "", lastUpdate: "", newCases: "", newDeaths: "", totalCases: "", totalDeaths: "", totalRecovered: ""))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                /*
                                 Execute the following code after 0.1 second of delay
                                 so that they are not executed during the view update.
                                 */
                                
                                // API search is completed
                                showProgressView = false
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                    }
                }
                if showProgressView {
                    Section {
                        ProgressView()
                            // Style defined in ProgressViewStyle.swift
                            .progressViewStyle(DarkBlueShadowProgressViewStyle())
                    }
                }
                CovidDataView(covid: dest.covidData ?? DestCovid(checkTime: "Unchecked", activeCases: "", country: "", lastUpdate: "", newCases: "", newDeaths: "", totalCases: "", totalDeaths: "", totalRecovered: ""))
                if dest.destPhotos!.count > 0 {
                    Section(header: Text("Destination Photos")) {
                        NavigationLink(destination: DestinationPhotoList(dest: dest)) {
                            HStack {
                                Image(systemName: "photo.stack")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Photos")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Search and Add New Attractions")) {
                    NavigationLink(destination: SearchPlace(dest: dest)) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Search For Places")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                if ((dest.destPlaces?.isEmpty ?? true)) {
                    Section(header: Text("Saved Places")) {
                        Text("No Saved places! Add some by clicking on the button above.")
                    }
                }
                else {
                    Section(header: Text("Saved Places")) {
                        List {
                            ForEach(dest.destPlaces!) { aPlace in
                                NavigationLink(destination: PlaceDetails(place: aPlace)) {
                                    PlaceItem(place: aPlace)
                                }
                            }
                        }   // End of List                 }
                    }
                    Section(header: Text("View all Saved Places on Map")) {
                        NavigationLink(destination: PlacesOnMap(dest: dest)) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("View all Places on Map")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                 
            }   // End of Form
                .font(.system(size: 14))
                .navigationTitle("Destination Details")
                .toolbarTitleDisplayMode(.inline)
            
        )   // End of AnyView
    }   // End of body var
    struct DestLocationOnMap: View {
        
        // Input Parameters
        let dest: Destination
        let mapStyleIndex: Int
        
        @State private var mapCameraPosition: MapCameraPosition = .region(
            MKCoordinateRegion(
                center: destLocationCoordinate,
                // 1 degree = 69 miles. 10 degrees = 690 miles
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        )
        
        var body: some View {
            
            var mapStyle: MapStyle = .standard
            
            switch mapStyleIndex {
            case 0:
                mapStyle = MapStyle.standard
            case 1:
                mapStyle = MapStyle.imagery     // Satellite
            case 2:
                mapStyle = MapStyle.hybrid
            case 3:
                mapStyle = MapStyle.hybrid(elevation: .realistic)   // Globe
            default:
                print("Map style is out of range!")
            }
            
            return AnyView(
                Map(position: $mapCameraPosition) {
                    Marker(dest.city, coordinate: destLocationCoordinate)
                }
                .mapStyle(mapStyle)
                .navigationTitle("\(dest.city), \(dest.region), \(dest.countryCode)")
                .toolbarTitleDisplayMode(.inline)
            )
        }   // End of body var
    }
    
    func dateFormatter(newDate: String) -> String {
        // Create an instance of DateFormatter
        let dateFormatter = DateFormatter()
        
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        // Convert date String from "yyyy-MM-dd" to Date struct
        let dateStruct = dateFormatter.date(from: newDate)
        
        // Create a new instance of DateFormatter
        let newDateFormatter = DateFormatter()
        
        newDateFormatter.locale = Locale(identifier: "en_US")
        newDateFormatter.dateStyle = .long      // November 7, 2019
        newDateFormatter.timeStyle = .none
        
        // Obtain newly formatted Date String as "November 7, 2019"
        return newDateFormatter.string(from: dateStruct!)
    }
    /*
    ------------------
    MARK: Search API
    ------------------
    */
    func searchApi(covid: DestCovid) {
        getCovidData()
        
        for covidDataSet in covidDataList {
            if covidDataSet.country == covid.country || covidDataSet.country.contains(dest.country) || covidDataSet.country.contains(dest.countryCode) || dest.country.contains(covidDataSet.country){
                covid.checkTime = covidDataSet.checkTime
                covid.activeCases = covidDataSet.activeCases
                covid.country = covidDataSet.country
                covid.lastUpdate = covidDataSet.lastUpdate
                covid.newCases = covidDataSet.newCases
                covid.newDeaths = covidDataSet.newDeaths
                covid.totalCases = covidDataSet.totalCases
                covid.totalDeaths = covidDataSet.totalDeaths
                covid.totalRecovered = covidDataSet.totalRecovered
                break
            }
        }
    }

    
}
