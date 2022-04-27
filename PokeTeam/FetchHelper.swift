import Foundation
import UIKit
class FetchHelper : UIViewController{
    
    static let shared = FetchHelper()
    
    func getPokemonName(_ url: String) -> String{
        return getPokemon(url)?.name ?? "N/A"
    }
    
    func getPokemon(_ url: String) -> Pokemon? {
        var result: Pokemon?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else{
                print("Something went wrong")
                return
            }

            do{
                try result = JSONDecoder().decode(Pokemon.self, from: data)
                semaphore.signal()
            }
            catch{
                print(String(describing: error))
            }
            guard let json = result else{
                return
            }
        })
        
        task.resume()
        
        semaphore.wait()
        return result
    }
    
    func getAllPokemon() -> [Pokemon]{
        
        var pokemonList = [Pokemon]()
        var result: PokemonList?
        let semaphore = DispatchSemaphore(value: 0)
        let url = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else{
                print("Something went wrong")
                return
            }

            // have data
            do{
                try result = JSONDecoder().decode(PokemonList.self, from: data)
                semaphore.signal()
            }
            catch{
                print(String(describing: error))
            }
            guard let json = result else{
                return
            }
        })
        
        task.resume()
        semaphore.wait()
        
        for pokemon in result!.results {
            pokemonList.append(self.getPokemon(pokemon.url)!)
        }
        
        return pokemonList
    }
    
    
}
