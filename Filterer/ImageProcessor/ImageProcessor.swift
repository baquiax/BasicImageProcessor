import Foundation
import UIKit

public enum Colors {
    case Red
    case Green
    case Blue    
}

public class ImageProcessor {
    private var image : RGBAImage?
    private static var  DefaultFilters : [String : Filter] = [
        "increase 50% of brightness": Brightness(increaseFactor: 0.5),
        "increase contrast by 2": Contrast(factor: 2),
        "gamma 1.5": Gamma(gamma: 1.5),
        "middle threshold": Threshold (minimumLevel: 127),
        "duplicate intensity of red": IncreaseIntensity(increaseFactor: 1, color: Colors.Red),
        "invert": Invert()
    ]
    
    public init (image : RGBAImage) {
        self.image = image;
    }

    func applyFilter(filter: Filter){
        self.image = filter.apply(self.image!)
    }
    
    public func applyFilter(filter filter: Filter) -> RGBAImage {
        applyFilter(filter)
        return self.image!
    }
    
    public func applyFilters(filters filters: Array<Filter>) -> RGBAImage {
        for index in 0...filters.count - 1 {
            self.applyFilter(filters[index])
        }
        return self.image!
    }
 
    public func applyDefaultFilter(name n : String) -> RGBAImage {
        let filter : Filter? = ImageProcessor.DefaultFilters[ n.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ]
        if (filter != nil) {
            print("Applying default filter: \(n)")
            self.applyFilter(filter!);
        }
        return self.image!
    }   
}