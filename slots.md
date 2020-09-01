# QObject

We can pass python objects to the qml layer. We do that by sub-classing the QObject.

Sample:

```python
class MyClass(QObject):
```

You see the `MyClass` class is sub-classing from the QObject, or inheriting from it. It is actually a requirement, if you want it passed on to the qml layer, and its quite simple and straightforward, just a two step thing.

The QObject is inside the PyQt5.QtCore package, so the import statement of the QObject is:

```python
from PyQt5.QtCore import QObject
```

then you can do:

```python
class MyClass(QObject)
```

this is the first step, the second step is to override the `__int__` method

```python
class MyClass(QObject):

    def __init__(self):
        QObject.__init__(self)
```

What we are actually doing is to call the `__init__` method of the parent class `QObject`, because the way a class is sub-classed, no method in it is called, so you have to call it, to do some initialization on its own. Well you are done. Passing an object like this to qml, is the norm, we always do it.

How do you pass to Qml

main.py

```python
my_obj = MyClass()
...
qml_layer.rootObjects()[0].setProperty('qml_object', my_obj)
```

main.qml

```qml
property QtObject qml_object: QtObject {}
```

Here, the type is a QtObject and we have initialized it with an empty QtObject, the name of course is qml_object



So using it with a base app code, we should have:

main.py

```python
import sys
from PyQt5.QtCore import QObject
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

class MyClass(QObject):

    def __init__(self):
        QObject.__init__(self)


app = QGuiApplication(sys.argv)

my_obj = MyClass()

qml_layer = QQmlApplicationEngine()
qml_layer.load('main.qml')
qml_layer.rootObjects()[0].setProperty('qml_object', my_obj)
qml_layer.quit.connect(app.quit)

sys.exit(app.exec_())
```

main.qml

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {

	property QtObject qml_object: QtObject {}

    visible: true
    width: 800
    height: 500
    title: "Qml 3"
}
```





Use it in a Text and call a `toString` method on it to see what its description is, almost everything in qml has a `toString` method

```qml
...
    title: "Qml 3"

    Text {
        text: qml_object.toString()
    }

}
```

Of course to see its description as a QObject(xxxxxxxx) is not why we went through the hassle to create an object, no we want to call python methods from qml: Calculate a number and return its solution, request a dataframe, send login info to be verified against a database, take a filename and use it as a new name to convert our mp3, the list goes on and on. Then lets go on to a factor of QObject, `slots`.

# Slots

Slots are how qml connects with python methods. These methods should be members of a class, because methods or functions in themselves cannot be passed into qml, but Objects can, so we create our methods as members of a class pass the object of the class to qml as a qml object, as we have done above, then call the methods from qml, its very straightforward and simple. So you subclass QObject and add your own methods, managed as slots.

So lets say a very small method as this:

main.py

```python
def say_hello_world():
    print('Hello World')
```

If we want to call it from qml, we have to make it a member of a class which sub-classes QObject.

main.py

```python

class Backend(QObject):
    def __init__(self):
        QObject.__init__(self)

    def say_hello_world(self):
        print('Hello World')
```

One more thing, it has to be managed by a pyqtSlot; not a big deal.

main.py

```python
class Backend(QObject):
    ...
    @pyqtSlot()
    def say_hello_world(self):
        print('Hello World')
```

We add a pyqtSlot decorator: `@pyqtSlot()`

So for our class, and a method `say_hello_world` we should have:

main.py

```python
class Backend(QObject):
    def __init__(self):
        QObject.__init__(self)

    @pyqtSlot()
    def say_hello_world(self):
        print('Hello World')
```

The import statement for a pyqtSlot is:

main.py

```python
from PyQt5.QtCore import pyqtSlot
```

So for our main.py module we should have:

main.py

```python
import sys
from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

class Backend(QObject):

    def __init__(self):
        QObject.__init__(self)

    @pyqtSlot()
    def say_hello_world(self):
        print('Hello World')


app = QGuiApplication(sys.argv)

backend = Backend()

qml_layer = QQmlApplicationEngine()
qml_layer.load('main.qml')
qml_layer.rootObjects()[0].setProperty('qml_object', backend)
qml_layer.quit.connect(app.quit)

sys.exit(app.exec_())

```

Lets call it in our qml.

main.qml

```qml

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {

	property QtObject qml_object: QtObject {}

    visible: true
    width: 800
    height: 500
    title: "Qml 3"

    Button {
    	text: "Click Me"

    	onClicked: {
    		qml_object.say_hello_world()
    	}

    }
}

```

Your UI ran and in your terminal you saw something like this:

```shell
>>> Hello World
```



Now lets pass in values from UI layer to qml

main.qml

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {

	property QtObject qml_object: QtObject {}

    visible: true
    width: 800
    height: 500
    title: "Qml 3"

    TextField {
    	id: email_field
    	placeholderText: "Email"
    }
    
    Button {
    	text: "Click me"

    	onClicked: {
    		qml_object.log_into_app(email_field.text)
    	}

    }
    
}

```

main.py

```python
@pyqtSlot(str)
    def log_into_app(self, email):
        if email:
            print('Authenticated')
```

It can be any number of values

```qml
...
Button {
    text: "Click me"

    onClicked: {
    	qml_object.log_into_app(fname_field.text, lname_field.text,
    	email_field.text, password_field.text)
    }

}
...
```

main.py

```python
@pyqtSlot(str, str, str, str)
    def log_into_app(self, fname, lname, email, password):
        if fname and lname and email and password:
            print('Authenticated')
```

You can pass in integers and floats

main.qml

```qml
...
Button {
    text: "Click me"

    onClicked: {
    	qml_object.log_into_app(47, 0.98)
    }

}
...
```

main.py

```python
@pyqtSlot(int, float)
    def log_into_app(self, age, grade):
        if age and grade:
            print('Authenticated')
```



You can also pass in lists

main.qml

```qml
...
Button {
    text: "Click me"

    onClicked: {
    	qml_object.log_into_app(['hotdog', 'salad'])
    }

}
...
```

main.py

```python
@pyqtSlot(list)
    def log_into_app(self, fav_foods):
            print('Authenticated' + fav_foods[0])
```

These are the only types you can pass in, strings (str), integers (int), floats (float), and lists (list). Any other type you want to pass from the UI layer to python will have to be converted to any of these four, preferably use strings, since its easier to convert from strings to any other type you want.



If you want to see python returning values to the UI, lets go on to returning values.



### Returning Values

In the pyqtSlot decorator add a `result` keyword argument

main.py

```python
...
@pyqtSlot(result=str)
...
```

The UI layer will be expecting a string as a return value.

Lets use it in a text.

main.qml

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {

	property QtObject qml_object: QtObject {}

    visible: true
    width: 800
    height: 500
    title: "Qml 3"

    Text {
    	text: qml_object.say_hello_world()

    }
}
```



Now return the "Hello World" that the UI is expecting

```python
import sys
from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

class Backend(QObject):

    def __init__(self):
        QObject.__init__(self)

    @pyqtSlot(result=str)
    def say_hello_world(self):
        return 'Hello World'


app = QGuiApplication(sys.argv)

backend = Backend()

qml_layer = QQmlApplicationEngine()
qml_layer.load('main.qml')
qml_layer.rootObjects()[0].setProperty('qml_object', backend)
qml_layer.quit.connect(app.quit)

sys.exit(app.exec_())
```

You should be seeing something like this

<img src="H:\GitHub\Python-gui-book\images\slots_result.jpg" alt="slots_result" style="zoom: 80%;" />

we can have a int, float, list

To-do



### Usage

main.py

```python
import sys
from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

class Backend(QObject):
    
    def __init__(self):
        QObject.___init__(self)


app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
engine.load('./main.qml')
engine.quit.connect(app.quit)
sys.exit(app.exec_())
```
backend.py

```python
from Py
```



engine.rootObjects()[0].setProperty('hello', 'World and beyound')
engine.quit.connect(app.quit)

##
property string hello: ""