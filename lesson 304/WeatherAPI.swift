//
//  WeatherAPI.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import Foundation

enum Request: String {
    case currentWeather = "/current.json"
    case forecast = "/forecast.json"
    case searchOrAutocomplete = "/search.json"
    case history = "/history.json"
    case marine = "/marine.json"
    case future = "/future.json"
    case timeZone = "/timezone.json"
    case sports = "/sports.json"
    case astronomy = "/astronomy.json"
    case ipLookup = "/ip.json"
}

struct Location: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case region = "region"
        case country = "country"
        case lat = "lat"
        case lon = "lon"
        case tzId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime = "localtime"
    }
    
    let lat: Double
    let lon: Double
    let name: String
    let region: String
    let country: String
    let tzId: String?
    let localtimeEpoch: Int?
    let localtime: String?
    
    static func ==(left: Location, right: Location) -> Bool {
        left.name == right.name
        && left.country == right.country
        && left.region == right.region
    }
    
    static func getLocations(for data: Any) -> [Location] {
        guard let locationsData = data as? [[String: Any]] else { return [] }
        return locationsData.compactMap { Location($0) }
    }
}

extension Location {
    init?(_ locationData: [String: Any]) {
        guard let lat = locationData["lat"] as? Double,
              let lon = locationData["lon"] as? Double,
              let name = locationData["name"] as? String,
              let region = locationData["region"] as? String,
              let country = locationData["country"] as? String
        else {
            return nil
        }
        
        self.lat = lat
        self.lon = lon
        self.name = name
        self.region = region
        self.country = country
        self.tzId = locationData["tzId"] as? String
        self.localtimeEpoch = locationData["localtime_epoch"] as? Int
        self.localtime = locationData["localtime"] as? String
    }
}

struct WeatherAlerts: Decodable {
    let headline: String
    let msgType: String
    let severity: String
    let urgency: String
    let areas: String
    let category: String
    let certainty: String
    let event: String
    let note: String
    let effective: String
    let expires: String
    let desc: String
    let instruction: String
}

struct AirQualityData: Decodable {
    let co: Double
    let o3: Double
    let no2: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let usEpaIndex: Int
    let gbDefraIndex: Int

    enum CodingKeys: String, CodingKey {
        case co = "co"
        case o3 = "o3"
        case no2 = "no2"
        case so2 = "so2"
        case pm2_5 = "pm2_5"
        case pm10 = "pm10"
        case usEpaIndex = "us_epa_index"
        case gbDefraIndex = "gb_defra_index"
    }
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}

struct Current: Decodable {
    let lastUpdated: String
    let lastUpdatedEpoch: Int
    let tempC: Double
    let tempF: Double
    let feelslikeC: Double
    let feelslikeF: Double
    let condition: Condition
    let windMph: Double
    let windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMb: Double
    let pressureIn: Double
    let precipMm: Double
    let precipIn: Double
    let humidity: Int
    let cloud: Int
    let isDay: Int
    let uv: Double
    let gustMph: Double
    let gustKph: Double
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case lastUpdatedEpoch = "last_updated_epoch"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case condition = "condition"
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity = "humidity"
        case cloud = "cloud"
        case isDay = "is_day"
        case uv = "uv"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }
}

struct DayElement: Decodable {
    let maxtempC: Double
    let maxtempF: Double
    let mintempC: Double
    let mintempF: Double
    let avgtempC: Double
    let avgtempF: Double
    let maxwindMph: Double
    let maxwindKph: Double
    let totalprecipMm: Double
    let totalprecipIn: Double
    let avgvisKm: Double?
    let avgvisMiles: Double?
    let avghumidity: Int?
    let condition: Condition?
    let uv: Double?
    
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case totalprecipIn = "totalprecip_in"
        case avgvisKm = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case avghumidity = "avghumidity"
        case condition = "condition"
        case uv = "uv"
    }
}

struct AstroElement: Decodable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moonPhase: String
    let moonIllumination: String
    
    enum CodingKeys: String, CodingKey {
        case sunrise = "sunrise"
        case sunset = "sunset"
        case moonrise = "moonrise"
        case moonset = "moonset"
        case moonPhase = "moon_phase"
        case moonIllumination = "moon_illumination"
    }
}

struct TidesElement: Decodable {
    let tideTime: String
    let tideHeightMt: Double
    let tideType: Double
    
    enum CodingKeys: String, CodingKey {
        case tideTime = "tide_time"
        case tideHeightMt = "tide_height_mt"
        case tideType = "tide_type"
    }
}

struct HourElement: Decodable {
    let timeEpoch: Int
    let time: String
    let tempC: Double
    let tempF: Double
    let condition: Condition
    let windMph: Double
    let windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMb: Double
    let pressureIn: Double
    let precipMm: Double
    let precipIn: Double
    let humidity: Int
    let cloud: Int
    let feelslikeC: Double
    let feelslikeF: Double
    let windchillC: Double
    let windchillF: Double
    let heatindexC: Double
    let heatindexF: Double
    let dewpointC: Double
    let dewpointF: Double
    let willItRain: Int
    let willItSnow: Int
    let isDay: Int
    let visKm: Double
    let visMiles: Double
    let chanceOfRain: Int
    let chanceOfSnow: Int
    let gustMph: Double
    let gustKph: Double
    let uv: Double
    
    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time = "time"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition = "condition"
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity = "humidity"
        case cloud = "cloud"
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case willItRain = "will_it_rain"
        case willItSnow = "will_it_snow"
        case isDay = "is_day"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case chanceOfRain = "chance_of_rain"
        case chanceOfSnow = "chance_of_snow"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
        case uv = "uv"
    }
}

struct Forecastday: Decodable {
    let date: String
    let dateEpoch: Int
    let day: DayElement
    let astro: AstroElement
    let tides: TidesElement?
    let hour: [HourElement]
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case dateEpoch = "date_epoch"
        case day = "day"
        case astro = "astro"
        case tides = "tides"
        case hour = "hour"
    }
}

struct Forecast: Decodable {
    let forecastday: [Forecastday]
}

struct SportEvent: Decodable {
    let stadium: String
    let country: Int
    let region: String
    let tournament: String
    let start: String
    let match: String
}

struct RealtimeAPI: Decodable, Equatable {
    let location: Location
    let current : Current
    
    static func == (lhs: RealtimeAPI, rhs: RealtimeAPI) -> Bool {
        lhs.location == rhs.location
    }
}

struct ForecastAPI: Decodable, Equatable {
    let location: Location
    let forecast: Forecast
    
    static func == (lhs: ForecastAPI, rhs: ForecastAPI) -> Bool {
        lhs.location == rhs.location
    }
}

struct HistoryAPI {
    //?
}

struct MarineWeatherAPI: Decodable, Equatable {
    let location: Location
    let forecast: Forecast
    
    static func == (lhs: MarineWeatherAPI, rhs: MarineWeatherAPI) -> Bool {
        lhs.location == rhs.location
    }
}

struct FutureWeatherAPI: Decodable, Equatable {
    let location: Location
    let forecast: Forecast
    
    static func == (lhs: FutureWeatherAPI, rhs: FutureWeatherAPI) -> Bool {
        lhs.location == rhs.location
    }
}

typealias SearchAutocompleteAPI = [Location]

struct IPLookupAPI: Decodable, Equatable {
    //?
}

struct AstronomyAPI: Decodable, Equatable{
    let location: Location
    let astro: AstroElement
    
    static func == (lhs: AstronomyAPI, rhs: AstronomyAPI) -> Bool {
        lhs.location == rhs.location
    }
}

struct TimeZoneAPI: Decodable, Equatable {
    let location: Location
    
    static func == (lhs: TimeZoneAPI, rhs: TimeZoneAPI) -> Bool {
        lhs.location == rhs.location
    }
}

struct SportsAPI: Decodable {
    let football: [SportEvent]
    let cricket: [SportEvent]
    let golf: [SportEvent]
}

//class Properties {
//    static let shared = Progress()
//
//    private let key = "4b17f00db3804d03965140234233108"
//    private let baseURL = "http://api.weatherapi.com/v1"
//    let langName = [
//        "Arabic": "ar",
//        "Bengali": "bn",
//        "Bulgarian": "bg",
//        "Chinese Simplified": "zh",
//        "Chinese Traditional": "zh_tw",
//        "Czech": "cs",
//        "Danish": "da",
//        "Dutch": "nl",
//        "Finnish": "fi",
//        "French": "fr",
//        "German": "de",
//        "Greek": "el",
//        "Hindi": "hi",
//        "Hungarian": "hu",
//        "Italian": "it",
//        "Japanese": "ja",
//        "Javanese": "jv",
//        "Korean": "ko",
//        "Mandarin": "zh_cmn",
//        "Marathi": "mr",
//        "Polish": "pl",
//        "Portuguese": "pt",
//        "Punjabi": "pa",
//        "Romanian": "ro",
//        "Russian": "ru",
//        "Serbian": "sr",
//        "Sinhalese": "si",
//        "Slovak": "sk",
//        "Spanish": "es",
//        "Swedish": "sv",
//        "Tamil": "ta",
//        "Telugu": "te",
//        "Turkish": "tr",
//        "Ukrainian": "uk",
//        "Urdu": "ur",
//        "Vietnamese": "vi",
//        "Wu (Shanghainese)": "zh_wuu",
//        "Xiang": "zh_hsn",
//        "Yue (Cantonese)": "zh_yue",
//        "Zulu": "zu"
//    ]
//
//    func getURL() {
//
//    }
//
//
//    private init() {}
//}

protocol SubscribersDelegate: AnyObject {
    func informAboutChange()
    func informAboutAppend()
    func informAboutRemove()
}

final class WeatherData {
    
    private class Subscribers {
        
        private struct Subscriber {
            weak var subscriber: SubscribersDelegate?
        }
        
        static var shared = Subscribers()
        
        private var counter = 0
        
        private var subscribers: [ObjectIdentifier: Subscriber] = [:]
        
        private init() {}
        
        func isSubscribed(_ delegate: SubscribersDelegate) -> Bool {
            guard let a = subscribers[ObjectIdentifier(delegate)] else { return false }
            guard a.subscriber == nil else { return true }
            subscribers[ObjectIdentifier(delegate)] = nil
            return false
        }

        func createWeakLink(for delegate: SubscribersDelegate) {
            if isSubscribed(delegate) { return }
            subscribers[ObjectIdentifier(delegate)] = Subscriber(subscriber: delegate)
            updateSubscribers()
        }
        
        func informAboutAdd() {
            subscribers.forEach { (_, subscription) in
                guard let delegate = subscription.subscriber else { return }
                delegate.informAboutAppend()
            }
        }
        
        func informAboutRemove() {
            subscribers.forEach { (_, subscription) in
                guard let delegate = subscription.subscriber else { return }
                delegate.informAboutRemove()
            }
        }
        
        func updateSubscribers() {
            guard counter > 100 else { return }
            let n = Int(log(Double(counter + 1)))
            var m = 0
            for _ in 0..<n {
                 m += subscribers.randomElement()?.value.subscriber != nil ? 1 : 0
            }
            guard n > 2 * m else { return }
            subscribers.forEach { (id, subscription) in
                if subscription.subscriber == nil {
                    subscribers[id] = nil
                }
            }
            counter = subscribers.count
        }
    }
    
    static let shared = WeatherData()
    
    private var locations: [Location] = []
    
    private init() {}

    func subscribe(_ newSubscriber: SubscribersDelegate, to requests: Set<Request>) {
        Subscribers.shared.createWeakLink(for: newSubscriber)
    }
    
    func count(for delegate: SubscribersDelegate) -> Int? {
        Subscribers.shared.isSubscribed(delegate) ? WeatherData.shared.locations.count : nil
    }
    
    func add(for delegate: SubscribersDelegate, location: Location) {
        guard Subscribers.shared.isSubscribed(delegate) else { return }
        if WeatherData.shared.locations.contains(where: { $0 == location }) { return }
        WeatherData.shared.locations.append(location)
        Subscribers.shared.informAboutAdd()
    }
    
    func remove(for delegate: SubscribersDelegate, at index: Int) {
        guard Subscribers.shared.isSubscribed(delegate) else { return }
        guard 0 <= index && index < WeatherData.shared.locations.count else { return }
        WeatherData.shared.locations.remove(at: index)
        Subscribers.shared.informAboutRemove()
    }
    
    subscript(delegate: SubscribersDelegate, index: Int) -> Location? {
        guard Subscribers.shared.isSubscribed(delegate) else { return nil }
        guard 0 <= index && index < WeatherData.shared.locations.count else { return nil }
        return WeatherData.shared.locations[index]
    }
}
