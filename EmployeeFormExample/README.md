# Employee Form Example

![EmployeeFormExample Hero](/assets/images/EmployeeFormExample-Hero.png)

## Overview

The **EmployeeFormExample** application demonstrates how to build a multiplatform application using the
**ImageDataPicker** framework. It presents a list of employees showing each person's name, department, and
photo. Selecting an employee from the list presents a detail view that allows this information to be
edited, including selecting a photo with **PhotosPicker**.

## Architecture

The application uses a **SwiftData** [@Model](https://developer.apple.com/documentation/swiftdata/model())
to store employee information. The ``Employee`` model's ``imageData`` property is bound to an
``ImageDataPickerView`` that allows a photo to be selected from the photo library. The detail
``EmployeeView`` loads the selected ``Employee`` data into temporary state variables so the user can
either save or cancel their proposed changes.

![Architecture](EmployeeFormExample/EmployeeFormExample.docc/Resources/ImageDataPicker-Header@0.5x.png)

## Design

As a multiplatform application that runs on iOS, iPadOS, and macOS, it uses a
`NavigationSplitView` to present a list-detail interface. The `List` supports deleting rows through the
standard edit flow, and an add button inserts a new employee with default values that can then be modified
in ``EmployeeView``.

The segmented picker at the bottom of the ``EmployeeView`` allows you to see the effect of the ``clipShape`` initializer parameter on the ``ImageDataPickerView``.


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


> Copyright &copy; 2025, 2026 Technistic Pty Ltd