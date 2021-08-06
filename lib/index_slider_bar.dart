import 'package:flutter/material.dart';

class IndexSliderBar extends StatefulWidget {

  final List<String> dataList;
  final Function onSelectChange;

  IndexSliderBar(this.dataList, this.onSelectChange);

  @override
  State<StatefulWidget> createState() => _IndexSliderBarState();
}

class _IndexSliderBarState extends State<IndexSliderBar> {

  List<String> _dataList = [];
  List<Widget> _widgetList = [];

  bool _isTap = false;

  String lastSelectData = "";

  @override
  void initState() {
    _dataList = widget.dataList;
    _widgetList =
        _dataList.map((e) => Text(e, style: TextStyle(fontSize: 14),)).toList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (DragStartDetails start) {
        setState(() {
          _isTap = true;
        });
        _onVerticalDragUpdate(context, start.globalPosition);
      },
      onVerticalDragUpdate: (DragUpdateDetails update) =>
          _onVerticalDragUpdate(context, update.globalPosition),
      onVerticalDragEnd: (DragEndDetails end) {
        setState(() {
          _isTap = false;
        });
      },
      child: Container(
        width: 25,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: _isTap ? Colors.grey[200] : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _widgetList,
        ),
      ),
    );
  }

  _onVerticalDragUpdate(BuildContext context, Offset globalPosition) {
    var renderBox = context.findRenderObject() as RenderBox;
    // 手指在垂直方向上的坐标值
    double dy = renderBox
        .globalToLocal(globalPosition)
        .dy;

    String selectData = _getSelectedData(dy);
    if (lastSelectData == selectData) {
      return;
    }
    lastSelectData = selectData;

    widget.onSelectChange(selectData);
  }

  _getSelectedData(double dy) {
    // 因为组件padding上下各位10，所以先减掉20，16大概为每个Text的高度，由此计算当前坐标是哪一个Text
    int index = ((dy - 20) / 16).round();
    if (index < 0) {
      return _dataList[0];
    } else if (index >= _dataList.length) {
      return _dataList[_dataList.length - 1];
    } else {
      return _dataList[index];
    }
  }

}