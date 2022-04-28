import UIKit
import CoreData

protocol PokemonSelectionDelegate {
    func didTapChoice()
}

class PokeListTableVC : UITableViewController{
    
    var pokemonSelectionDelegate: PokemonSelectionDelegate!
    
    var selectedParty : PartyModel? = nil
    
    private var pokemonList = [Pokemon]()

    override func viewDidLoad() {
        pokemonList = FetchHelper.shared.getAllPokemon()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokeListCell = tableView.dequeueReusableCell(withIdentifier: "pokeListCellId") as! PokeListCell
        
        pokeListCell.pokemonLbl.text = pokemonList[indexPath.row].name.capitalized
        
        return pokeListCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //detect row select
        print(indexPath.row)
        DatabaseHelper.shared.addPokemonToParty(selectedParty!.id, indexPath.row+1 as NSNumber)
        pokemonSelectionDelegate.didTapChoice()
        navigationController?.popViewController(animated: true)
    }
}
