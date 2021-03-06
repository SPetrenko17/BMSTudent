import Foundation
import MapKit
import RealmSwift

typealias MySchedule = [String: [MyScheduleElement]]

class MyScheduleElement: Codable {
    let lat: Double
    let location: Location
    let lon: Double
    let time: String
    let title: Title
    
    init(lat: Double, location: Location, lon: Double, time: String, title: Title) {
        self.lat = lat
        self.location = location
        self.lon = lon
        self.time = time
        self.title = title
    }
}

enum Location: String, Codable {
    case gz = "GZ"
}

enum Title: String, Codable {
    case инжграф = "Инжграф"
    case история = "История"
    case линал = "Линал"
    case матан = "Матан"
    case практикум = "Практикум"
    case программирование = "Программирование"
    case свобода = "Свобода"
    case физика = "Физика"
}

extension MyScheduleElement {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MyScheduleElement.self, from: data)
        self.init(lat: me.lat, location: me.location, lon: me.lon, time: me.time, title: me.title)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        lat: Double? = nil,
        location: Location? = nil,
        lon: Double? = nil,
        time: String? = nil,
        title: Title? = nil
        ) -> MyScheduleElement {
        return MyScheduleElement(
            lat: lat ?? self.lat,
            location: location ?? self.location,
            lon: lon ?? self.lon,
            time: time ?? self.time,
            title: title ?? self.title
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    func getTimeInMillis()->Int{
        let h = Int(self.time.split(separator: ":")[0])
        let m = Int(self.time.split(separator: ":")[1])
        return Int(h!*3600 + m!*60)
    }
}

extension Dictionary where Key == String, Value == [MyScheduleElement] {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MySchedule.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
    
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

class groupDatabase: Object {
    @objc dynamic var yourGroup: String = "ИУ5-25"
}
