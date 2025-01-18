//
//  ForecastResultDetails.swift
//  AdventurePlanner
//
//  Created by Keming Liang and Osman Balci on 4/26/24.
//  Copyright © 2024 Keming Liang and Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData
import MapKit

fileprivate var cityLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct ForecastResultDetails: View {
    
    let forecast: WeatherListStruct
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    @State private var selectedMapStyleIndex = 0
    
    var body: some View {
        
        cityLocationCoordinate = CLLocationCoordinate2D(latitude: weatherItem.latitude, longitude: weatherItem.longitude)
        
        return AnyView(
            Form {
                Section(header: Text("Forecast Location")) {
                    Text("\(weatherItem.name), \(weatherItem.country)")
                }
                Section(header: Text("Select Map Style")) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    NavigationLink(destination: CityLocationOnMap(city: weatherItem, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Forecast Location on Map")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                    }
                }
                Section(header: Text("Date and Time of 3-Hour Forecast")) {
                    Text(forecast.dt_txt)
                }
                Section(header: Text("Weather Icon")) {
                    getImageFromUrl(url: "https://openweathermap.org/img/wn/\(forecast.weather.icon)@2x.png", defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                }
                Section(header: Text("Description")) {
                    Text(forecast.weather.description)
                }
                Section(header: Text("Humidity Percentage")) {
                    Text("\(forecast.humidity)%")
                }
                Section(header: Text("Minimum Temperature")) {
                    Text("\(String(forecast.temp_min))°F")
                }
                Section(header: Text("Maximum Temperature")) {
                    Text("\(String(forecast.temp_max))°F")
                }
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("3-Hour Forecast")
            .toolbarTitleDisplayMode(.inline)
        )
    }
    struct CityLocationOnMap: View {
        
        let city: ForecastStruct
        let mapStyleIndex: Int
        
        @State private var mapCameraPosition: MapCameraPosition = .region(
            MKCoordinateRegion(
                center: cityLocationCoordinate,
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
                    Marker("\(weatherItem.name), \(weatherItem.country)", coordinate: cityLocationCoordinate)
                }
                .mapStyle(mapStyle)
                .navigationTitle("\(weatherItem.name), \(weatherItem.country)")
                .toolbarTitleDisplayMode(.inline)
            )
        }   // End of body var
    }
}
