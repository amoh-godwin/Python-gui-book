# Mastering Layouts in QML

![A collage of user interfaces on different screens, including a phone, tablet, and TV, showing various layouts](https://via.placeholder.com/600x200.png/2d2d2d/ffffff?text=Complex+UIs,+Simplified+with+Layouts)

Layouts are one of the most fundamental concepts in designing any Graphical User Interface (GUI). An effective layout system is the backbone of a responsive and well-structured application, ensuring that your UI components are organized, aligned, and adapt gracefully to different screen sizes and content changes.

In QML, the layout system provides a powerful yet intuitive way to manage the position and size of items. While you can manually place every item using x and y coordinates, this becomes unmanageable quickly. Layouts automate this process.

### Layouts vs. Views

It's important to distinguish between layouts and views.

* **Layouts** are containers used to arrange a known, fixed number of child items. They are dynamic in the sense that they can adjust to window resizing, but they are not designed to handle a large, variable number of items from a data source.
* **Views** (like `ListView` or `GridView`) are specifically designed to display data from a model. They create and recycle items as needed to efficiently display large, dynamic datasets.

Layouts are for arranging the static structure of your interface (panels, toolbars, buttons), while Views are for displaying its dynamic content (contact lists, photo galleries). This tutorial focuses on **Layouts**.

QML provides four primary layout types: `ColumnLayout`, `RowLayout`, `GridLayout`, and `StackLayout`. By combining them, you can build virtually any user interface you can imagine.

## Importing Layouts

To use any of the layout types in a QML file, you must first import the appropriate module. For modern Qt 6 applications, the import is straightforward:

```qml
import QtQuick
import QtQuick.Layouts
```

For older Qt 5 versions, you needed to match the minor version of the import to your `QtQuick` version (e.g., `import QtQuick.Layouts 1.15` for `QtQuick 2.15`). It is always best practice to consult the Qt documentation for the specific version you are using to ensure compatibility.

A minimal application window ready for layouts would look like this:

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Layouts Tutorial"
}
```

We will add our layout examples inside this `ApplicationWindow`.

## Core Layout Concepts

Before diving into specific layout types, let's cover the core concepts that apply to all of them.

### Sizing Items in a Layout

The layout system is designed to manage the size and position of its children. If you try to manually set an item's size using a property binding that refers to its parent (the layout), QML will produce a runtime warning because the layout's calculations will override your binding.

```qml
RowLayout {
    width: parent.width
    height: parent.height

    Rectangle {
        // WARNING: This will be overridden by the layout manager.
        width: parent.width 
        color: "red"
    }
}
```

Instead of direct bindings, you should use the attached properties provided by the `Layout` type. These properties act as "hints" that tell the layout manager how you would *prefer* the item to be sized and aligned.

### Attached Properties

Attached properties are special properties that the `Layout` type makes available to all items placed inside a layout. They are the correct way to control an item's behavior within the layout.

* `Layout.fillWidth`: A boolean that, when `true`, tells the item to expand and fill all available width. If multiple items have `fillWidth: true`, the available space is distributed among them.
* `Layout.fillHeight`: A boolean that, when `true`, tells the item to expand and fill all available height.
* `Layout.preferredWidth`: Sets a preferred width for the item. The layout will try to honor this width but may shrink or grow it if necessary.
* `Layout.preferredHeight`: Sets a preferred height for the item.
* `Layout.minimumWidth` / `Layout.maximumWidth`: Constrains the item's width. The layout will not size the item smaller or larger than these values.
* `Layout.minimumHeight` / `Layout.maximumHeight`: Constrains the item's height.
* `Layout.alignment`: Aligns the item within its allocated space (the "cell"). For example, `Qt.AlignHCenter` to center it horizontally or `Qt.AlignVCenter` to center it vertically.

**Correct Way to Size an Item:**

```qml
RowLayout {
    width: parent.width

    Rectangle {
        // GOOD: Use attached properties to define items inside a layout.
        Layout.fillWidth: true
        Layout.preferredHeight: 100 
        color: "dodgerblue"
    }
}
```

### Spacing

Most layouts provide a `spacing` property (`columnSpacing` and `rowSpacing` for `GridLayout`) that adds a consistent gap between all child items. The default value is greater than 0, so if you want items to touch, set it explicitly to `0`.

---

## ColumnLayout

**`ColumnLayout`** arranges its child items into a single vertical column, placing one item on top of the other.

![Diagram showing three numbered boxes arranged vertically in a single column](https://via.placeholder.com/200x300.png/333333/ffffff?text=1%0A%0A2%0A%0A3)

### Basic Usage

`ColumnLayout` is perfect for creating sidebars, forms, or main content areas that stack content vertically.

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: "ColumnLayout Example"

    ColumnLayout {
        anchors.fill: parent // Make the layout fill the window
        spacing: 0 // No spacing between Rectangles

        Rectangle {
            Layout.fillWidth: true     // This will take full width.
            Layout.preferredHeight: 50 // It has a fixed height.
            color: "darkgrey"
        }
        Rectangle {
            Layout.fillWidth: true
            // It expands to take all remaining vertical space.
            Layout.fillHeight: true
            color: "dodgerblue"
        }
    }
}
```

---

## RowLayout

**`RowLayout`** arranges its child items into a single horizontal row, placing one next to the other.

![Diagram showing three numbered boxes arranged horizontally in a single row](https://via.placeholder.com/400x150.png/333333/ffffff?text=1%20%20%7C%20%202%20%20%7C%20%203)

### Basic Usage

`RowLayout` is ideal for creating toolbars, button groups, and horizontal navigation bars.

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 600
    height: 400
    title: "RowLayout Example"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            // A sidebar with a fixed preferred width
            Layout.preferredWidth: 150
            Layout.fillHeight: true
            color: "darkgrey"
        }
        Rectangle {
            // The main content area that fills the remaining space
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "dodgerblue"
        }
    }
}
```

---

## GridLayout

**`GridLayout`** arranges its items in a grid of rows and columns. You typically define the number of `columns`, and items will automatically flow into the next available cell. It is a powerful tool for arranging items in a structured, two-dimensional way, such as in forms or settings dialogs.

An item can be configured to occupy more than one row or column using the `Layout.rowSpan` and `Layout.columnSpan` attached properties.

![Diagram showing a 2x2 grid with four numbered boxes](https://via.placeholder.com/300x300.png/333333/ffffff?text=1%20%7C%202%0A--%2B--%0A3%20%7C%204)

### Basic Usage

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: "GridLayout Example"

    GridLayout {
        anchors.fill: parent
        anchors.margins: 8
        columns: 2 // This grid will have two columns
        rowSpacing: 8
        columnSpacing: 8

        // Item 1 (row 0, column 0)
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "dodgerblue"
        }
        // Item 2 (row 0, column 1)
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "indianred"
        }
        // Item 3 (row 1, column 0)
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "mediumseagreen"
        }
        // Item 4 (row 1, column 1)
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "goldenrod"
        }
    }
}
```

---

## StackLayout

**`StackLayout`** stacks its child items on top of one another, with only one item being visible at a time. This is perfect for creating tabbed interfaces, wizards, or views that can be switched on the fly.

The visible item is controlled by the `currentIndex` property.

### Basic Usage

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: "StackLayout Example"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Buttons to control the StackLayout's index
        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "Page 1";
                onClicked: viewStack.currentIndex = 0
            }
            Button {
                text: "Page 2";
                onClicked: viewStack.currentIndex = 1
            }
        }

        StackLayout {
            id: viewStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0 // Show the first item

            Rectangle {
                color: "lightblue"
                Text {
                    anchors.centerIn: parent;
                    text: "This is the first page"
                }
            }
            Rectangle {
                color: "lightgoldenrodyellow"
                Text {
                    anchors.centerIn: parent;
                    text: "This is the second page"
                }
            }
        }
    }
}
```

Consider setting the `currentIndex` to 1 to see the effect.

---

## Common Usage Patterns

For complex applications, you will rarely use a single layout. The most common approach is to nest layouts inside one another. A typical application might be structured with:

* A main `ColumnLayout` to separate a top toolbar from the main content area.
* The toolbar itself might be a `RowLayout` containing buttons and spacers.
* The main content area could be a `RowLayout` to create a sidebar next to a central view.
* That central view might then use a `StackLayout` to switch between different screens.

While `GridLayout` is excellent for static grids like forms, many developers find that complex dashboards are often more flexibly built by nesting `RowLayout`s and `ColumnLayout`s. The choice depends on whether your UI has a rigid grid structure or a more flowing, section-based design.
