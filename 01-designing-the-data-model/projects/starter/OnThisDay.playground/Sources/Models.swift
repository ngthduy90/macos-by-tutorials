import Foundation

public enum EventType: String {
    case events = "Events"
    case births = "Births"
    case deaths = "Deaths"
}

public struct DaySample: Decodable {
    public let date: String
    public let info: String
    public let data: [String: [Event]]
    
    public var events: [Event] { data[EventType.events.rawValue] ?? [] }
    public var births: [Event] { data[EventType.births.rawValue] ?? [] }
    public var deaths: [Event] { data[EventType.deaths.rawValue] ?? [] }
    
    public var displayDate: String {
        date.replacingOccurrences(of: "_", with: " ")
    }
}

public struct Event: Decodable {
    public let text: String
    // 1
    public let links: [EventLink]
    
    // 2
    enum CodingKeys: String, CodingKey {
        case text
        case links
    }
    
    // 3
    public init(from decoder: Decoder) throws {
        // 4
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // 5
        text = try values.decode(String.self, forKey: .text)
        // 6
        let allLinks = try values.decode([String: [String: String]].self, forKey: .links)
        
        // 7
        var processedLinks: [EventLink] = []
        for (_, link) in allLinks {
            if let title = link["2"], let address = link["1"], let url = URL(string: address) {
                processedLinks.append(EventLink(title: title, url: url))
            }
        }
        
        // 8
        links = processedLinks
    }
}

public struct EventLink: Decodable {
    public let title: String
    public let url: URL
}
