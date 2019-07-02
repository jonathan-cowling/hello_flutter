
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

class EligibilityForm extends StatefulWidget {
  @override
  _EligibilityState createState() {
    return _EligibilityState();
  }
}

class _EligibilityState extends State<EligibilityForm> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    var formData = _EligibilityFormData();
    
    return Form(
        key: formKey,
        child: FractionallySizedBox(widthFactor: 4/5,
            child: Column(children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                initialValue: "",
                validator: (input) => input == "" ? "enter something" : null,
                onSaved: (value) {
                  setState(() {
                    formData.name = value;
                  });
                },
              ),
              FormField(
                  initialValue: false,
                  validator: (checked) => checked? null : "please check the box",
                  onSaved: (value) {
                    formData.checked = value;
                  },
                  builder: (state) {

                    final widgets = Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: Text("Leagal stuff")),
                          Checkbox(value: state.value, onChanged: (checked) {
                            state.didChange(checked);
                          })
                        ],
                      ),
                    ]);

                    if (state.hasError) {
                      widgets.children.add(
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(state.errorText, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        )
                      );
                    }

                    return widgets;
                  }
              ),
              RaisedButton(
                  child: Text("GO"),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      Navigator.of(context).pushNamed("/yellow");
                    }
                  }
              )
            ]))
    );
  }
}

class _EligibilityFormData {
  String name;
  bool checked;

  @override
  String toString() {
    return "name: $name, checked: $checked";
  }
}