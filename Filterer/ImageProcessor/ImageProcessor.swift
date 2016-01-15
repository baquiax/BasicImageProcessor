import Foundation
import UIKit

public enum Colors {
    case Red
    case Green
    case Blue    
}

public class ImageProcessor {
    private static var  DefaultFilters : [String : Filter] = [
        "increase 50% of brightness": Brightness(increaseFactor: 0.5),
        "increase contrast by 2": Contrast(factor: 2),
        "gamma 1.5": Gamma(gamma: 1.5),
        "middle threshold": Threshold (minimumLevel: 127),
        "duplicate intensity of red": IncreaseIntensity(increaseFactor: 1, color: Colors.Red),
        "invert": Invert()
    ]
    
    public static func applyFilter(filter: Filter, image: RGBAImage) -> RGBAImage {
        return filter.apply(image)
    }
    
    public static func applyFilters(filters filters: Array<Filter>, var image : RGBAImage) -> RGBAImage {
        for index in 0...filters.count - 1 {
            image = ImageProcessor.applyFilter(filters[index], image: image)
        }
        return image
    }
 
    public static func applyDefaultFilter(name n : String, var image: RGBAImage) -> RGBAImage {
        let filter : Filter? = ImageProcessor.DefaultFilters[ n.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ]
        if (filter != nil) {
            print("Applying default filter: \(n)")
            image = ImageProcessor.applyFilter(filter!, image: image);
        }
        return image
    }
}