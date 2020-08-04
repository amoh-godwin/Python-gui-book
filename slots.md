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



So using it with our base app code, we should have:

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

Of course to see its description as a QObject(xxxxxxxx) is not why we went through the hassle to create an object, no we want to call python methods from qml. Calculate a number and return its solution, request a dataframe, send login info to be verified against a database, take a filename and use it as a new name to convert our mp3, the list goes on and on.

# Slots

Slots are how qml connects with python methods. These methods should be class methods, QObject class methods. That is how Qml will be able to identify the method. So you subclass QObject and add your own methods. There are a few more.

### Import statement
#### python
from PyQt5.QtCore import pyqSlot

#### qml
Nothing

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