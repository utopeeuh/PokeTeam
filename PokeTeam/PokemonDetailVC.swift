import UIKit

class PokemonDetailVC : UIViewController{
    
    var pokemonUrl: String? = nil
    private var selectedPokemon: Pokemon? = nil
    
    @IBOutlet weak var pokeImage: UIImageView!
    
    override func viewDidLoad() {
        // get pokemon
        selectedPokemon = FetchHelper.shared.getPokemon(pokemonUrl!)
        title = selectedPokemon!.name.capitalized
        let imageUrl = URL(string: (selectedPokemon?.sprites.frontDefault)!)
        pokeImage.load(url: imageUrl!)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
