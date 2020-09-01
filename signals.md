# Signals

In the case of a database.

So lets create a Signal.

First lets add the import statement

> main.py
>

```python
from PyQt5.QtCore import pyqtSignal
```

So in the import statements we may have
```python
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal
```

Now lets create the signal. You create the signal as a child of the QObject subclass

> main.py

```python
...
class Backend(QObject):
    ...
    def __init__(self):
        ...
    eventFinished = pyqtSignal(str, arguments=['my_caller'])
...
```

`eventFinished` is the name of the signal and the "my_caller" argument value is actually suppose to be the name of a method that will emit the signal to qml. So lets create the "my_caller" method

> main.py

```python
..
def my_caller(self):
    # do something if you like
    # then emit the signal
    self.eventFinished.emit('This could have been an empty string')
```

So the full python code may now look like this:

```python
import sys
from PyQt5.QtCore import QObject, pyqtSlot, pyqtSignal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

class Backend(QObject):

    def __init__(self):
        QObject.__init__(self)

    eventFinished = pyqtSignal(str, arguments=['my_caller'])

    @pyqtSlot(result=str)
    def say_hello_world(self):
        return 'Hello World'

    def my_caller(self):
        # do something if you like
        # then emit the signal
        self.eventFinished.emit('This could have been an empty string')

app = QGuiApplication(sys.argv)

backend = Backend()

qml_layer = QQmlApplicationEngine()
qml_layer.load('main.qml')
qml_layer.rootObjects()[0].setProperty('qml_object', backend)
qml_layer.quit.connect(app.quit)

sys.exit(app.exec_())
```



And in the main.qml a signal handler will have to be created to handle the signal. You can name a signal any name you want but, they signal handler must follow a convention, according to the name of the signal:

1. They first letter of the signal must be capitalized

2. There must be a prefix of "on"

   Eg. `eventFinished` becomes `onEventFinished` , `eventstart` becomes `onEventstart`, `event_resume` becomes `onEvent_resume`

So `eventFinished` is the signal and `onEventFinished` is the signal handler

Lets create the signal handler in Qml

> main.qml

```qml
...
ApplicationWindow {
	...

	Connections {
		target: qml_object
		function onEventFinished(return_value) {
			console.log(return_value) \\ outputs "This could have been an empty string"
		}
	}

}
```

So the full qml code may now look like this:

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

    Connections {
		target: qml_object
		function onEventFinished(return_value) {
			console.log(return_value) \\ outputs "This could have been an empty string"
		}
	}

}
```

The `my_caller` method is the one that emits the signal, it hasn't been called. And because we have not made it a slot, we can only call it in the python code itself. Lets call it in our say_hello_world method then.

```python
...
    @pyqtSlot(result=str)
    def say_hello_world(self):
        self.my_caller()
        return 'Hello World'
...
```

Now when it runs we can see our App runs, the UI runs and then in the console we see that in the console we also have:

```shell
>>> qml: This could have been an empty string
```

Our signal works well.

The basics of signal handling is done.