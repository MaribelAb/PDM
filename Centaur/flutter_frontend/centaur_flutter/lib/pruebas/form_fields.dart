import 'package:flutter/material.dart';

class DynamicModel{
  String controlName;
  FormType formType;
  String value;
  List<ItemModel> items;
  ItemModel? selectedItem;
  bool isRequired;
  List<DynamicFormValidator> validators;
  @override
  const DynamicModel(
    this.controlName, 
    this.formType,
    {
      this.items = const [],
      this.selectedItem,
      this.isRequired = false,
      this.validators = const []
    }
  );
}



enum FormType 
{
  Text,
  Multiline, 
  Dropdown, 
  AutoComplete, 
  RTE,
  DatePicker 
}

class DynamicFormValidator {
  validatorType type;
  String errorMessage;
  int textLength;
  DynamicFormValidator(this.type, this.errorMessage, {this.textLength = 0});
}

enum validatorType { Notempty, TextLength, PhoneNumber, Age, Email }

class ItemModel {
  int id;
  int parentId;
  String name;
  ItemModel(this.id, this.name, {this.parentId = 0});}

TextFormField getTextWidget(index) {
    return TextFormField(
      decoration: InputDecoration(
    helperText: dynamicFormsList[index].hintText,
          labelText: formsList[index].controlName,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)))),
      keyboardType: TextInputType.text,
      maxLines: null,
      validator: (text) {
        var selectedField = formsList[index];
        
        //To validate non-empty, it returns an error message if the text is empty.
        if (selectedField.isRequired &&
            selectedField.validators
                .any((element) => element.type == validatorType.TextNotempty) &&
            (text == null || text.isEmpty)) {
          return selectedField.validators
              .firstWhere(
                  (element) => element.type == validatorType.TextNotempty)
              .errorMessage;
        }
       
        //To validate text length, it returns an error message if the text length is greater than the fixed length.
        if (selectedField.validators
            .any((element) => element.type == validatorType.TextLength)) {
          var validator = selectedField.validators.firstWhere(
              (element) => element.type == validatorType.TextLength);
          int? len = text?.length;
          if (len != null && len > validator.textLength) {
            return validator.errorMessage;
          }
        }
        return null;
      },
      onChanged: (text) {
        formsList[index].value = text;
      },
    );
  }

  DropdownButtonFormField getDropDown(index, List<ItemModel> listItems) {
    return DropdownButtonFormField<ItemModel>(
      value: formsList[index].selectedItem,
      items: listItems.map<DropdownMenuItem<ItemModel>>((ItemModel value) {
        return DropdownMenuItem<ItemModel>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          formsList[index].selectedItem = value;
          if (formsList[index].controlName == "Country") {
            //Get states based on the selected country by parent ID.
            var filteredstates = states
                .where((element) => value?.id == element.parentId)
                .toList();

            if (formsList.any((element) => element.controlName == "State")) {
              formsList[index + 1].selectedItem = null;
              var existingitem = formsList
                  .firstWhere((element) => element.controlName == "State");
              formsList.remove(existingitem);
            }

            if (filteredstates.isNotEmpty) {
              formsList.insert(
                  index + 1,
                  DynamicModel("State", FormType.Dropdown,
                      items: filteredstates));
            }
          }
        });
      },
      validator: (value) => value == null ? 'Field required' : null,
      decoration: InputDecoration(
          labelText: formsList[index].controlName,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)))),
    );
  }
  Widget getAutoComplete(index) {
    return DropdownSearch<String>.multiSelection(
      items: const ["Facebook", "Twitter", "Microsoft"],
      popupProps: const PopupPropsMultiSelection.menu(
        isFilterOnline: true,
        showSelectedItems: true,
        showSearchBox: true,
        favoriteItemProps: FavoriteItemProps(
          showFavoriteItems: true,
        ),
      ),
      onChanged: print,
      selectedItems: const ["Facebook"],
    );
  }

  Widget getHtmlReadOnly(index) {
    return Html(
      data: formsList[index].value,
      shrinkWrap: true,
      style: {
        // tables will have the below background color
        "table": Style(
          backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
        ),
        // some other granular customizations are also possible
        "tr": Style(
          border: const Border(bottom: BorderSide(color: Colors.grey)),
        ),
        "th": Style(
          padding: const EdgeInsets.all(6),
          backgroundColor: Colors.grey,
        ),
        "td": Style(
          padding: const EdgeInsets.all(6),
          alignment: Alignment.topLeft,
        ),
      },
    );
  }
  Widget getDatePicker(index) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
          labelText: dynamicFormsList[index].controlName,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)))),
      maxLines: null,
      readOnly: true,
      onTap: () {
        showDialog<Widget>(
            context: context,
            builder: (BuildContext context) {
              return SfDateRangePicker(
                controller: dateRangePickerController,
                selectionColor: Colors.green,
                showActionButtons: true,
                backgroundColor: Colors.white,
                todayHighlightColor: Colors.transparent,
                initialSelectedDate: DateTime(2023, 1, 22),
                onSubmit: (Object? value) {
                  Navigator.pop(context);
                  setState(() {
                    dynamicFormsList[index].value = DateFormat("dd/MM/y")
                        .format(dateRangePickerController.selectedDate!);
                    textEditingController.text = dynamicFormsList[index].value;
                  });
                },
                onCancel: () {
                  Navigator.pop(context);
                },
              );
            });
      },
    );
  }
  DynamicModel dynamicModel =
        DynamicModel("Name", FormType.Text, isRequired: true);
    dynamicModel.validators = [];
    dynamicModel.validators.add(DynamicFormValidator(
        validatorType.TextNotempty, "Name should not be Empty"));
    dynamicModel.validators.add(DynamicFormValidator(
        validatorType.TextLength, "Maximum length should be 10",
        textLength: 10));
    dynamicFormsList.add(dynamicModel);

    dynamicModel =
        DynamicModel("Phone Number", FormType.Number, isRequired: true);
    dynamicModel.validators = [];
    dynamicModel.validators.add(DynamicFormValidator(
        validatorType.TextNotempty, "Phone number should not be Empty"));
    dynamicModel.validators.add(DynamicFormValidator(
        validatorType.PhoneNumber, "Phone number should be 10 digits",
        textLength: 10));
    dynamicFormsList.add(dynamicModel);

    dynamicFormsList.add(DynamicModel("Address", FormType.Multiline));
    dynamicFormsList.add(DynamicModel("Country", FormType.Dropdown, items: countries));
    dynamicFormsList.add(DynamicModel("Contact", FormType.AutoComplete));

    GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late List<DynamicModel> dynamicFormsList = [];
  late List<ItemModel> countries = [];
  late List<ItemModel> states = [];

  Widget _dynamicWidget() {
    return Form(
      key: globalFormKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  dynamicLists(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FormHelper.submitButton("Save", () async {
                      if (validateAndSave()) {}
                    }, btnColor: const Color.fromARGB(255, 84, 60, 206)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dynamicLists() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: dynamicFormsList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: getWidgetBasedFormType(index),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ],
          ),
          onTap: () async {
            selectedIndex = index;
            var selectedform = dynamicFormsList[index].formType;
            if (selectedform == FormType.HTMLReader) {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HTMLEditorPage(htmlText: dynamicFormsList[index].value),
                ),
              );
              setState(() {
                dynamicFormsList[index].value =
                    result ?? dynamicFormsList[index].value;
              });
            }
          },
        );
      },
    );
  }
  Widget getWidgetBasedFormType(index) {
    var form = dynamicFormsList[index];
    FormType type = form.formType;
    switch (type) {
      case FormType.Text:
        return getTextWidget(index);
      case FormType.Number:
        return getNumberTextWidget(index);
      case FormType.Multiline:
        return getMultilineTextWidget(index);
      case FormType.Dropdown:
        return getDropDown(index, form.items);
      case FormType.AutoComplete:
        return getAutoComplete(index);
      case FormType.HTMLReader:
        return getHtmlReadOnly(index);
case FormType.DatePicker:
        return getDatePicker(index);

    }
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  validator: (text) {
        var selectedField = dynamicFormsList[index];
        if (selectedField.isRequired &&
            selectedField.validators
                .any((element) => element.type == validatorType.TextNotempty) &&
            (text == null || text.isEmpty)) {
          return selectedField.validators
              .firstWhere(
                  (element) => element.type == validatorType.TextNotempty)
              .errorMessage;
        }
        if (selectedField.validators
            .any((element) => element.type == validatorType.TextLength)) {
          var validator = selectedField.validators.firstWhere(
              (element) => element.type == validatorType.TextLength);
          int? len = text?.length;
          if (len != null && len > validator.textLength) {
            return validator.errorMessage;
          }
        }
        return null;
      }