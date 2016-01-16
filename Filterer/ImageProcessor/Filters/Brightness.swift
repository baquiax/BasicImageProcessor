public class Brightness : Filter {
    private var percentage : Double = 0;
    
    public init (increaseFactor const: Double) {
        self.percentage = const;
    }
    
    func limitAndCastNumber(number:Double) -> UInt8 {
        return UInt8(max(0,min(number, 255)))
    }
    
    public func apply(image: RGBAImage) -> RGBAImage {
        let percentage : Double = 1.0 + self.percentage;
        for r in 0...image.height - 1 {
            for c in 0...image.width - 1 {
                let index = r * image.width + c
                var pixel = image.pixels[index]
                pixel.red = limitAndCastNumber((Double(pixel.red) * percentage))
                pixel.green = limitAndCastNumber((Double(pixel.green) * percentage))
                pixel.blue = limitAndCastNumber((Double(pixel.blue) * percentage))
                image.pixels[index] = pixel;
            }
        }
        return image
    }
    
    public func changeIntensity(newValue: Double) {
        self.percentage = newValue;
    }
    
    public func getIntensity() -> Double {
        return self.percentage
    }
}