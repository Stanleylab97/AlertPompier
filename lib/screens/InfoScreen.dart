import 'package:alert/config/Constant.dart';
import 'package:alert/widgets/my_header.dart';
import 'package:flutter/material.dart';


class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
 final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/images/virus.png",
              textTop: "Faîtes attention à vous!",
              textBottom: "Soyez prudent",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 
                  Text("Quelques conseils utiles", style: kTitleTextstyle),
                  SizedBox(height: 20),
                  PreventCard(
                    text:"Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                    image: "assets/images/casque.png",
                    title: "Wear face mask",
                    color: Colors.green
                  ),
                  PreventCard(
                    text:"Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                    image: "assets/images/casque.png",
                    title: "Wear face mask",
                    color: Colors.blue,
                  ),
                  PreventCard(
                    text:"Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                    image: "assets/images/casque.png",
                    title: "Wear face mask",
                     color: Colors.red,
                  ),
                  PreventCard(
                    text:
                        "Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                    image: "assets/images/casque.png",
                    title: "Wash your hands",
                     color: Colors.orange,
                  ),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  final Color color;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: SizedBox(
        height: 150,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 126,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            
            Positioned(
              
              child: Container(              
                color: color,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 120,
                width: MediaQuery.of(context).size.width - 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white
                        ),
                        
                      ),
                      
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

