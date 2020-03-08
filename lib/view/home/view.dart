import 'package:flutter/material.dart';

import './widgets/tab_bar.dart';
import './widgets/tab_item.dart';

import './tabs/workspace.dart';
import './tabs/setting.dart';

const int tabCount = 2;
const int turnsToRotateRight = 1;
const int turnsToRotateLeft = 3;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this)
      ..addListener(() {
        // Set state to make sure that the [_RallyTab] widgets get updated when changing tabs.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    Widget tabBarView;

    final verticalRotation = turnsToRotateRight;
      final revertVerticalRotation = turnsToRotateLeft;
    
    tabBarView = Row(
      children: [
        Container(
          width: 150,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              // Rotate the tab bar, so the animation is vertical for desktops.
              RotatedBox(
                quarterTurns: verticalRotation,
                child: VerticalTabBar(
                  tabs: _buildTabs(context: context, theme: theme, isVertical: true)
                      .map((widget) {
                      // Revert the rotation on the tabs.
                      return RotatedBox(
                        quarterTurns: revertVerticalRotation,
                        child: widget,
                      );
                    },
                  ).toList(),
                  tabController: _tabController,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          // Rotate the tab views so we can swipe up and down.
          child: RotatedBox(
            quarterTurns: verticalRotation,
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews().map(
                (widget) {
                  // Revert the rotation on the tab views.
                  return RotatedBox(
                    quarterTurns: revertVerticalRotation,
                    child: widget,
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: Theme(
          // This theme effectively removes the default visual touch
          // feedback for tapping a tab, which is replaced with a custom
          // animation.
          data: theme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: tabBarView,
        ),
      ),
    );
  }

  List<Widget> _buildTabs(
      {BuildContext context, ThemeData theme, bool isVertical = false}) {
    return [
      TabItem(
        theme: theme,
        iconData: Icons.work,
        title: 'Workspace',
        tabIndex: 0,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      TabItem(
        theme: theme,
        iconData: Icons.settings,
        title: 'Setting',
        tabIndex: 1,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
      ),
    ];
  }

  List<Widget> _buildTabViews() {
    return [
      WorkspaceView(),
      SettingView(),
    ];
  }
}
