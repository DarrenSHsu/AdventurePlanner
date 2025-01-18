//
//  CreatePDF.swift
//  AdventurePlanner
//
//  Created by Nicholas Luke Emig on 4/27/24.
//  Copyright © 2024 Nicholas Emig. All rights reserved.
//

import SwiftUI
import PDFKit

struct createPDF: View {
    
    // Input parameter:
    let dest: Destination
    
    var body: some View {
        Section() {
            Spacer()
            Button("Save PDF") {
                saveTripPDF()
            }
            Spacer()
        }
        PDFKitView(pdfData: PDFDocument(data: createTripPDF())!)
    }
    
    // Creates a PDF document populated with Trip details
    @MainActor
    func createTripPDF() -> Data {
        
        // Sets the PDF dimensions
        let pdfRender = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y:0, width: 595, height: 842))
        
        // Determines the data in the PDF Document
        let data = pdfRender.pdfData { context in
            
            // Create a new page in the PDF document
            context.beginPage()
            
            // Set attribute Formats
            let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)]
            let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
            let smallTitleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
            let placesAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
            
            // Add title
            let city = "\(dest.name) Trip Details"
            city.draw(at: CGPoint(x:20, y:50), withAttributes: titleAttributes)
            
            // Create a variable to increment y values.
            var yval = 115
            
            // Adds region details, if available
            if (dest.region != "") {
                "Region: \(dest.region)".draw(at: CGPoint(x: 20, y: yval), withAttributes: normalAttributes)
                yval = yval + 50
            }
            
            // Adds country details
            "Country: \(dest.country)".draw(at: CGPoint(x: 20, y: yval), withAttributes: normalAttributes)
            yval = yval+50
            
            // Adds population details
            "Population: About \(dest.population) people".draw(at: CGPoint(x: 20, y: yval), withAttributes: normalAttributes)
            yval=yval+100
            
            // Adds covid data, if available
            if !dest.covidData!.activeCases.isEmpty {
                "COVID Data".draw(at: CGPoint(x: 20, y: yval), withAttributes: smallTitleAttributes)
                yval=yval+50
                
                "Last Poll Date: \(dest.covidData!.lastUpdate)".draw(at: CGPoint(x: 20, y: yval), withAttributes: normalAttributes)
                yval=yval+50
                
                "Active COVID Cases: \(dest.covidData!.activeCases)".draw(at: CGPoint(x: 20, y: yval), withAttributes: normalAttributes)
                yval=yval+50
                
                "Total COVID Cases: \(dest.covidData!.totalCases)".draw(at: CGPoint(x: 20, y: yval), withAttributes: normalAttributes)
                yval=yval+50
                
                "Total Death Count: \(dest.covidData!.totalDeaths)".draw(at: CGPoint(x: 20, y: yval), withAttributes: normalAttributes)
                yval=yval+50
                
                "Total Recovered Count: \(dest.covidData!.totalRecovered)".draw(at: CGPoint(x: 20, y: yval), withAttributes: normalAttributes)
                yval=yval+100
            }
            
            // Add the names of found places to the document, if any
            if !dest.destPlaces!.isEmpty {
                "Saved Places:".draw(at: CGPoint(x: 20, y: yval), withAttributes: smallTitleAttributes)
                yval=yval+50
                // Loops through each place in the destPlaces array
                for aPlace in dest.destPlaces! {
                    // We choose y=760 as the max y value, create new pages past that point
                    if yval > 760 {
                        context.beginPage()
                        yval = 50
                    }
                    "- \(aPlace.name)".draw(at: CGPoint(x: 20, y: yval), withAttributes: placesAttributes)
                    yval=yval+50
                    if yval > 760 {
                        context.beginPage()
                        yval = 50
                    }
                    "      \(aPlace.rating) stars out of \(aPlace.user_ratings_total) reviews".draw(at: CGPoint(x: 20, y: yval), withAttributes: placesAttributes)
                    yval=yval+50
                    if yval > 760 {
                        context.beginPage()
                        yval = 50
                    }
                    if (aPlace.business_status == "CLOSED_TEMPORARILY") {
                        "      Status: Temporarily Closed".draw(at: CGPoint(x: 20, y: yval), withAttributes: placesAttributes)
                    } else if (aPlace.business_status == "OPERATIONAL") {
                        "      Status: Open To The Public".draw(at: CGPoint(x: 20, y: yval), withAttributes: placesAttributes)
                    } else {
                        "      Status: Permanently Closed".draw(at: CGPoint(x: 20, y: yval), withAttributes: placesAttributes)
                    }
                    yval=yval+50
                    if yval > 760 {
                        context.beginPage()
                        yval = 50
                    }
                }
            }
        }
        return data
    }
    
    // Function that allows a user to save the created PDF file to their document directory.
    @MainActor func saveTripPDF() {
        let fileName = "\(dest.name)TripDetails.pdf"
        let pdfData = createTripPDF()

        // Attempts to save the PDF document
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let documentURL = documentDirectory.appendingPathComponent(fileName)
            do {
                try pdfData.write(to: documentURL)
                print("PDF saved at: \(documentURL).")
            } catch {
                print("Could not save PDF to \(documentURL).")
            }
        }
    }
    
    // Allows the PDF document to be viewed in a seperate page (view)
    struct PDFKitView: UIViewRepresentable {
        let PDFDocument: PDFDocument
        
        // Initializes the PDFKitView
        init(pdfData PDFDoc: PDFDocument) {
            self.PDFDocument = PDFDoc
        }
        
        // Creates a new pdfView for the context (context is the details to be added to the document)
        func makeUIView(context: Context) -> PDFView {
            let PDFView = PDFView()
            PDFView.autoScales = true
            PDFView.document = PDFDocument
            return PDFView
        }
        
        // Updates the view
        func updateUIView(_ PDFView: PDFView, context: Context) {
            PDFView.document = PDFDocument
        }
    }
}

