import 'package:flutter/material.dart';
import 'package:mixins/mixins.dart';

class FormView extends StatelessWidget {
  const FormView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController item = TextEditingController(), price = TextEditingController(), category = TextEditingController();

    List<String> options = ['Food', 'Drink', 'Snack', 'Medicine', 'Alcohol', 'Other'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form View'),
      ),
      body: ListView(
        physics: BounceScroll(),
        padding: Ei.all(20),
        children: [
          TextInput(
            label: 'Item Name',
            hint: 'Input item name',
            controller: item,
            indicator: true,
          ),
          TextInput(
            label: 'Item Price',
            hint: 'Input item price',
            controller: price,
            keyboard: Tit.number,
          ),
          SelectInput(
            label: 'Category',
            hint: 'Select category',
            controller: category,
            options: List.generate(options.length, (i) => Option(option: options[i])),
          ),
        ],
      ),
    );
  }
}
