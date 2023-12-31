import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:inventory_app/provider/item_provider.dart';
import 'package:provider/provider.dart';

import '../../models/response_crud.dart';
import '../widgets/custom_textfield_widget.dart';

class FormPage extends StatefulWidget {
  final Barang? itemBarang;
  const FormPage({super.key, this.itemBarang});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _urlController;
  late ItemProvider itemProvider;
  late bool isUpdateForm;

  Widget nameFields() {
    return CustomTextFieldWidgets(
      controller: _nameController,
      labelText: "Item Name",
    );
  }

  Widget amountFields() {
    return CustomTextFieldWidgets(
      controller: _amountController,
      keyboardType: TextInputType.number,
      labelText: "Item Count",
    );
  }

  Widget urlFields() {
    return CustomTextFieldWidgets(
      controller: _urlController,
      labelText: "URL item",
    );
  }

  Widget buttonSave() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: handleActionButton,
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(
          isUpdateForm ? 'UPDATE' : 'SAVE',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
        actions: widget.itemBarang != null
            ? [
                IconButton(
                  onPressed: () async {
                    await itemProvider.deleteBarang(widget.itemBarang!.barangId);
                    final isSuccess = itemProvider.responseCrud!.sukses;
                    if (isSuccess) {
                      if (!mounted) return;
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: itemProvider.responseCrud!.pesan);
                    }else {
                      Fluttertoast.showToast(
                        msg: itemProvider.responseCrud!.pesan
                      );
                    }
                    
                  },
                  icon: const Icon(Icons.delete),
                )
              ]
            : const [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                nameFields(),
                amountFields(),
                urlFields(),
                buttonSave()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.itemBarang?.barangNama ?? "");
    _amountController =
        TextEditingController(text: widget.itemBarang?.barangJumlah ?? "");
    _urlController =
        TextEditingController(text: widget.itemBarang?.barangGambar ?? "");
    isUpdateForm = widget.itemBarang != null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final itemProvider = Provider.of<ItemProvider>(context);
// if (this.itemProvider != itemProvider) {
    this.itemProvider = itemProvider;
// }
  }

  void handleActionButton() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
       final name = _nameController.text;
       final amount = _amountController.text;
       final urlImage = _urlController.text;
       if (isUpdateForm) {
        await itemProvider.updateBarang(widget.itemBarang!.barangId, name, amount, urlImage);
       } else {
        await itemProvider.insertBarang(name, amount, urlImage);
       }

       final isSucces = itemProvider.responseCrud!.sukses;
       if (isSucces) {
        if(!mounted) return;
        Navigator.pop(context);
        Fluttertoast.showToast(msg: itemProvider.responseCrud!.pesan);
       } else {
        Fluttertoast.showToast(msg: itemProvider.responseCrud!.pesan);
       }
    }
  }
}
