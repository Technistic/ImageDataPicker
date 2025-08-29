# Employee Form Example

## Overview

The EmployeeFormExample application demonstrates how to build a multi-platform application that uses the ImageDataPicker framework. It presents a list of employees,
displaying their name, department and a photo. Selecting an employee from the list presents a detail view that allows this information to be edited, including
selecting an appropriate photo from using PhotosPicker.

![EmployeeFormExample](/employeeformexample/assets/images/EmployeeFormExample-Hero@1x.png)

## Architecture

The application uses a SwiftData Model to store the information for employees. The `Employee` model's `imageData` property is bound to an `ImageDataPickerView` that
allows a photo to be selected from the **PhotoLibrary**.

## Design

As this is a multi-platform application - it can be run on iOS, iPadOS and macOS - it uses a `NavigationSplitView` to present a list-detail interface.

## Credits

## Sample Images

The sample Iimages used in this project are from [unsplash.com](unsplash.com).

Photo by [Christian Buehner](https://unsplash.com/@christianbuehner?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

<img width="480" alt="MyImageList-Framework Added" src="https://images.unsplash.com/photo-1568602471122-7832951cc4c5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />

[Credit](https://unsplash.com/photos/mens-blue-and-white-button-up-collared-top-DItYlc26zVI?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

Photo by [Andrey Zvyagintsev](https://unsplash.com/@zvandrei?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

<img width="480" alt="MyImageList-Framework Added" src="https://images.unsplash.com/photo-1581403341630-a6e0b9d2d257?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)" />

[Credit](https://unsplash.com/photos/woman-in-black-long-sleeve-shirt-x0c6vTO5ibA?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

Photo by [Slav Romanov](https://unsplash.com/@slavromanov?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

<img width="480" alt="MyImageList-Framework Added" src="https://images.unsplash.com/photo-1525134479668-1bee5c7c6845?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />

[Credit](https://unsplash.com/photos/smiling-woman-sitting-on-grass-during-daytime-BrEAp01_m5w?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

Photo by [Jurica Koletić](https://unsplash.com/@juricakoletic?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

<img width="480" alt="MyImageList-Framework Added" src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" />

[Credit](https://unsplash.com/photos/man-wearing-henley-top-portrait-7YVZYZeITc8?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)
