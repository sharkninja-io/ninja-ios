//
//  UIImage+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 9/7/22.
//

import UIKit

extension UIImage {
    
    func tint(color: UIColor) -> UIImage {
        let imageView = UIImageView(image: self.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = color
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage!
        }; return self
    }
        
    public func original() -> UIImage {
        let imageview = UIImageView(image: self.withRenderingMode(.alwaysOriginal))
        imageview.contentMode = .scaleAspectFit
        return imageview.image ?? self
    }
    
    func resize(width: CGFloat, height: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: .default())
        .image { context in
            self.draw(in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        }
    }
    
    func resize(multiplier: CGFloat) -> UIImage {
        return resize(width: self.size.width * multiplier, height: self.size.width * multiplier)
    }
    
    static func fromLinearGradient(size: CGSize, colors: [CGColor], points: [CGFloat], horizontal: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        guard let gradient = CGGradient(
                colorSpace: CGColorSpaceCreateDeviceRGB(),
                colorComponents: colors.flatMap { $0.components ?? [] },
                locations: points,
                count: colors.count)
        else { return nil }

        context.drawLinearGradient(gradient,
                                   start: .zero,
                                   end: horizontal ? CGPoint(x: size.width, y: 0) : CGPoint(x: 0, y: size.height),
                                   options: CGGradientDrawingOptions())
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        defer { UIGraphicsEndImageContext() }
        return UIImage(cgImage: image)
    }
}

fileprivate let UIImageCache = NSCache<NSString, UIImage>()

extension UIImage {
    
    convenience init?(namedCache: String) {
        let cacheKey = NSString(string: namedCache)
        if let cachedImage = UIImageCache.object(forKey: cacheKey),
            let cgImage = cachedImage.cgImage {
            self.init(cgImage: cgImage)
            return
        }
        
        self.init(named: namedCache)
        UIImageCache.setObject(self, forKey: cacheKey)
    }
    
    convenience init(url: URL) async throws {
        let cacheKey = NSString(string: url.description)
        if let cachedImage = UIImageCache.object(forKey: cacheKey),
            let cgImage = cachedImage.cgImage {
            self.init(cgImage: cgImage)
            return
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        self.init(data: data)!
        UIImageCache.setObject(self, forKey: cacheKey)
    }
}
