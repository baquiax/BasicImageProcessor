//This is an extra Filter, it does not receive parameters.

public class Invert : Filter {
        
    public init () {
    }
    
    func newValue(currentValue: Int) -> UInt8 {
        return UInt8(255 - currentValue) 
    }
    
    public func apply(image: RGBAImage) -> RGBAImage {
        var pixel : Pixel?
        for r in 0...image.height - 1 {
            for c in 0...image.width - 1 {
                pixel = image.pixels[ image.height * r + c ]
                pixel!.red = newValue(Int(pixel!.red))
                pixel!.green = newValue(Int(pixel!.green))
                pixel!.blue = newValue(Int(pixel!.blue))                
                image.pixels[image.height * r + c] = pixel!;
            }
        }
        return image
    }
}