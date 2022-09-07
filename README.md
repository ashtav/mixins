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
| NUMBER & RANDOM
|----------------------------------------
*/

Mixins.doubleInRange(50, 100); // generate float number between 50 - 100
Mixins.intInRange(50, 100); // generate integer number between 50 - 100
Mixins.randNum(18); // generate random int value, max length is 18
Mixins.randString(10); // generate random string value

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

double size = MediaQuery.of(context).size.width; // width or height
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

Mixins.statusBar(); // transparent background of status bar
Mixins.showStatusBar(); // show status bar
Mixins.hideStatusBar(); // hide status bar

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
String date = Mixins.dateFormat(DateTime.now(), format: 'dd/MM/yyyy');

/*
|----------------------------------------
| OTHERS
|----------------------------------------
*/

Mixins.hex('#fff'); // white
Mixins.orientation([DeviceOrientation.landscapeLeft]);

Mixins.copy('<your token here>'); // copy text to clipboard

```