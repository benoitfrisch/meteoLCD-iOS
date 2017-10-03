/**
 * This file is part of meteoLCD.
 *
 * Copyright (c) 2017 Benoît FRISCH
 *
 * meteoLCD is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * meteoLCD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with meteoLCD If not, see <http://www.gnu.org/licenses/>.
 */

import UIKit
import SwiftPhotoGallery

class GalleryViewController:  UICollectionViewController {
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "meteoLCD Gallery"
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 45
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCollectionViewCell
        cell.imageView.image = UIImage(named: String(format: "%03d", indexPath.item+1))
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        index = indexPath.item
        
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor(red: 0.0, green: 0.66, blue: 0.875, alpha: 1.0)
        gallery.hidePageControl = false
        gallery.modalPresentationStyle = .fullScreen
        
        present(gallery, animated: true, completion: nil)
    }
    
}


// MARK: SwiftPhotoGalleryDataSource Methods
extension GalleryViewController: SwiftPhotoGalleryDataSource {
    
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return 45
    }
    
    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return UIImage(named: String(format: "%03d", forIndex+1))
    }
}


// MARK: SwiftPhotoGalleryDelegate Methods
extension GalleryViewController: SwiftPhotoGalleryDelegate {
    
    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        self.index = gallery.currentPage
        dismiss(animated: true, completion: nil)
    }
}
