# Employee Form Example

![EmployeeFormExample Hero](/assets/images/EmployeeFormExample-Hero.png)

## Overview

The **EmployeeFormExample** application demonstrates how to build a multiplatform application using the 
**ImageDataPicker** framework. It presents a list of employees, displaying their name, department and a
photo. Selecting an employee from the list presents a detail view that allows this information to be 
edited, including selecting a photo using the **PhotosPicker**.

## Architecture

The application uses a **SwiftData** [@Model](https://developer.apple.com/documentation/swiftdata/model()) 
to store the information for employees. The ``Employee`` model's ``imageData`` property is bound to an 
``ImageDataPickerView`` that allows a photo to be selected from the **PhotoLibrary**. The `detail:` 
``EmployeeView`` loads the selected ``Employee`` data into temporary variables. This allows the user
to either `save()` or `cancel()` their proposed changes.

![Architecture](EmployeeFormExample/EmployeeFormExample.docc/Resources/ImageDataPicker-Header@0.5x.png)

## Design

As this is a multiplatform application - it can be run on iOS, iPadOS and macOS - it uses a 
`NavigationSplitView` to present a list-detail interface. The `NavigationSplitView`
`List` is configured to use the `Edit()` button to `delete()` rows from the `List`. An `Add()` button adds 
a new row to the `List` with default values that can be modified in the ``EmployeeView``.

The segmented picker at the bottom of the ``EmployeeView`` allows you to see the effect of the ``clippedImageShape()`` view modifier on the ``ImageDataPickerView``.


## Credits

### Sample Images

The sample images used in this project are from [unsplash.com](https://unsplash.com).

Photo by [Christian Buehner](https://unsplash.com/@christianbuehner?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

![Christian Buehner Image](EmployeeFormExample/Assets.xcassets/Craig_Birch.imageset/christian-buehner-unsplash.png)

[Credit](https://unsplash.com/photos/mens-blue-and-white-button-up-collared-top-DItYlc26zVI?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

Photo by [Andrey Zvyagintsev](https://unsplash.com/@zvandrei?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

![Andrey Zvyagintsev Image](EmployeeFormExample/Assets.xcassets/Anne_Lee.imageset/andrey-zvyagintsev-unsplash.png)

[Credit](https://unsplash.com/photos/woman-in-black-long-sleeve-shirt-x0c6vTO5ibA?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

Photo by [Slav Romanov](https://unsplash.com/@slavromanov?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

![Slav Romanov Image](EmployeeFormExample/Assets.xcassets/Aleshia_Evans.imageset/slav-romanov-unsplash.png)

[Credit](https://unsplash.com/photos/smiling-woman-sitting-on-grass-during-daytime-BrEAp01_m5w?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

Photo by [Jurica Koletić](https://unsplash.com/@juricakoletic?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

![Jurica Koletić Image](EmployeeFormExample/Assets.xcassets/Peter_Jones.imageset/jurica-koletic-unsplash.png)

[Credit](https://unsplash.com/photos/man-wearing-henley-top-portrait-7YVZYZeITc8?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)
