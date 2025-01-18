//
//  Globals.swift
//  AdventurePlanner
//
//  Created by Darren Hsu and Osman Balci on 4/20/24.
//  Copyright © 2024 Darren Hsu and Osman Balci. All rights reserved.
//

import Foundation


**************************************
*   Google Places API HTTP Headers   *
**************************************
*/
let googlePlacesApiHeaders = [
    "accept": "application/json",
    "cache-control": "no-cache",
    "connection": "keep-alive",
    "host": "maps.googleapis.com"
]

/*
**************************************
*   Covid API HTTP Headers   *
**************************************
*/
let covidHeaders = [
    "content-type": "application/json",
    "connection": "Close"
]

/*
**************************************
*   GEO Cities API HTTP Headers   *
**************************************
*/
let cityHeaders = [
    "content-type": "application/json",
    "connection": "Close",
    "X-RapidAPI-Key": "49013351bamsh24dfb596f78886ap1e083bjsn6459aefa24db",
    "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"

]


/*
*************************************
*   Open Weather API HTTP Headers   *
*************************************
*/
let openWeatherApiHeaders = [
    "accept": "application/json",
    "cache-control": "no-cache",
    "connection": "keep-alive",
    "host": "api.openweathermap.org"
]

//-----------------------------------------
// Global Alert Title and Message Variables
//-----------------------------------------
var alertTitle = ""
var alertMessage = ""

