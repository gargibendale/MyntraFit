import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myntra/clothes_kids.dart';
import 'package:myntra/clothes_mens.dart';
import 'package:myntra/clothes_womens.dart';
import 'package:myntra/communitychat.dart';
import 'package:myntra/myoutfits.dart';
import 'package:myntra/reviews.dart';
import 'package:myntra/service/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'scroll.dart';
import 'cat.dart'; // Import the cat.dart file

void main() {
  runApp(MaterialApp(
    home: WelcomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  AuthService authService = AuthService();
  late Timer _timer;
  int _selectedIndex = 0;

  final List<String> _images = [
    'assets/gofor.jpg',
    'assets/kids.webp',
    'assets/foot.webp',
    'assets/bags.jpg',
  ];

  final List<String> _additionalImages = [
    'assets/girls.jpg',
    'assets/allen.jpg',
    'assets/vero.jpg',
    'assets/bata.jpg',
  ];

  final List<String> _rowSliderImages = [
    'assets/ninety.jpg',
    'assets/twenty.jpg',
    'assets/thirty.jpg',
    'assets/fourty.jpg',
  ];

  final List<String> _under199ImagesTopRow = [
    'assets/footcat.jpg',
    'assets/kurtacat.jpg',
    'assets/kurticat.jpg',
    'assets/lipcat.webp',
    'assets/moistcat.jpg',
    'assets/shirtcat.jpg',
    'assets/shirtcatm.jpg',
    'assets/tshirtcatw.jpg',
    'assets/watchcat.jpg',
  ];

  final List<String> _under199ImagesBottomRow = [
    'assets/bedcat.jpg',
    'assets/cascat.jpg',
    'assets/flipcat.jpg',
    'assets/jeanscat.jpg',
    'assets/kiddrcat.webp',
    'assets/shampcat.jpg',
    'assets/shortcat.jpg',
    'assets/sportcat.webp',
    'assets/trollycat.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        if (_pageController.page == _images.length - 1) {
          _pageController.jumpToPage(0);
        } else {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: _buildDropdownButton(context),
          ),
          IconButton(
            onPressed: () {
              authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              // Navigate to personalized outfits page
            },
            icon: Icon(Icons.shopping_cart, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),

              // Build your search bar widget
              _buildSearchBar(),

              SizedBox(height: 20.0),

              _buildButtonRow(),

              SizedBox(height: 20.0),

              // Build your image carousel widget
              _buildImageCarousel(),
              SizedBox(height: 10.0),

              communityChatCard(),

              SizedBox(height: 10.0),

              // Build your additional images row widget
              _buildAdditionalImagesRow(),

              SizedBox(height: 20.0),

              // Build your row slider images widget
              _buildRowSliderImages(),

              SizedBox(height: 20.0),

              // Build your under 199 images widgets
              _buildUnder199Images(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyOutfitsPage()),
              );
            } else if (index == 2) {
              // Navigate to the Categories page (cat.dart)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoriesPage()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyOutfitsPage()),
              );
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/logo.webp', width: 24.0, height: 24.0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat', // This will navigate to cat.dart
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Post Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom_sharp),
            label: 'My OutFits',
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScrollPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 230, 219),
          border:
              Border.all(color: Color.fromARGB(255, 235, 204, 171), width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Myntra',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            SizedBox(width: 8.0),
            Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600]),
          SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Icon(Icons.camera_alt),
          SizedBox(width: 10.0),
          Icon(Icons.mic),
        ],
      ),
    );
  }

  // Define the function to create the button row
  Widget _buildButtonRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSquareButton('Men', 'assets/men.webp', DisplayMensPage()),
          SizedBox(width: 10.0),
          _buildSquareButton('Women', 'assets/women.jpg', DisplayWomensPage()),
          SizedBox(width: 10.0),
          _buildSquareButton('Kids', 'assets/both.webp', DisplayKidsPage()),
          SizedBox(width: 10.0),
          _buildSquareButton('Footwear', 'assets/heels.jpg'),
          SizedBox(width: 10.0),
          _buildSquareButton('Accessories', 'assets/purse.webp'),
          SizedBox(width: 10.0),
          _buildSquareButton('Watches', 'assets/watch.jpg'),
          SizedBox(width: 10.0),
          _buildSquareButton('Luggage', 'assets/trolly.jpg'),
          SizedBox(width: 10.0),
          _buildSquareButton('Gadgets', 'assets/headphone.webp'),
          SizedBox(width: 10.0),
          _buildSquareButton('Jewellery', 'assets/jewel.webp'),
        ],
      ),
    );
  }

  Widget communityChatCard() {
    return Container(
      height: 200,
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image:
              AssetImage('assets/community_bg.jpg'), // Add your image path here
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black
                .withOpacity(0.3), // Dark overlay for better text contrast
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black54],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("See what everyone is talking about",
                textAlign: TextAlign.center,
                style: GoogleFonts.trainOne(
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    // Stylish font
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(2), // Outer white border
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: 2), // Outer border
                      borderRadius:
                          BorderRadius.circular(12), // Outer border radius
                    ),
                    child: Container(
                      padding: EdgeInsets.all(
                          2), // Inner gap for double border effect
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white, width: 2), // Inner border
                        borderRadius:
                            BorderRadius.circular(10), // Inner border radius
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StoriesPage()), // Pass item ID here
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0, // Remove shadow
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Button radius
                          ),
                        ),
                        child: Text(
                          "Join Chat",
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

// Define the _buildSquareButton function
  Widget _buildSquareButton(String label, String imagePath, [Widget? page]) {
    return Column(
      children: [
        // Button with image
        GestureDetector(
          onTap: () => {
            if (page != null)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                )
              }
          },
          child: Container(
            width: 70, // Adjust the size of the button
            height: 84,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.black, width: 2.0), // Add border styling
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        // Text label under the button
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      height: 200.0,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Image.asset(
            _images[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildAdditionalImagesRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _additionalImages.map((image) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 190.0,
              height: 260.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRowSliderImages() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _rowSliderImages.map((image) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 170.0,
              height: 170.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUnder199Images() {
    return Column(
      children: [
        _buildUnder199Row(_under199ImagesTopRow),
        SizedBox(height: 20.0),
        _buildUnder199Row(_under199ImagesBottomRow),
      ],
    );
  }

  Widget _buildUnder199Row(List<String> imagePaths) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: imagePaths.map((image) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 90.0,
              height: 130.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
