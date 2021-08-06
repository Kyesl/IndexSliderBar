import 'package:flutter/material.dart';

class IndexSliderBar extends StatefulWidget {
  final List<String> dataList;
  final Function onSelectChange;

  final Color bgColor;
  final Color tapedBgColor;
  final Color itemColor;
  final Color itemSelectedColor;
  final Color itemSelectedBgColor;

  final bool showBubble;
  final Color bubbleBgColor;
  final Color bubbleItemColor;

  IndexSliderBar(this.dataList, this.onSelectChange,
      {this.bgColor = Colors.transparent,
      this.tapedBgColor = Colors.transparent,
      this.itemColor = Colors.black,
      this.itemSelectedColor = Colors.black,
      this.itemSelectedBgColor = Colors.transparent,
      this.showBubble = false,
      this.bubbleBgColor = Colors.transparent,
      this.bubbleItemColor = Colors.black});

  @override
  State<StatefulWidget> createState() => _IndexSliderBarState();
}

class _IndexSliderBarState extends State<IndexSliderBar> {
  List<String> _dataList = [];

  bool _isTap = false;

  String _lastSelectData = "";

  double _bubbleMarginTop = 0;

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.showBubble && _lastSelectData != "") ? Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: _bubbleMarginTop.toDouble()),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: widget.bubbleBgColor,
          ),
          child: Text(_lastSelectData, style: TextStyle(fontSize: 16, color: widget.bubbleItemColor),),
        ) : Container(height: 0,),
        GestureDetector(
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
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: _isTap ? widget.tapedBgColor : widget.bgColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _dataList
                  .map((e) => Container(
                      alignment: Alignment.center,
                      width: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: _lastSelectData == e
                              ? widget.itemSelectedBgColor
                              : Colors.transparent),
                      child: Text(
                        e,
                        style: TextStyle(
                            fontSize: 14,
                            color: _lastSelectData == e
                                ? widget.itemSelectedColor
                                : widget.itemColor),
                      )))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  _onVerticalDragUpdate(BuildContext context, Offset globalPosition) {
    var renderBox = context.findRenderObject() as RenderBox;
    // 每个Item的高度
    double itemHeight = (renderBox.size.height - 30) / _dataList.length;
    // 手指在垂直方向上的坐标值
    double dy = renderBox.globalToLocal(globalPosition).dy;
    int index = ((dy - 30) / itemHeight).round();

    String selectData = _getSelectedData(index);

    if (_lastSelectData == selectData) {
      return;
    }
    setState(() {
      _lastSelectData = selectData;
      if (widget.showBubble) {
        double bubbleMarginTop = itemHeight * index + 15 - 20 + itemHeight / 2;
        _bubbleMarginTop = bubbleMarginTop >= 0 ? bubbleMarginTop : 0;
      }
    });

    widget.onSelectChange(selectData);
  }

  _getSelectedData(int index) {
    if (index < 0) {
      return _dataList[0];
    } else if (index >= _dataList.length) {
      return _dataList[_dataList.length - 1];
    } else {
      return _dataList[index];
    }
  }
}
