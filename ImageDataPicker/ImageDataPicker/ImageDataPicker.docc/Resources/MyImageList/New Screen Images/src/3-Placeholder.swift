import ImageDataPicker
import SwiftData
import SwiftUI

struct ContentView: View {
    @State var imageData: Data? = UIImage(named: "Image")!.pngData()
    
    var body: some View {
        VStack {
            ImageDataPickerView(imageData: $imageData,
                                emptyImage: "photo.fill",
                                errorImage: "exclamationmark.circle.fill")
        }
    }
}
