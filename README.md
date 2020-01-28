# snapclip_pageview

Awesome PageView that provides flexible and customizable Widget for Flutter.
A pageview library for building foreground and background UI.
Clipping background for pageview.

## Getting Started


Very easily usable and customizable library. 
Colors and curves can be customised.

![snap clip sample](https://github.com/manojeeva/snapclip_pageview_flutter/blob/master/example/sample.gif)


How to use.


goto pubspec.yaml file add
```
  snapclip_pageview : 0.0.1
```

import inside your project.
```
import 'package:snapclip_pageview/snapclip_pageview.dart';
```

Inside Scaffold Use the widget.
```
 Scaffold(
      backgroundColor: Colors.blue,
      body: SnapClipPageView(
        backgroundBuilder: buildBackground,
        itemBuilder: buildChild,
        length: movieList.length,
      ),
    );
```
Item Builder is used for foreground.
```
    PageViewItem(
      key: Key(index.toString()),
      child:   Text(
            movie.title,
            style: Theme.of(context).textTheme.headline,
          ),
      height: 405,
      index: index,
    );
```
Using Background Builder.
```
    BackgroundWidget(
      key: Key(index.toString()),
      child: Image.network(movie.url, fit: BoxFit.fill),
      index: index,
    );
```

 ## Full Example.
```
class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  var movieList = <Movie>[];

  @override
  void initState() {
    movieList.addAll([
      Movie(
        "https://www.movieposters4u.com/images/b/BladeRunner2049Final.jpg",
        "Blade Runner",
      ),
      Movie(
        "https://images-na.ssl-images-amazon.com/images/I/51%2Bzb74v-TL.jpg",
        "Star Wars",
      ),
      Movie(
        "https://d13ezvd6yrslxm.cloudfront.net/wp/wp-content/images/EJWDEpFXsAMm9gJ.jpg",
        "6 Underground",
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SnapClipPageView(
        backgroundBuilder: buildBackground,
        itemBuilder: buildChild,
        length: movieList.length,
      ),
    );
  }

  BackgroundWidget buildBackground(_, index) {
    final movie = movieList[index];
    return BackgroundWidget(
      key: Key(index.toString()),
      child: Image.network(movie.url, fit: BoxFit.fill),
      index: index,
    );
  }

  PageViewItem buildChild(_, int index) {
    final movie = movieList[index];
    return PageViewItem(
      key: Key(index.toString()),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              movie.url,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            movie.title,
            style: Theme.of(context).textTheme.headline,
          )
        ],
      ),
      height: 405,
      index: index,
    );
  }
}
```
 