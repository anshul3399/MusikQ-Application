import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late final TextEditingController textEditingControllerSearchBox;

  @override
  void initState() {
    super.initState();
    textEditingControllerSearchBox = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    textEditingControllerSearchBox.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styleActive = GoogleFonts.josefinSans(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
    final styleHint = GoogleFonts.josefinSans(
      fontSize: 14,
      color: Color.fromARGB(255, 220, 220, 220),
      fontWeight: FontWeight.w500,
    );

    final currentStyle = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 30,
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent,
        border: Border.all(color: Color.fromARGB(222, 233, 233, 233)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5), // Adds a little space before the icon
          Icon(Icons.search, color: currentStyle.color),
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: textEditingControllerSearchBox,
              cursorColor: Colors.white, // Cursor color
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: styleHint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero, // Adjusted padding
                isDense: true, // Reduces the height of the input area
              ),
              style: currentStyle,
              onChanged: widget.onChanged,
            ),
          ),
          if (widget.text.isNotEmpty)
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10), // Adjust close icon position
                child: Icon(Icons.close, color: currentStyle.color),
              ),
              onTap: () {
                textEditingControllerSearchBox.clear();
                widget.onChanged('');
                FocusScope.of(context).unfocus();
              },
            ),
        ],
      ),
    );
  }
}
