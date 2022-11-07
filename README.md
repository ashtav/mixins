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

/*
|----------------------------------------
| CONTEXT
|----------------------------------------
*/

context.height // get height of screen
context.width // get width of screen
context.padding // EdgeInsets
context.viewPadding // EdgeInsets
context.focus(FocusNode()) // set or unset focus

/*
|----------------------------------------
| NUMBER & RANDOM
|----------------------------------------
*/

[50, 100].numInRange(double) // generate float number between 50 - 100
[50, 100].numInRange(int) // generate integer number between 50 - 100

Mixins.randNum(18); // generate random int value, max length is 18
Mixins.randString(10); // generate random string value

/*
|----------------------------------------
| LIST
|----------------------------------------
*/

['a', 'b', '4', 'e', '1'].getRandom() // ['e']
[10, 50].numInRange() // 30.5

[{'date': '2022-01-01', 'name': 'John'}, {'date': '2022-01-01', 'name': 'Jane'}].groupBy('date')
// result: [{'2022-01-01': [{'date': '2022-01-01', 'name': 'John'}, {'date': '2022-01-01', 'name': 'Jane'}]}]

/*
|----------------------------------------
| STRING
|----------------------------------------
*/

'john doe'.ucwords // John Doe
'lipsum99'.getNumberOnly // 99
'john doe'.firstChar() // JD
'lorem ipsum dolor'.removeStringBefore('ipsum'); // ipsum dolor
'lorem ipsum dolor'.removeStringAfter('ipsum'); // lorem ipsum
'lorem ipsum dolor'.removeStringBetween('lorem','ipsum'); // lorem dolor
'lorem ipsum dolor'.getStringBetween('lorem','ipsum'); // ipsum
'<h1>Hello World</h1>'.removeHtmlTag; // Hello World
'{}'.isJson; // true

/*
|----------------------------------------
| SCROLL TO WIDGET
|----------------------------------------
*/

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

// scroll to TOP OR BOTTOM
Mixins.scrollTo(scroll, to: AxisDirection.up);

/*
|----------------------------------------
| MAX & MIN SCROLL
|----------------------------------------
*/

List max = [10, 50]; // [top, bottom]
double max = 50; // top and bottom

bool hasMax = Mixins.scrollHasMax(scrollController, max);

// for example:
void yourScrollListener() {
    double pixel = scrollController.position.pixels;

    if (Mixins.scrollHasMax(scrollController, [20, 50])) {
        scrollController.animateTo(pixel, duration: const Duration(milliseconds: 250), curve: Curves.easeInBack);
    }
}

/*
|----------------------------------------
| STATUS BAR
|----------------------------------------
*/

Mixins.statusBar(true); // show or hide status bar
Mixins.setSystemUI(navBarColor: Colors.white); // change status bar or navigation bar color

/*
|----------------------------------------
| IMAGES
|----------------------------------------
*/

// convert base64 to file
File file = Mixins.base64ToFile('<your base64 string>');

// convert base64 to image
File file = Mixins.base64ToImage('<your base64 string>');

// convert image to file
Mixins.imageToFile('images/item.png')

// convert image url to file
Mixins.urlToFile('<your image url>')

// convert file to base64
Mixins.fileToBase64(file);

/*
|----------------------------------------
| DATE & TIME
|----------------------------------------
*/

String date = Mixins.msToDateTime(1625386377499, format: 'D, d F Y h:i:s'); // Saturday, 20 March 2021
DateTime.now().format('dd/MM/yyyy')

DateTime.now().weekOfMonth // get number of week in month
DateTime.now().weekOfYear // get number of week in year

/*
|----------------------------------------
| OTHERS
|----------------------------------------
*/

Mixins.hex('fff'); // white
Mixins.orientation([DeviceOrientation.landscapeLeft]);

Mixins.copy('<your token here>'); // copy text to clipboard

1500.idr() // convert to IDR currency, Rp1.500
// Another example '2.500'.idr() -> Rp2.500, 3500.15.idr() -> Rp3.500,15

'45'.isNumeric // true
344.isNumeric // true

String? text;
text.isNull // true, instead of text == null

99025.formatBytes() // 96.7 KB

```