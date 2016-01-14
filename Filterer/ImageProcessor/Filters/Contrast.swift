import Foundation

public class Contrast : Filter {
    private var factor : Double = 0;
    
    public init (factor const: Double) {
        self.factor = (const == 0) ? 1 : const
    }
    
    func limitAndCastNumber(number:Double) -> UInt8 {
        return UInt8(max(0,min(number, 255)))
    }
    
    func calculateContrast (value: UInt8) -> UInt8 {
        return limitAndCastNumber((((( Double(value) / 255.0) - 0.5) * self.factor) + 0.5) * 255.0)
    }
    
    public func apply(image: RGBAImage) -> RGBAImage {
        var pixel : Pixel?
        for r in 0...image.height - 1 {
            for c in 0...image.width - 1 {
                pixel = image.pixels[ image.height * r + c ]
                pixel!.red = calculateContrast(pixel!.red)
                pixel!.green = calculateContrast(pixel!.green)
                pixel!.blue = calculateContrast(pixel!.blue)
                image.pixels[image.height * r + c] = pixel!;
            }
        }
        return image
    }
    
}