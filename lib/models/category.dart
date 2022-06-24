import 'package:flutter/material.dart';

enum Category {
  food,
  shopping,
  transport,
  housing,
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
