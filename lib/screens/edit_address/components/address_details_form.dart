import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uenr_shop/components/default_button.dart';
import 'package:uenr_shop/models/Address.dart';
import 'package:uenr_shop/services/database/user_database_helper.dart';
import 'package:uenr_shop/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:string_validator/string_validator.dart';
import '../../../constants.dart';

class AddressDetailsForm extends StatefulWidget {
  final Address addressToEdit;
  AddressDetailsForm({
    Key key,
    this.addressToEdit,
  }) : super(key: key);

  @override
  _AddressDetailsFormState createState() => _AddressDetailsFormState();
}

class _AddressDetailsFormState extends State<AddressDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleFieldController = TextEditingController();

  final TextEditingController receiverFieldController = TextEditingController();

  final TextEditingController cityFieldController = TextEditingController();

  final TextEditingController stateFieldController = TextEditingController();

  final TextEditingController phoneFieldController = TextEditingController();

  @override
  void dispose() {
    titleFieldController.dispose();
    receiverFieldController.dispose();
    cityFieldController.dispose();
    stateFieldController.dispose();
    phoneFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          buildTitleField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildReceiverField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCityField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildStateField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            text: "Save Address",
            press: widget.addressToEdit == null
                ? saveNewAddressButtonCallback
                : saveEditedAddressButtonCallback,
          ),
        ],
      ),
    );
    if (widget.addressToEdit != null) {
      titleFieldController.text = widget.addressToEdit.title;
      receiverFieldController.text = widget.addressToEdit.receiver;
      cityFieldController.text = widget.addressToEdit.city;
      stateFieldController.text = widget.addressToEdit.state;
      phoneFieldController.text = widget.addressToEdit.phone;
    }
    return form;
  }

  Widget buildTitleField() {
    return TextFormField(
      controller: titleFieldController,
      keyboardType: TextInputType.name,
      maxLength: 8,
      decoration: InputDecoration(
        hintText: "Enter a title for address",
        labelText: "Title",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (titleFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildReceiverField() {
    return TextFormField(
      controller: receiverFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Full Name of Receiver",
        labelText: "Receiver Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (receiverFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCityField() {
    return TextFormField(
      controller: cityFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter City",
        labelText: "City",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (cityFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStateField() {
    return TextFormField(
      controller: stateFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Your Location",
        labelText: "Location",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (stateFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneField() {
    return TextFormField(
      controller: phoneFieldController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter Phone Number",
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (phoneFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        } else if (phoneFieldController.text.length != 10) {
          return "Only 10 Digits";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> saveNewAddressButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final Address newAddress = generateAddressObject();
      bool status = false;
      String snackbarMessage;
      try {
        status =
            await UserDatabaseHelper().addAddressForCurrentUser(newAddress);
        if (status == true) {
          snackbarMessage = "Address saved successfully";
        } else {
          throw "Coundn't save the address due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Something went wrong";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = "Something went wrong";
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }

  Future<void> saveEditedAddressButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final Address newAddress =
          generateAddressObject(id: widget.addressToEdit.id);

      bool status = false;
      String snackbarMessage;
      try {
        status =
            await UserDatabaseHelper().updateAddressForCurrentUser(newAddress);
        if (status == true) {
          snackbarMessage = "Address updated successfully";
        } else {
          throw "Couldn't update address due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Something went wrong";
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = "Something went wrong";
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }

  Address generateAddressObject({String id}) {
    return Address(
      id: id,
      title: titleFieldController.text,
      receiver: receiverFieldController.text,
      city: cityFieldController.text,
      state: stateFieldController.text,
      phone: phoneFieldController.text,
    );
  }
}
