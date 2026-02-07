//
//  StateDataProvider.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/24/26.

//  Service providing state data for the game - All 50 US States
//

import Foundation
import CoreLocation

/// Provides access to US state data for gameplay
struct StateDataProvider {
    
    // MARK: - Public Methods
    
    /// Returns all available US states
    /// - Returns: Array of StateCard objects representing all 50 states
    static func getAllStates() -> [StateCard] {
        return [
            StateCard(
                name: "Alabama",
                nickname: "Yellowhammer State",
                capital: "Montgomery",
                syllables: 4,
                shape: "🏛️",
                character: "🎵",
                neighbors: ["Tennessee", "Georgia", "Florida", "Mississippi"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 32.806671, longitude: -86.791130)
            ),
            StateCard(
                name: "Alaska",
                nickname: "Last Frontier",
                capital: "Juneau",
                syllables: 3,
                shape: "❄️",
                character: "🐻",
                neighbors: [],
                isCoastal: true,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 61.370716, longitude: -152.404419)
            ),
            StateCard(
                name: "Arizona",
                nickname: "Grand Canyon State",
                capital: "Phoenix",
                syllables: 4,
                shape: "🌵",
                character: "☀️",
                neighbors: ["California", "Nevada", "Utah", "Colorado", "New Mexico"],
                isCoastal: false,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 33.729759, longitude: -111.431221)
            ),
            StateCard(
                name: "Arkansas",
                nickname: "Natural State",
                capital: "Little Rock",
                syllables: 3,
                shape: "💎",
                character: "🦆",
                neighbors: ["Missouri", "Tennessee", "Mississippi", "Louisiana", "Texas", "Oklahoma"],
                isCoastal: false,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 34.969704, longitude: -92.373123)
            ),
            StateCard(
                name: "California",
                nickname: "Golden State",
                capital: "Sacramento",
                syllables: 4,
                shape: "🌴",
                character: "😎",
                neighbors: ["Oregon", "Nevada", "Arizona"],
                isCoastal: true,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 36.116203, longitude: -119.681564)
            ),
            StateCard(
                name: "Colorado",
                nickname: "Centennial State",
                capital: "Denver",
                syllables: 4,
                shape: "🏔️",
                character: "⛷️",
                neighbors: ["Wyoming", "Nebraska", "Kansas", "Oklahoma", "New Mexico", "Arizona", "Utah"],
                isCoastal: false,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 39.059811, longitude: -105.311104)
            ),
            StateCard(
                name: "Connecticut",
                nickname: "Constitution State",
                capital: "Hartford",
                syllables: 4,
                shape: "⚓",
                character: "🦞",
                neighbors: ["Massachusetts", "Rhode Island", "New York"],
                isCoastal: true,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 41.597782, longitude: -72.755371)
            ),
            StateCard(
                name: "Delaware",
                nickname: "First State",
                capital: "Dover",
                syllables: 3,
                shape: "🏖️",
                character: "🦀",
                neighbors: ["Pennsylvania", "New Jersey", "Maryland"],
                isCoastal: true,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 39.318523, longitude: -75.507141)
            ),
            StateCard(
                name: "Florida",
                nickname: "Sunshine State",
                capital: "Tallahassee",
                syllables: 3,
                shape: "🐊",
                character: "🌞",
                neighbors: ["Alabama", "Georgia"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 27.766279, longitude: -81.686783)
            ),
            StateCard(
                name: "Georgia",
                nickname: "Peach State",
                capital: "Atlanta",
                syllables: 2,
                shape: "🍑",
                character: "🌳",
                neighbors: ["Tennessee", "North Carolina", "South Carolina", "Florida", "Alabama"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 33.040619, longitude: -83.643074)
            ),
            StateCard(
                name: "Hawaii",
                nickname: "Aloha State",
                capital: "Honolulu",
                syllables: 3,
                shape: "🌺",
                character: "🏄",
                neighbors: [],
                isCoastal: true,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 21.094318, longitude: -157.498337)
            ),
            StateCard(
                name: "Idaho",
                nickname: "Gem State",
                capital: "Boise",
                syllables: 3,
                shape: "🥔",
                character: "🏔️",
                neighbors: ["Montana", "Wyoming", "Utah", "Nevada", "Oregon", "Washington"],
                isCoastal: false,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 44.240459, longitude: -114.478828)
            ),
            StateCard(
                name: "Illinois",
                nickname: "Prairie State",
                capital: "Springfield",
                syllables: 3,
                shape: "🌾",
                character: "🏙️",
                neighbors: ["Wisconsin", "Indiana", "Kentucky", "Missouri", "Iowa"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 40.349457, longitude: -88.986137)
            ),
            StateCard(
                name: "Indiana",
                nickname: "Hoosier State",
                capital: "Indianapolis",
                syllables: 4,
                shape: "🏁",
                character: "🏀",
                neighbors: ["Michigan", "Ohio", "Kentucky", "Illinois"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 39.849426, longitude: -86.258278)
            ),
            StateCard(
                name: "Iowa",
                nickname: "Hawkeye State",
                capital: "Des Moines",
                syllables: 3,
                shape: "🌽",
                character: "🚜",
                neighbors: ["Minnesota", "Wisconsin", "Illinois", "Missouri", "Nebraska", "South Dakota"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 42.011539, longitude: -93.210526)
            ),
            StateCard(
                name: "Kansas",
                nickname: "Sunflower State",
                capital: "Topeka",
                syllables: 2,
                shape: "🌻",
                character: "🌪️",
                neighbors: ["Nebraska", "Missouri", "Oklahoma", "Colorado"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 38.526600, longitude: -96.726486)
            ),
            StateCard(
                name: "Kentucky",
                nickname: "Bluegrass State",
                capital: "Frankfort",
                syllables: 3,
                shape: "🐎",
                character: "🥃",
                neighbors: ["Illinois", "Indiana", "Ohio", "West Virginia", "Virginia", "Tennessee", "Missouri"],
                isCoastal: false,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 37.668140, longitude: -84.670067)
            ),
            StateCard(
                name: "Louisiana",
                nickname: "Pelican State",
                capital: "Baton Rouge",
                syllables: 4,
                shape: "🎷",
                character: "🦐",
                neighbors: ["Arkansas", "Mississippi", "Texas"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 31.169546, longitude: -91.867805)
            ),
            StateCard(
                name: "Maine",
                nickname: "Pine Tree State",
                capital: "Augusta",
                syllables: 1,
                shape: "🦞",
                character: "🌲",
                neighbors: ["New Hampshire"],
                isCoastal: true,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 44.693947, longitude: -69.381927)
            ),
            StateCard(
                name: "Maryland",
                nickname: "Old Line State",
                capital: "Annapolis",
                syllables: 3,
                shape: "🦀",
                character: "⚓",
                neighbors: ["Pennsylvania", "Delaware", "Virginia", "West Virginia"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 39.063946, longitude: -76.802101)
            ),
            StateCard(
                name: "Massachusetts",
                nickname: "Bay State",
                capital: "Boston",
                syllables: 4,
                shape: "🎓",
                character: "🦞",
                neighbors: ["Vermont", "New Hampshire", "Rhode Island", "Connecticut", "New York"],
                isCoastal: true,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 42.230171, longitude: -71.530106)
            ),
            StateCard(
                name: "Michigan",
                nickname: "Great Lakes State",
                capital: "Lansing",
                syllables: 3,
                shape: "🚗",
                character: "🏒",
                neighbors: ["Wisconsin", "Indiana", "Ohio"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 43.326618, longitude: -84.536095)
            ),
            StateCard(
                name: "Minnesota",
                nickname: "North Star State",
                capital: "Saint Paul",
                syllables: 4,
                shape: "❄️",
                character: "🏒",
                neighbors: ["North Dakota", "South Dakota", "Iowa", "Wisconsin"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 45.694454, longitude: -93.900192)
            ),
            StateCard(
                name: "Mississippi",
                nickname: "Magnolia State",
                capital: "Jackson",
                syllables: 4,
                shape: "🌸",
                character: "🎵",
                neighbors: ["Tennessee", "Alabama", "Louisiana", "Arkansas"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 32.741646, longitude: -89.678696)
            ),
            StateCard(
                name: "Missouri",
                nickname: "Show Me State",
                capital: "Jefferson City",
                syllables: 3,
                shape: "🎺",
                character: "🎸",
                neighbors: ["Iowa", "Illinois", "Kentucky", "Tennessee", "Arkansas", "Oklahoma", "Kansas", "Nebraska"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 38.456085, longitude: -92.288368)
            ),
            StateCard(
                name: "Montana",
                nickname: "Treasure State",
                capital: "Helena",
                syllables: 3,
                shape: "⛰️",
                character: "🦌",
                neighbors: ["North Dakota", "South Dakota", "Wyoming", "Idaho"],
                isCoastal: false,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 46.921925, longitude: -110.454353)
            ),
            StateCard(
                name: "Nebraska",
                nickname: "Cornhusker State",
                capital: "Lincoln",
                syllables: 3,
                shape: "🌽",
                character: "🚜",
                neighbors: ["South Dakota", "Iowa", "Missouri", "Kansas", "Colorado", "Wyoming"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 41.125370, longitude: -98.268082)
            ),
            StateCard(
                name: "Nevada",
                nickname: "Silver State",
                capital: "Carson City",
                syllables: 3,
                shape: "🎰",
                character: "🎲",
                neighbors: ["Oregon", "Idaho", "Utah", "Arizona", "California"],
                isCoastal: false,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 38.313515, longitude: -117.055374)
            ),
            StateCard(
                name: "New Hampshire",
                nickname: "Granite State",
                capital: "Concord",
                syllables: 3,
                shape: "🏔️",
                character: "🍁",
                neighbors: ["Vermont", "Maine", "Massachusetts"],
                isCoastal: true,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 43.452492, longitude: -71.563896)
            ),
            StateCard(
                name: "New Jersey",
                nickname: "Garden State",
                capital: "Trenton",
                syllables: 3,
                shape: "🏖️",
                character: "🍅",
                neighbors: ["New York", "Delaware", "Pennsylvania"],
                isCoastal: true,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 40.298904, longitude: -74.521011)
            ),
            StateCard(
                name: "New Mexico",
                nickname: "Land of Enchantment",
                capital: "Santa Fe",
                syllables: 4,
                shape: "🌶️",
                character: "🏜️",
                neighbors: ["Colorado", "Oklahoma", "Texas", "Arizona"],
                isCoastal: false,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 34.840515, longitude: -106.248482)
            ),
            StateCard(
                name: "New York",
                nickname: "Empire State",
                capital: "Albany",
                syllables: 2,
                shape: "🗽",
                character: "🍎",
                neighbors: ["Vermont", "Massachusetts", "Connecticut", "Pennsylvania", "New Jersey"],
                isCoastal: true,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 42.165726, longitude: -74.948051)
            ),
            StateCard(
                name: "North Carolina",
                nickname: "Tar Heel State",
                capital: "Raleigh",
                syllables: 5,
                shape: "🏔️",
                character: "🏀",
                neighbors: ["Virginia", "Tennessee", "Georgia", "South Carolina"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 35.630066, longitude: -79.806419)
            ),
            StateCard(
                name: "North Dakota",
                nickname: "Peace Garden State",
                capital: "Bismarck",
                syllables: 4,
                shape: "🌾",
                character: "🦬",
                neighbors: ["Montana", "South Dakota", "Minnesota"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 47.528912, longitude: -99.784012)
            ),
            StateCard(
                name: "Ohio",
                nickname: "Buckeye State",
                capital: "Columbus",
                syllables: 2,
                shape: "🌰",
                character: "🏈",
                neighbors: ["Michigan", "Pennsylvania", "West Virginia", "Kentucky", "Indiana"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 40.388783, longitude: -82.764915)
            ),
            StateCard(
                name: "Oklahoma",
                nickname: "Sooner State",
                capital: "Oklahoma City",
                syllables: 4,
                shape: "🌪️",
                character: "🤠",
                neighbors: ["Kansas", "Missouri", "Arkansas", "Texas", "New Mexico", "Colorado"],
                isCoastal: false,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 35.565342, longitude: -96.928917)
            ),
            StateCard(
                name: "Oregon",
                nickname: "Beaver State",
                capital: "Salem",
                syllables: 3,
                shape: "🌲",
                character: "🦫",
                neighbors: ["Washington", "Idaho", "Nevada", "California"],
                isCoastal: true,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 44.572021, longitude: -122.070938)
            ),
            StateCard(
                name: "Pennsylvania",
                nickname: "Keystone State",
                capital: "Harrisburg",
                syllables: 5,
                shape: "🔔",
                character: "🦌",
                neighbors: ["New York", "New Jersey", "Delaware", "Maryland", "West Virginia", "Ohio"],
                isCoastal: false,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 40.590752, longitude: -77.209755)
            ),
            StateCard(
                name: "Rhode Island",
                nickname: "Ocean State",
                capital: "Providence",
                syllables: 3,
                shape: "⚓",
                character: "⛵",
                neighbors: ["Massachusetts", "Connecticut"],
                isCoastal: true,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 41.680893, longitude: -71.511780)
            ),
            StateCard(
                name: "South Carolina",
                nickname: "Palmetto State",
                capital: "Columbia",
                syllables: 5,
                shape: "🌴",
                character: "🏖️",
                neighbors: ["North Carolina", "Georgia"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 33.856892, longitude: -80.945007)
            ),
            StateCard(
                name: "South Dakota",
                nickname: "Mount Rushmore State",
                capital: "Pierre",
                syllables: 4,
                shape: "🗿",
                character: "🦬",
                neighbors: ["North Dakota", "Minnesota", "Iowa", "Nebraska", "Wyoming", "Montana"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 44.299782, longitude: -99.438828)
            ),
            StateCard(
                name: "Tennessee",
                nickname: "Volunteer State",
                capital: "Nashville",
                syllables: 3,
                shape: "🎸",
                character: "🎵",
                neighbors: ["Kentucky", "Virginia", "North Carolina", "Georgia", "Alabama", "Mississippi", "Arkansas", "Missouri"],
                isCoastal: false,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 35.747845, longitude: -86.692345)
            ),
            StateCard(
                name: "Texas",
                nickname: "Lone Star State",
                capital: "Austin",
                syllables: 2,
                shape: "⭐",
                character: "🤠",
                neighbors: ["Oklahoma", "Arkansas", "Louisiana", "New Mexico"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 31.054487, longitude: -97.563461)
            ),
            StateCard(
                name: "Utah",
                nickname: "Beehive State",
                capital: "Salt Lake City",
                syllables: 2,
                shape: "🐝",
                character: "🏔️",
                neighbors: ["Idaho", "Wyoming", "Colorado", "Arizona", "Nevada"],
                isCoastal: false,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 40.150032, longitude: -111.862434)
            ),
            StateCard(
                name: "Vermont",
                nickname: "Green Mountain State",
                capital: "Montpelier",
                syllables: 2,
                shape: "🍁",
                character: "🏔️",
                neighbors: ["New Hampshire", "Massachusetts", "New York"],
                isCoastal: false,
                region: "Northeast",
                coordinates: CLLocationCoordinate2D(latitude: 44.045876, longitude: -72.710686)
            ),
            StateCard(
                name: "Virginia",
                nickname: "Old Dominion",
                capital: "Richmond",
                syllables: 3,
                shape: "🏛️",
                character: "🎖️",
                neighbors: ["Maryland", "West Virginia", "Kentucky", "Tennessee", "North Carolina"],
                isCoastal: true,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 37.769337, longitude: -78.169968)
            ),
            StateCard(
                name: "Washington",
                nickname: "Evergreen State",
                capital: "Olympia",
                syllables: 3,
                shape: "🌲",
                character: "☕",
                neighbors: ["Idaho", "Oregon"],
                isCoastal: true,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 47.400902, longitude: -121.490494)
            ),
            StateCard(
                name: "West Virginia",
                nickname: "Mountain State",
                capital: "Charleston",
                syllables: 4,
                shape: "⛰️",
                character: "🏔️",
                neighbors: ["Ohio", "Pennsylvania", "Maryland", "Virginia", "Kentucky"],
                isCoastal: false,
                region: "South",
                coordinates: CLLocationCoordinate2D(latitude: 38.491226, longitude: -80.954453)
            ),
            StateCard(
                name: "Wisconsin",
                nickname: "Badger State",
                capital: "Madison",
                syllables: 3,
                shape: "🧀",
                character: "🦡",
                neighbors: ["Minnesota", "Iowa", "Illinois", "Michigan"],
                isCoastal: false,
                region: "Midwest",
                coordinates: CLLocationCoordinate2D(latitude: 44.268543, longitude: -89.616508)
            ),
            StateCard(
                name: "Wyoming",
                nickname: "Equality State",
                capital: "Cheyenne",
                syllables: 3,
                shape: "🦬",
                character: "🏔️",
                neighbors: ["Montana", "South Dakota", "Nebraska", "Colorado", "Utah", "Idaho"],
                isCoastal: false,
                region: "West",
                coordinates: CLLocationCoordinate2D(latitude: 42.755966, longitude: -107.302490)
            )
        ]
    }
}
