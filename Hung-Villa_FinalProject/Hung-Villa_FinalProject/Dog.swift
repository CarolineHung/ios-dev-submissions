struct Dog: Codable {
    let id: String
    let name: String
    let weight: Measurement
    let height: Measurement
    let lifeSpan: String
    let bredFor: String?
    let origin: String?
    let breedGroup: String?
    let temperament: String
    let image: Image
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case weight
        case height
        case lifeSpan = "life_span"
        case bredFor = "bred_for"
        case origin
        case breedGroup = "breed_group"
        case temperament
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = String(try container.decode(Int.self, forKey: .id))
        name = try container.decode(String.self, forKey: .name)
        weight = try container.decode(Measurement.self, forKey: .weight)
        height = try container.decode(Measurement.self, forKey: .height)
        lifeSpan = try container.decode(String.self, forKey: .lifeSpan)
        bredFor = try container.decodeIfPresent(String.self, forKey: .bredFor)
        origin = try container.decodeIfPresent(String.self, forKey: .origin)
        breedGroup = try container.decodeIfPresent(String.self, forKey: .breedGroup)
        temperament = try container.decode(String.self, forKey: .temperament)
        image = try container.decode(Image.self, forKey: .image)
    }
}

struct Measurement: Codable {
    let metric: String
    let imperial: String
}

struct Image: Codable {
    let url: String
}
