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
import INSPhotoGallery
import Firebase

class GalleryViewController:  UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var useCustomOverlay = false
    
    lazy var photos: [INSPhotoViewable] = {
        return [
            INSPhoto(image: UIImage(named: "001"), thumbnailImage: UIImage(named: "001")),
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "Gallery" as NSObject,
            AnalyticsParameterItemName: "Gallery" as NSObject,
            AnalyticsParameterContentType: "gallery" as NSObject
            ])
        
        self.navigationItem.title = "meteoLCD Gallery"
        for i in 2...45 {
            self.photos.append(INSPhoto(image: UIImage(named: String(format: "%03d", i)), thumbnailImage: UIImage(named: String(format: "%03d", i))))
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.populateWithPhoto(photos[(indexPath as NSIndexPath).row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        let currentPhoto = photos[(indexPath as NSIndexPath).row]
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
        
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? MainCollectionViewCell
            }
            return nil
        }
        present(galleryPreview, animated: true, completion: nil)
    }
}
