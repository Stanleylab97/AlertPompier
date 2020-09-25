import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:alert/config/palette.dart';
import 'package:alert/data/data.dart';
import 'package:alert/config/styles.dart';
import 'package:alert/widgets/accidents_chart.dart';
import 'package:alert/widgets/custom_app_bar.dart';
import 'package:alert/widgets/stats_grid.dart';
import 'package:flutter/material.dart';


class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Palette.primaryColor,
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
          _buildRegionTabBar(),
          _buildStageTabBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal:10.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top:20.0),
            sliver: SliverToBoxAdapter(
              child: AccidentChart(weeksAccidents: weeklyCases),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
        padding: const EdgeInsets.all(20.0),
        sliver: SliverToBoxAdapter(
          child: Text(
            "Statistiques",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  SliverToBoxAdapter _buildRegionTabBar() {
    return SliverToBoxAdapter(
        child: DefaultTabController(
            length: 2,
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                height: 50.0,
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(25.0)),
                child: TabBar(
                  indicator: BubbleTabIndicator(
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    indicatorHeight: 40.0,
                    indicatorColor: Colors.white,
                  ),
                  labelStyle: Styles.tabTextStyle,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  tabs: <Widget>[Text("Cotonou"), Text("Tout le Bénin")],
                  onTap: (index) {},
                ))));
  }

  SliverPadding _buildStageTabBar() {
    return SliverPadding(
        padding: const EdgeInsets.all(20.0),
        sliver: SliverToBoxAdapter(
            child: DefaultTabController(
                length: 3,
                child: TabBar(
                  labelStyle: Styles.tabTextStyle,
                  labelColor: Colors.white,
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.white60,
                  tabs: <Widget>[
                    Text('Ce mois'),
                    Text('Ce jour'),
                    Text('Hier'),
                  ],
                  onTap: (index){

                  },
                )
                )
                )
                );
  }
}
