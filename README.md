## Usage

It's not a great package, just help us to code briefly, everyone can make their own easily.
To use this plugin, add `mixins` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

```dart 

// without Mixins

Column(
    mainAxisAlignment: MainAxisAlignment.center
    children: []
)

Container(
    margin: EdgeInsets.all(15),
    padding: EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white)),
        borderRadius: BorderRadius.all(Radius.circular(5)),
    )
)

// with Mixins

Column(
    mainAxisAlignment: Maa.center 
    children: []
)

Container(
    margin: Ei.all(15),
    padding: Ei.sym(v: 15),
    decoration: BoxDecoration(
        border: Br.only(['t'], color: Colors.white),
        borderRadius: Br.radius(5)
    )
)

```

### Helpers

```dart 

// use method on helper mixins with Mixins.helper_name, eg:

Mixins.hex('#fff'); // white
Mixins.orientation([DeviceOrientation.landscapeLeft]);

```