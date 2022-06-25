import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

enum Category {
  @JsonValue("food")
  food,
  @JsonValue("shopping")
  shopping,
  @JsonValue("transport")
  transport,
  @JsonValue("housing")
  housing,
  @JsonValue("others")
  others,
}

List<Map<String, dynamic>> categories = [
  {
    'name': 'Food',
    'icon': Icons.restaurant,
    'category': Category.food,
  },
  {
    'name': 'Shopping',
    'icon': Icons.shopping_bag,
    'category': Category.shopping,
  },
  {
    'name': 'Transport',
    'icon': Icons.directions_bus,
    'category': Category.transport,
  },
  {
    'name': 'Housing',
    'icon': Icons.home,
    'category': Category.housing,
  },
  {
    'name': 'Others',
    'icon': Icons.reorder,
    'category': Category.others,
  },
];

/// Maps through the enum and returns the icon for the passed in category.
dynamic categoryToIcon(Category category) {
  late IconData icon;
  categories.forEach((element) {
    if (element['category'] == category) {
      icon = element['icon'];
      return;
    }
  });
  return icon;
}
