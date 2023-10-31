import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isInputFile;
  final bool isDropbutton;
  final Function()? onTapCallback;
  final List<DropdownMenuItem<String>>? dropdownItems;
  final bool validatorNumber;
  final Function(String)? onDropdownChanged;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
    this.isInputFile = false,
    this.isDropbutton = false,
    this.onTapCallback,
    this.dropdownItems,
    this.validatorNumber = false,
    this.onDropdownChanged,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  String? selectedDropdownValue;

  @override
  void initState() {
    super.initState();
    // Se o widget é do tipo dropdown e o controller possui valor, use-o como valor padrão
    if (widget.isDropbutton && widget.controller.text.isNotEmpty) {
      selectedDropdownValue = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.06,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side:
              const BorderSide(width: 1, color: Color(ThemeColors.borderInput)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: widget.isDropbutton
          ? Container(
              width: 300,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(37),
                ),
              ),
              child: DropdownButton<String>(
                value: selectedDropdownValue,
                items: widget.dropdownItems,
                hint: Text(
                  widget.labelText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFA0A0A0),
                  ),
                ),
                onChanged: (String? newValue) {
                  widget.controller.text = newValue ?? '';
                  setState(() {
                    selectedDropdownValue = newValue;
                  });
                  if (widget.onDropdownChanged != null) {
                    widget.onDropdownChanged!(newValue ?? '');
                  }
                },
                underline: Container(), // Remove a linha de seleção padrão
              ),
            )
          : TextFormField(
              onTap: widget.isInputFile ? widget.onTapCallback : null,
              controller: widget.controller,
              obscureText: widget.isPassword,
              readOnly: widget.isInputFile,
              keyboardType:
                  widget.validatorNumber ? TextInputType.number : null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.labelText,
                hintStyle: const TextStyle(
                  color: Color(0xFFA0A0A0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
    );
  }
}
