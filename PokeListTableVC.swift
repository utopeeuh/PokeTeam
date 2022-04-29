import UIKit
import Kingfisher

protocol PokemonSelectionDelegate {
    func didTapChoice()
}

class PokeListTableVC : UITableViewController{
    
    var pokemonSelectionDelegate: PokemonSelectionDelegate!
    
    var selectedParty : PartyModel? = nil
    
    private var pokemonList = [Pokemon]()

    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        pokemonList = FetchHelper.shared.getAllPokemon()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokeListCell = tableView.dequeueReusableCell(withIdentifier: "pokeListCellId") as! PokeListCell
        
        let pokemon = pokemonList[indexPath.row]
        let imageUrl = URL(string: pokemon.sprites.frontDefault)
        
        pokeListCell.pokemonImg.kf.setImage(with: imageUrl)
        pokeListCell.pokemonLbl.text = pokemon.name.capitalized
        pokeListCell.idLbl.text = { () -> String in
            var stringId = ""
            if(pokemon.id < 10){
                stringId = "00"
            }
            else if(pokemon.id < 100){
                stringId = "0"
            }
            stringId += String(describing: pokemon.id)
            return stringId
        }()
        pokeListCell.typeLbl.text  = { () -> String in
            var stringType = ""
            for i in 0..<pokemon.types.count {
                stringType += pokemon.types[i].type.name.capitalized
                if(pokemon.types.count > 1 && i == 0){
                    stringType += " / "
                }
            }
            return stringType
        }()
        
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
