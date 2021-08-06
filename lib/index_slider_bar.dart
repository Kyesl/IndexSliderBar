import 'package:flutter/material.dart';

class IndexSliderBar extends StatefulWidget {

  final List<String> dataList;
  final Function onSelectChange;

  final Color bgColor;
  final Color tapedBgColor;
  final Color itemColor;
  final Color itemSelectedColor;
  final Color itemSelectedBgColor;

  IndexSliderBar(this.dataList, this.onSelectChange,
      {this.bgColor = Colors.transparent,
        this.tapedBgColor = Colors.transparent,
        this.itemColor = Colors.black,
        this.itemSelectedColor = Colors.black,
        this.itemSelectedBgColor = Colors.transparent});

  @override
  State<StatefulWidget> createState() => _IndexSliderBarState();
}

class _IndexSliderBarState extends State<IndexSliderBar> {

  List<String> _dataList = [];
  List<Widget> _widgetList = [];

  bool _isTap = false;

  String _lastSelectData = "";

  @override
  void initState() {
    _dataList = widget.dataList;
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
          _lastSelectData = "";
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: _isTap ? widget.tapedBgColor : widget.bgColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _dataList.map((e) =>
              Container(
                alignment: Alignment.center,
                width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: _lastSelectData == e ? widget.itemSelectedBgColor : Colors.transparent
                  ),
                  child: Text(e, style: TextStyle(fontSize: 14, color: _lastSelectData == e ? widget.itemSelectedColor : widget.itemColor),)
              )
          ).toList(),
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
    if (_lastSelectData == selectData) {
      return;
    }
    setState(() {
      _lastSelectData = selectData;
    });

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