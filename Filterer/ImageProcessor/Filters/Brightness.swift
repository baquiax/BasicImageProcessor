public class Brightness : Filter {
    private var percentage : Double = 0;
    
    public init (increaseFactor const: Double) {
        self.percentage = const;
    }
    
    func limitAndCastNumber(number:Double) -> UInt8 {
        return UInt8(max(0,min(number, 255)))
    }
    
    public func apply(image: RGBAImage) -> RGBAImage {
        var pixel : Pixel?
        let percentage : Double = 1.0 + self.percentage;
        for r in 0...image.height - 1 {
            for c in 0...image.width - 1 {
                pixel = image.pixels[ image.height * r + c ]
                pixel!.red = limitAndCastNumber((Double(pixel!.red) * percentage))
                pixel!.green = limitAndCastNumber((Double(pixel!.green) * percentage))
                pixel!.blue = limitAndCastNumber((Double(pixel!.blue) * percentage))                
                image.pixels[image.height * r + c] = pixel!;
            }
        }
        return image
    }
    
}