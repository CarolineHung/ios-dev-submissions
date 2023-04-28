//
//  DogDetailsController.swift
//  Hung-Villa_FinalProject
//
//  Created by student on 4/20/23.
//

import UIKit

class DogDetailsController: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var lifeSpanLbl: UILabel!
    @IBOutlet weak var bredForLbl: UILabel!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var breedGroupLbl: UILabel!
    @IBOutlet weak var temparamentLbl: UILabel!
    @IBOutlet weak var factsBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    
    private var delegate: DogDetailsDelegate?
    private var dog: Dog?
    private var indexPath: IndexPath?
    private var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let d = dog else { return }

        setupImage(d.image.url)
        favBtn.addTarget(self, action: #selector(onFavClick), for: .touchUpInside)
        favBtn.setImage(UIImage(systemName: isFavorite ? "star.fill" : "star"), for: .normal)

        nameLbl.text = d.name
        weightLbl.text = d.weight.metric
        heightLbl.text = d.height.metric
        lifeSpanLbl.text = d.lifeSpan
        bredForLbl.text = d.bredFor
        originLbl.text = d.origin
        breedGroupLbl.text = d.breedGroup
        temparamentLbl.text = d.temperament
        
        weightLbl.isHidden = true
        heightLbl.isHidden = true
        lifeSpanLbl.isHidden = true
        bredForLbl.isHidden = true
        originLbl.isHidden = true
        breedGroupLbl.isHidden = true
        temparamentLbl.isHidden = true
    }
    
    @IBAction func factsBtn(_ sender: UIButton) {
        weightLbl.isHidden = false
        heightLbl.isHidden = false
        lifeSpanLbl.isHidden = false
        bredForLbl.isHidden = false
        originLbl.isHidden = false
        breedGroupLbl.isHidden = false
        temparamentLbl.isHidden = false
        self.factsBtn.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let d = dog, let i = indexPath {
            delegate?.onDogDetailsResult(id: d.id, isFavorite: isFavorite, indexPath: i)
        }
        super.viewWillDisappear(animated)
    }

    func setData(dog: Dog, isFavorite: Bool, indexPath: IndexPath) {
        self.dog = dog
        self.isFavorite = isFavorite
        self.indexPath = indexPath
    }
    
    func setDelegate(_ delegate: DogDetailsDelegate) {
        self.delegate = delegate
    }

    func setupImage(_ string: String) {
        guard let url = URL(string: string) else {
            print("Invalid URL")
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                print("Failed to load image data")
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("failed to create image from data")
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    @objc func onFavClick() {
        isFavorite = !isFavorite
        favBtn.setImage(UIImage(systemName: isFavorite ? "star.fill" : "star"), for: .normal)
    }
}
