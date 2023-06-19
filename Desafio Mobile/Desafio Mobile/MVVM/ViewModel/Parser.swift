//
//  Parser.swift
//  Desafio Mobile
//
//  Created by Arthur on 17/06/2023.
//  Copyright © 2023 Arthur. All rights reserved.
//

import Foundation

struct Parser {
    func parse(comp: @escaping ([Resource]) -> ()) {
        let api = URL(string: "http://portal.greenmilesoftware.com/get_resources_since")
        
        URLSession.shared.dataTask(with: api!) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([WelcomeElement].self, from: data!)
                
                let resources = result.map { $0.resource } // Mapear os recursos
                
                comp(resources) // Chamar o bloco de conclusão com o array de recursos
            } catch {
                print(error)
            }
            }.resume()
    }
}

