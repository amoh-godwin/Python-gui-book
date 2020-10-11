# FontLoader

The best way to use fonts apart from system fonts in your app is to load it via the FontLoader. It includes the fonts that are in your app's folder or online. It essentially loads the font via the URL, so any URL goes.







## Usage



### Import statement

```qml
import QtQuick 2.15
```



### Basic Usage



#### Usage 1

Via a relative local path

```qml
import QtQuick 2.15

ApplicationWindow {
	visible: true
	width: 800
	height: 500
	
	FontLoader {
		id: myfont
		source: "path/to/font.ttf" // or "./path/to/font.ttf"
	}
	
	Text {
		anchors.centerIn: parent
		text: "Beautiful Text"
		font.family: myfont.name
	}
	
}
```







#### Usage 2

Via a full local path

```qml
import QtQuick 2.15

ApplicationWindow {
	visible: true
	width: 800
	height: 500

	FontLoader {
		id: myFont
		source: "file:///C:/Users/username/fonts/myawesomefont.ttf"
	}
	
	Text {
		anchors.centerIn: parent
		text: "Beautiful Text"
		font.family: myFont.name
	}
	
}
```

Here we included the full path and even the file scheme `file://` and a leading forward slash `(/)`. If you do not want to include the file scheme include a leading forward slash `(/)`



**NB:**

*The following code will also work*

```qml
FontLoader {
	...
	source: "/C:/Users/username/fonts/myawesomefont.ttf" // good code
}
```



```qml
FontLoader {
	...
	source: "/home/myfonts/myawesomefont.ttf" // good code
}
```



*But this one won't*

```qml
FontLoader {
	...
	source: "C:/Users/username/fonts/myawesomefont.ttf" // bad code
}
```







#### Usage 3

Via an http link

```qml
import QtQuick 2.15

ApplicationWindow {
	visible: true
	width: 800
	height: 500

	FontLoader {id: myFont; source: "https://www.domain.com/myawesomefont.ttf"}
	
	Text {
		anchors.centerIn: parent
		text: "Beautiful Text"
		font.family: myFont.name
	}
	
}
```

