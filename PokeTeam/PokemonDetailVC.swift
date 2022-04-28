import UIKit
import Kingfisher

class PokemonDetailVC : UIViewController{
    
    var pokemonUrl: String? = nil
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var baseView: UIView!
    private var selP: Pokemon? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var species: UILabel!
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var atk: UILabel!
    @IBOutlet weak var def: UILabel!
    @IBOutlet weak var spatk: UILabel!
    @IBOutlet weak var spdef: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var eff200: UILabel!
    @IBOutlet weak var eff100: UILabel!
    @IBOutlet weak var eff50: UILabel!
    @IBOutlet weak var eff25: UILabel!
    
    override func viewDidLoad() {
        
        
        
        // lock horizontal scrolling
        scrollViewDidScroll(scrollView: scrollView)
        
        // get pokemon
        selP = FetchHelper.shared.getPokemon(pokemonUrl!)
        
        title = selP!.name.capitalized
        
        // set background color
        
        imageView.kf.setImage(with: URL(string: selP!.sprites.frontDefault))
        
        UIView.animate(withDuration: 10) {
            self.imageView.image!.getColors { colors in
                
                let bgColor = { () -> UIColor in
                    if ((colors?.background.isLight()) == true){
                        return (colors?.background)!
                    }
                    else{
                        return (colors?.primary)!
                    }
                }()
                
                self.view.backgroundColor = bgColor
                self.baseView.backgroundColor = bgColor
            }
        }
        
        // SET STATS
        
        var maxStat: String = ""
        var maxStatInt : Int = 0
        for i in 0..<6 {
            if maxStatInt < (selP?.stats[i].baseStat)!{
                maxStatInt = (selP?.stats[i].baseStat)!
                maxStat = (selP?.stats[i].stat.name)!
            }
        }
        
        species.text = maxStat.capitalized
        type.text = { () -> String in
            var stringType = ""
            for i in 0..<(selP?.types.count)! {
                stringType += (selP?.types[i].type.name.capitalized)!
                if((selP?.types.count)! > 1 && i == 0){
                    stringType += " / "
                }
            }
            return stringType
        }()
        hp.text = "\(selP?.stats[0].baseStat ?? 0)"
        atk.text = "\(selP?.stats[1].baseStat ?? 0)"
        def.text = "\(selP?.stats[2].baseStat ?? 0)"
        spatk.text = "\(selP?.stats[3].baseStat ?? 0)"
        spdef.text = "\(selP?.stats[4].baseStat ?? 0)"
        speed.text = "\(selP?.stats[5].baseStat ?? 0)"
        total.text = { () -> String in
            var total = 0;
            for i in 0..<6 {
                total += (selP?.stats[i].baseStat)!
            }
            return String(describing:total)
        }()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
}
