//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Mikhail on 26.07.2022.
//

import UIKit
import SDWebImage

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func refresh(characterRaM: RaMCharacter) {
        characterName.text = characterRaM.name
        if let url = URL(string: characterRaM.image) {
            characterImageView.sd_setImage(with: url)
        }
    }
}
