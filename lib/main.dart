import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoList(),
    );
  }
}

class CartPopup extends StatefulWidget {
  @override
  _CartPopupState createState() => _CartPopupState();
}

class _CartPopupState extends State<CartPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background color of the popup
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Cart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(), // Divider for separating header and content
          // Replace with your cart content or widgets
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Item 1'),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                // Implement logic to remove item from cart
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Item 2'),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                // Implement logic to remove item from cart
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Item 3'),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                // Implement logic to remove item from cart
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Item 4'),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                // Implement logic to remove item from cart
              },
            ),
          ),
          // Add more ListTiles or other widgets for cart items
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the popup
            },
            child: Text('Close'),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  PageController _pageController = PageController();
  IconData currentProductIcon = Icons.games; // Initial product icon
  String currentProductTitle = 'Product 1'; // Initial product title
  String currentProductSubtitle = 'Very Interesting Games joystick'; // Initial product subtitle
  int currentProductQuantity = 0; // Initial product quantity

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showProductPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Details'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 200, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3, // Number of images to display
                    itemBuilder: (context, index) {
                      int displayIndex = index + 1; // Adjust index to start from 1
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/Coffee$displayIndex.jpg'), // Replace with your image assets
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(currentProductIcon), // Use current product icon
                    title: Text(currentProductTitle),
                    subtitle: Text(currentProductSubtitle),
                    trailing: QuantitySelector(
                      onChanged: (value) {
                        setState(() {
                          currentProductQuantity = value;
                        });
                      },
                    ), // Custom widget for quantity selector
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _saveProductData();
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateProductInfo(int videoIndex) {
    setState(() {
      // Update product information based on video index
      switch (videoIndex) {
        case 1:
          currentProductIcon = Icons.games;
          currentProductTitle = 'Product 1';
          currentProductSubtitle = 'Very Interesting Games joystick';
          break;
        case 2:
          currentProductIcon = Icons.shopping_cart;
          currentProductTitle = 'Product 2';
          currentProductSubtitle = 'Buy your products very easily today!';
          break;
        case 3:
          currentProductIcon = Icons.art_track;
          currentProductTitle = 'Product 3';
          currentProductSubtitle = 'Discover the art, design & Creatives';
          break;
        default:
          currentProductIcon = Icons.error;
          currentProductTitle = 'Error';
          currentProductSubtitle = 'Product information not available';
          break;
      }
      // Reset quantity when updating product info
      currentProductQuantity = 0;
    });
  }

  Future<void> _saveProductData() async {
    // Define your local directory path
    String localPath = 'C:/development/flutter-apps/tiktok_clone/myData';
    Directory directory = Directory(localPath);

    // Check if the directory exists, create it if it doesn't
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Construct the file path within the directory
    final file = File('${directory.path}/product_data.json');

    // Read existing data from file
    List<dynamic> existingData = [];
    if (await file.exists()) {
      String fileContents = await file.readAsString();
      existingData = jsonDecode(fileContents);
    }

    // Prepare new product data
    Map<String, dynamic> productData = {
      'name': currentProductTitle,
      'quantity': currentProductQuantity,
    };

    // Add new product data to existing data
    existingData.add(productData);

    try {
      // Write updated data to file
      await file.writeAsString(jsonEncode(existingData));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product data saved successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error saving product data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save product data.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Calculate swipe direction based on velocity
          if (details.primaryVelocity! < 0) {
            // Swipe up
            _pageController.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else if (details.primaryVelocity! > 0) {
            // Swipe down
            _pageController.previousPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
        },
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical, // Set scroll direction to vertical
          itemCount: 3, // Replace with the number of local videos you have
          itemBuilder: (context, index) {
            return VideoPlayerPage(
              videoIndex: index + 1,
              showProductPopup: _showProductPopup, // Pass function to VideoPlayerPage
              updateProductInfo: updateProductInfo, // Pass function to update product info
            );
          },
        ),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final int videoIndex;
  final Function showProductPopup;
  final Function updateProductInfo;

  VideoPlayerPage({
    required this.videoIndex,
    required this.showProductPopup,
    required this.updateProductInfo,
  });

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    // Replace this URL with your video URL
    String videoUrl = 'https://www.example.com/video.mp4';

    // Initialize video player controller
    _videoPlayerController = VideoPlayerController.network(videoUrl);

    await _videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        allowPlaybackSpeedChanging: false,
        allowFullScreen: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: Chewie(
                  controller: _chewieController!,
                ),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => CartPopup(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            child: Icon(Icons.shopping_cart),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              widget.showProductPopup(context); // Call function to show product popup
              widget.updateProductInfo(widget.videoIndex); // Update product info based on video index
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class QuantitySelector extends StatefulWidget {
  final Function(int) onChanged;

  QuantitySelector({required this.onChanged});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (quantity > 0) {
              setState(() {
                quantity--;
                widget.onChanged(quantity);
              });
            }
          },
        ),
        Text(quantity.toString()),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              quantity++;
              widget.onChanged(quantity);
            });
          },
        ),
      ],
    );
  }
}
