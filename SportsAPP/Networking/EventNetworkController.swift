
import Foundation
struct EventNetworkController : Codable {
	let events : [Events]?

	enum CodingKeys: String, CodingKey {

		case events = "events"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		events = try values.decodeIfPresent([Events].self, forKey: .events)
	}

}

struct sportsController : Decodable {
    let sports : [Sports]?

    enum CodingKeys: String, CodingKey {

        case sports = "sports"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sports = try values.decodeIfPresent([Sports].self, forKey: .sports)
    }

}

struct teamsController : Codable {
    let teams : [Teams]?

    enum CodingKeys: String, CodingKey {

        case teams = "teams"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        teams = try values.decodeIfPresent([Teams].self, forKey: .teams)
    }

}

struct LeagueRoot: Codable{
    let countrys : [Leagues]?

    enum CodingKeys: String, CodingKey {

        case countrys = "countrys"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        countrys = try values.decodeIfPresent([Leagues].self, forKey: .countrys)
    }

}

struct contriesController : Codable {
    let countries : [Countries]?

    enum CodingKeys: String, CodingKey {

        case countries = "countries"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        countries = try values.decodeIfPresent([Countries].self, forKey: .countries)
    }
}
