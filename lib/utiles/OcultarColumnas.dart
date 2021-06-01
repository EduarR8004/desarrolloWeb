import 'package:flutter/material.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Más Información'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          alignment: Alignment.bottomLeft,
          child:RaisedButton(
                  textColor: Color.fromRGBO(83, 86, 90, 1.0),
                color: Color.fromRGBO(56, 124, 43, 1.0),
                child: Text('Cancelar', style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                onPressed: _onCancelTap,
          ),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          child:RaisedButton(
                  textColor: Color.fromRGBO(83, 86, 90, 1.0),
                color: Color.fromRGBO(56, 124, 43, 1.0),
                child: Text('Aceptar', style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                onPressed: _onSubmitTap,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}