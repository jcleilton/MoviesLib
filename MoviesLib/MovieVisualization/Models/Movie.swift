//
//  Movie.swift
//  MoviesLib
//
//  Created by Eric Alves Brito on 28/08/20.
//  Copyright © 2020 DevBoost. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    
    let title: String?
    let categories: String?
    let duration: String?
    let rating: Double?
    let summary: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case title, categories, duration, rating, image
        case summary = "description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        title = try? container?.decodeIfPresent(String.self, forKey: .title) ?? "Nenhum título"
        categories = try? container?.decodeIfPresent(String.self, forKey: .categories)
        duration = try? container?.decodeIfPresent(String.self, forKey: .duration)
        rating = try? container?.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        image = try? container?.decodeIfPresent(String.self, forKey: .image) ?? "placeholder"
        summary = try? container?.decodeIfPresent(String.self, forKey: .summary)
    }
    
}
