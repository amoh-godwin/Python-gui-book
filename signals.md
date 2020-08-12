# Signals

In the case of a database.

So lets create a Signal

main.py

```python
from PyQt5.QtCore import pyqtSignal
```

main.py

```python
...
def __init__(self):
	...
myFirstSignal = pyqtSignal(str, arguments=['my_caller'])
```



