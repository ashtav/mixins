## Usage

It's not a great package, just help us to code briefly, everyone can make their own easily.
To use this plugin, add `mixins` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

### Example

```dart 

// without Mixins

Container(
    margin: EdgeInsets.all(15),
    padding: EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white)),
        borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Container(
                padding: EdgeInsets.all(15),
                child: Text('Hello!', textAlign: TextAlign.center)
            ),

            Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(Icons.search)
            )
        ]
    )
)

// with Mixins

Container(
    margin: Ei.all(15),
    padding: Ei.sym(v: 15),
    decoration: BoxDecoration(
        border: Br.only(['t'], color: Colors.white),
        borderRadius: Br.radius(5)
    ),
    child: Column(
        crossAxisAlignment: Caa.start,
        mainAxisAlignment: Maa.center,
        children: [
            Textr('Hello!', textAlign: Ta.center, padding: Ei.all(15)),
            Iconr(Icons.search, margin: Ei.only(r: 15))
        ]
    )
)

```

### Helpers
Some functions you can use to simplify and shorten your code.

##### Context

```dart 
context.height // get height of screen
context.width // get width of screen
context.padding // EdgeInsets
context.viewPadding // EdgeInsets
context.focus(FocusNode()) // set or unset focus
```

##### Number

```dart 
[50, 100].numInRange(double) // generate float number between 50 - 100
[50, 100].numInRange(int) // generate integer number between 50 - 100

Mixins.randNum(18); // generate random int value, max length is 18
Mixins.randString(10); // generate random string value

1500.idr() // convert to IDR currency, Rp1.500
// Another example '2.500'.idr() -> Rp2.500, 3500.15.idr() -> Rp3.500,15

'45'.isNumeric // true
344.isNumeric // true

99025.formatBytes() // 96.7 KB
```

##### List or Array

```dart 
['a', 'b', '4', 'e', '1'].getRandom() // ['e']

/* ----------------------------------------
| Grouping List<Map>
-------------------------------- */

List<Map> data = [{'date': '2022-01-01', 'name': 'John'}, {'date': '2022-01-01', 'name': 'Jane'}]
List<Map> group = data.groupBy('date')
// result: [{'2022-01-01': [{'date': '2022-01-01', 'name': 'John'}, {'date': '2022-01-01', 'name': 'Jane'}]}]
```

##### String

```dart 

'john doe'.ucwords // John Doe
'lipsum99'.getNumberOnly // 99
'john doe'.firstChar() // JD
'lorem ipsum dolor'.removeStringBefore('ipsum'); // ipsum dolor
'lorem ipsum dolor'.removeStringAfter('ipsum'); // lorem ipsum
'lorem ipsum dolor'.removeStringBetween('lorem','ipsum'); // lorem dolor
'lorem ipsum dolor'.getStringBetween('lorem','ipsum'); // ipsum
'<h1>Hello World</h1>'.removeHtmlTag; // Hello World
'{}'.isJson; // true

Lipsum.createWord(15) // generate dummy text
```

##### Map

```dart 

Map<String, TextEditingController> forms = {'name': TextEditingController()}
Map<String, dynamic> data = forms.toMap(manipulate: (map) {
    return map.numberOnly(['price', 'stock']).ucwords(['name']);
});

/* ----------------------------------------
| Map, TextEditingController & FocusNode
-------------------------------- */

Map<String, TextEditingController> forms = Forms.create(['name', {'stock': 1}]) // Only String and Map are allowed
Map<String, FocusNode> nodes = Forms.createNodes(['name', 'stock'])
```

##### Scroll

```dart 

/* ----------------------------------------
| Scroll to Widget
-------------------------------- */

ListView(
    controller: yourScrollController,
    children: [
        YourWidget(
            key: yourGlobalKey
        )
    ]
)

double size = context.width; // width or height
Mixins.scrollToWidget(yourGlobalKey, yourScrollController, size);

/* ----------------------------------------
| Scroll to TOP or BOTTOM
-------------------------------- */

Mixins.scrollTo(scroll, to: AxisDirection.up);

/* ----------------------------------------
| Max & Min Scroll
-------------------------------- */

List max = [10, 50]; // [top, bottom]
double max = 50; // top and bottom

bool hasMax = Mixins.scrollHasMax(scrollController, max);

// For example:
void yourScrollListener() {
    double pixel = scrollController.position.pixels;

    if (Mixins.scrollHasMax(scrollController, [20, 50])) {
        scrollController.animateTo(
            pixel,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInBack
        );
    }
}
```

##### Status Bar

```dart 

Mixins.statusBar(true); // Show or hide status bar
Mixins.setSystemUI(navBarColor: Colors.white); // Change status bar or navigation bar color
```

##### Images, Files

```dart 

// Convert base64 to file
File file = Mixins.base64ToFile('<your base64 string>');

// Convert base64 to image
File file = Mixins.base64ToImage('<your base64 string>');

// Convert image to file
Mixins.imageToFile('images/item.png')

// Convert image url to file
Mixins.urlToFile('<your image url>')

// Convert File to Base64
Mixins.fileToBase64(file);

// Convert Uint8List to File
File file = await [].toFile();

// Convert Base64 to File
File file = await '<base64-string>'.base64ToFile();

// Convert Base64 to Image
Image file = await '<base64-string>'.base64ToImage();

// Convert asset image to File
File file = await 'images/avatar.png'.imageToFile(); // from assets

// Convert network image to File
File file = await '<image-url>'.urlToFile();
```

##### Date & Time

```dart 

String date = Mixins.msToDateTime(1625386377499, format: 'D, d F Y h:i:s'); // Saturday, 20 March 2021
DateTime.now().format('dd/MM/yyyy') // Date format

DateTime.now().weekOfMonth // Get number of week in month
DateTime.now().weekOfYear // Get number of week in year
```

##### Others

```dart 

Mixins.hex('fff'); // White
Mixins.orientation([DeviceOrientation.landscapeLeft]); // Change device orientation
Mixins.copy('<content>'); // Copy text to clipboard

String? text;
text.isNull // true, instead of text == null

String? name;
name.orIf('-', [null, '']) // It's mean if name is null or empty, then return '-'

logg('lorem ipsum', color: 'r', limit: 1500); // Print in debug console
```

### Widgets
Some widgets you can use to simplify and shorten your code.

```dart 
// 1. Wrapper
// set unfocus on tap outside of TextField
Wrapper(child: Scaffold())

// 2. BounceScroll
ListView(physics: BounceScroll())

// 3. CenterDialog
showDialog(context: context, builder: (_) => CenterDialog(child: child))

// 4. Intrinsic
// Shortcut of `IntrinsicHeight` widget
Intrinsic(children: List.generate(3, (i) => Expanded(child: child)))

// 5. Skeleton
Skeleton(size: 15); // width and height is 15
Skeleton(size: [50, 15]); // width is 50, height is 15
Skeleton(size: [[15, 50], 15]); // width is (min: 15, max: 50), height is 15
Skeleton(size: [[15, 50], [5, 15]]); // width is (min: 15, max: 50), height is (min: 5, max: 15)

// 6. None
// Shortcut of `SizedBox.shrink()`
Container(child: const None())

// 7. Touch
// Short hand to use GestureDetector with translucent behavior
Touch(onTap: () {}, child: child)

// 8. InkW
// Custom widget of `InkWell`
InkW(onTap: (){}, child: child)

// 9. Textr & Iconr
// It's combination between Text or Icon and Container

```