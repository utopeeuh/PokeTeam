import Foundation
import UIKit
class FetchHelper : UIViewController{
    
    static let shared = FetchHelper()
    
    func getPokemonName(_ url: String) -> String{
        return getPokemon(url)?.name ?? "N/A"
    }
    
    private func getURL(_ id: String) -> String{
        return "https://pokeapi.co/api/v2/pokemon/\(id)/"
    }
    
    private func getPokemon(_ url: String) -> Pokemon? {
        var pokemon: Pokemon?

        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else{
                print("Something went wrong")
                return
            }

            // have data
            var result: Pokemon?
            do{
                try result = JSONDecoder().decode(Pokemon.self, from: data)
            }
            catch{
                print("failed to convert \(error.localizedDescription)")
            }
            guard let json = result else{
                return
            }

            // use data
            pokemon = json
            
        }).resume()
        
        return pokemon
    }
    
    func getAllPokemon() -> [Pokemon]{
        
        var pokemonList = [Pokemon]()
        var pokemons: PokemonList?
        let url = "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else{
                print("Something went wrong")
                return
            }

            // have data
            var result: PokemonList?
            do{
                try result = JSONDecoder().decode(PokemonList.self, from: data)
            }
            catch{
                print("failed to convert \(error.localizedDescription)")
            }
            guard let json = result else{
                return
            }

            // use data
            pokemons = json
            
        }).resume()
        
        for pokemon in pokemons!.results {
            pokemonList.append(getPokemon(pokemon.url)!)
        }
        
        return pokemonList
    }
    
    
}
