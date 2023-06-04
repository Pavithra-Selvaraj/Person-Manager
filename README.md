# Person Manager App

The Person Manager App is a simple Flutter application that allows users to manage a list of people using SQLite as the database. It provides features to add, view, edit, and delete person records.

## Features

- **Add Person**: Users can add a new person to the list by providing their first name, last name, gender, date of birth and profile photo.
- **View Person**: Users can view the details of an individual person, including their first name, last name, gender, date of birth and profile photo.
- **Edit Person**: Users can edit the details of an existing person, allowing them to update the first name, last name, gender, date of birth and profile photo.
- **Delete Person**: Users can remove a person from the list, permanently deleting their record.

## Installation

1. Clone the repository
```bash
git clone https://github.com/Pavithra-Selvaraj/Person-Manager.git
```

2. Navigate to the project directory
```bash
cd person-manager
```

3. Install the dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## Dependencies

The Person Manager App relies on the following dependencies:

- [`sqflite`](https://pub.dev/packages/sqflite) - SQLite database plugin for Flutter. 
- [`path_provider`](https://pub.dev/packages/path_provider) - Plugin for accessing commonly used locations on the file system. 
- [`intl`](https://pub.dev/packages/intl) - Internationalization and localization support for Flutter. 
- [`provider`](https://pub.dev/packages/provider) - State management library for Flutter.
- [`image_picker`](https://pub.dev/packages/image_picker) - Flutter plugin for selecting images from the gallery or camera.

For detailed information about the dependencies, please refer to the `pubspec.yaml` file.

## License

This project is licensed under the [MIT License](LICENSE). Feel free to modify and use the code according to your needs.

## Contact

If you have any questions or inquiries, please contact Pavithra Selvaraj at pavithraselvaraj2510@gmail.com.