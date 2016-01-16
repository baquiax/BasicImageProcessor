public protocol Filter {
    func apply(image: RGBAImage) -> RGBAImage ;
    func changeIntensity(newValue : Double);
    func getIntensity() -> Double;
}