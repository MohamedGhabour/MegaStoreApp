import 'package:flutter/material.dart';
import 'package:mega_shop/utility/extensions.dart';
import '../utility/app_color.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _isExpanded = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) _focusNode.unfocus();
    });
  }

  void _clearSearch() {
    widget.controller.clear();
    _focusNode.unfocus();
    context.dataProvider.filterProducts('');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppColor.lightGrey,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: widget.onChanged,
              ),
            ),
            if (_isExpanded)
              GestureDetector(
                onTap: _clearSearch,
                child: const Icon(Icons.close),
              ),
          ],
        ),
      ),
    );
  }
}
