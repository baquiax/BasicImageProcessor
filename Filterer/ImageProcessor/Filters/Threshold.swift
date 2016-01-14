public class Threshold : Filter {
    var minimumLevel : Int
    
    public init (minimumLevel value : Int) {
        self.minimumLevel = max(0,min(value,255));
    }
    
    func newValue(currentValue: Int) -> UInt8 {
        if (currentValue > minimumLevel) {
            return UInt8(255)
        } else {
            return UInt8(0  )
        }
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