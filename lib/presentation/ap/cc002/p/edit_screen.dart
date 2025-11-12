import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    super.key,
    required this.onInputTextFinish,
    this.content,
    this.subtitle,
    this.hintText,
    this.maxLenght = 500,
  });

  final String? content;
  final Widget? subtitle;
  final String? hintText;
  final int maxLenght;
  final Function(String text) onInputTextFinish;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final focusNode = FocusNode();
  final textController = TextEditingController();

  @override
  void initState() {
    focusNode.requestFocus();
    textController.addListener(_onTextChanged);
    if (widget.content != null && widget.content!.isNotEmpty) {
      textController.text = widget.content!;
    }
    super.initState();
  }

  void _onTextChanged() {
    if (textController.text.length > widget.maxLenght) {
      SmartDialog.showToast(
        'Maximum input length: ${widget.maxLenght} characters',
        displayType: SmartToastType.onlyRefresh,
      );
      // 截断文本到500字符
      textController.text = textController.text.substring(0, widget.maxLenght);
      // 将光标移到文本末尾
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
    }
  }

  void _onSure() {
    focusNode.unfocus();
    // 将值回调出去
    widget.onInputTextFinish(textController.text.trim());
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  focusNode.unfocus();
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset('assets/images/close@3x.png', width: 24),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  if (widget.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ).copyWith(bottom: 6),
                      child: widget.subtitle!,
                    ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Color(0x0F000000)),
                    ),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        // 阻止滚动通知传播到父级，避免与底部表单的拖拽冲突
                        return true;
                      },
                      child: Column(
                        children: [
                          TextField(
                            autofocus: true,
                            textInputAction: TextInputAction.newline, // 修改为换行操作
                            maxLines: null, // 允许多行输入
                            minLines: 5, // 最小显示5行
                            maxLength: null,
                            enableInteractiveSelection: true, // 确保文本选择功能启用
                            dragStartBehavior: DragStartBehavior.down, // 优化拖拽行为
                            style: const TextStyle(
                              height: 1.5, // 增加行高
                              color: Color(0xFF181818),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            controller: textController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero, // 添加内边距
                              hintText:
                                  widget.hintText ??
                                  'Please input your custom text here...',
                              counterText: '',
                              hintStyle: const TextStyle(
                                color: Color(0xFFB3B3B3),
                              ),
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              filled: true,
                              isDense: true,
                            ),
                            focusNode: focusNode,
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: _onSure,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Image.asset(
                                'assets/images/sent@3x.png',
                                width: 54,
                                height: 38,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
