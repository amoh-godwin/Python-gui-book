# Backend

The App Business Logic (ABL), call it whatever you want. This is where Qml meets Python code.

Qml connects to python by way of properties and registered types. Mostly we choose to connect by properties-it is easier that way. You'll see, you will love it.

But since there are lot we have to talk about when it comes to Objects, let start with the properties.



To keep a clean slate and to focus on the changes let have a basic app code.

> main.py
>

```python
import sys
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine


app = QGuiApplication(sys.argv)

qml_layer = QQmlApplicationEngine()
qml_layer.load('main.qml')
qml_layer.quit.connect(app.quit)

sys.exit(app.exec_())

```

> main.qml
>

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 800
    height: 500
    title: "Qml 3"
}

```

Nothing special just python calling qml to run a UI and then when the user exits, qml tells python the UI has exited. No connection yet. 

Now here is the connection:



> main.py
>

```python
...
my_string = "Hello World"
...
qml_layer.load('main.qml')
qml_layer.rootObjects()[0].setProperty('qml_string', my_string)
...

```

#### 

This code ```qml_layer.rootObjects()``` actually returns a list of the root objects in our qml layer. The only root object we have in our qml layer is `ApplicationWindow`, so we safely use the zero index "[0]", to refer to it, since its the one and only. `setProperty` is actually setting the property value since the property should already be declared inside your root object in qml. It takes the name of the property, as a string and then the value of the property.

From the code below, you can see that the property has been declared as:

```qml
property string qml_string: "" \\ good code
```

So the type is a string, and the name is 'qml_string', and the value has been initialized as empty (""). You should always initialize your properties if you are going to use them from python. So, for this case, the code below is bad.

```qml
property string qml_string \\ bad code for now
```



Now lets have a simple Text and make use of our `qml_string` property

> main.qml

```qml

...
ApplicationWindow {
	property string qml_string: ""
	....

	Text {
		text: qml_string
	}

}

```

Nothing much, just a simple Text with all the defaults, no alignment, nothing.

Now the two files should look like this:

> main.py

```python
import sys
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

my_string = "Hello World"

app = QGuiApplication(sys.argv)

qml_layer = QQmlApplicationEngine()
qml_layer.load('main.qml')
qml_layer.rootObjects()[0].setProperty('qml_string', my_string)
qml_layer.quit.connect(app.quit)

sys.exit(app.exec_())

```

> main.qml

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {

    property string qml_string: ""

    visible: true
    width: 800
    height: 500
    title: "Qml 3"

	Text {
		text: qml_string
	}

}

```

Now run this:

> command prompt or terminal

``` shell
>>> python main.py
```

You should have something this ( I am using Windows 10):

![string_prop](H:\GitHub\Python-gui-book\images\string_prop.jpg)

Now that we have understood how to pass string values from python to qml.

Now lets use the same method to pass different python types to their corresponding qml properties.

### For Int

> main.py

```python
...
my_int = 800
...
qml_layer.rootObjects()[0].setProperty('qml_int', my_int)
...
```

> main.qml

```qml

...
ApplicationWindow {
	property int qml_int: 32
	...

	Slider {
		from: 1
		value: qml_int
		to: 100
	}

}
```



### For list

> main.py

```python
...
my_list = ['Guido', 'Dennis', 'Tim']
...
qml_layer.rootObjects()[0].setProperty('qml_list', my_list)
...
```



> main.qml

```qml

...
ApplicationWindow {
	property var qml_list: 1
	...

	ComboBox {
	    model: qml_list
	}

}
```



### For dict

> main.py

```python
...
my_dict = {'email': "john_developer@gmail.com"}
...
qml_layer.rootObjects()[0].setProperty('qml_dict', my_dict)
...
```



> main.qml

```qml

...
ApplicationWindow {
	property var qml_dict: 1
	...

	Text {
	    text: qml_dict["email"]
	}

}
```

Other basic python types will have to be converted to these types before being passed on to the qml layer. To pass on data from JSON or say a database, or to even call python functions from your UI layer and to qml functions from python, we will have to move on to understand them. Lets go on to Slots and then to Signals.


