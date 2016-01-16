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
        for r in 0...image.height - 1 {
            for c in 0...image.width - 1 {
                let index = r * image.width + c
                var pixel = image.pixels[index]
                pixel.red = newValue(Int(pixel.red))
                pixel.green = newValue(Int(pixel.green))
                pixel.blue = newValue(Int(pixel.blue))
                image.pixels[index] = pixel;
            }
        }
        return image
    }
    
    public func changeIntensity(newValue: Double) {
        self.minimumLevel = Int(newValue)
    }

    public func getIntensity() -> Double {
        return Double(self.minimumLevel)
    }
}