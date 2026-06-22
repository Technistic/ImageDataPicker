import ImageDataPicker
import SwiftData
import SwiftUI

struct ContentView: View {
    @State var imageData: Data? = UIImage(named: "Image")!.pngData()

    var body: some View {
        VStack {
            ImageDataPickerView(
                imageData: $imageData,
                clipShape: Circle()
            )
            .frame(width: 240, height: 240)
            .padding(32)
            Text("Image Data Picker")
                .font(.title)
            Spacer()
        }
    }
}
