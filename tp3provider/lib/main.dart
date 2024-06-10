import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Store Products',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    StoreScreen(),
    PlaceholderWidget(text: 'Voucher'),
    PlaceholderWidget(text: 'Wallet'),
    PlaceholderWidget(text: 'Settings'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Voucher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String text;

  const PlaceholderWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: TextStyle(fontSize: 24.0)),
    );
  }
}

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fetchProducts ketika StoreScreen diinisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: StoreAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StoreBanner(),
            SizedBox(height: 16.0),
            StoreCategories(),
            SizedBox(height: 16.0),
            BestSaleHeader(),
            SizedBox(height: 8.0),
            Expanded(
              child: productProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : productProvider.error != null
                      ? Center(child: Text(productProvider.error!))
                      : BestSaleProductList(products: productProvider.products),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.all(12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart_outlined),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: 10.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        child: Text(
                          '9+',
                          style: TextStyle(fontSize: 10.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoreBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('assets/background-banner.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#FASHION DAY',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            '80% OFF',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            'Discover fashion that suits your style',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {},
            child: Text('Check this out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 41, 9, 63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}

class StoreCategories extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.grid_view, 'label': 'Category'},
    {'icon': Icons.flight, 'label': 'Flight'},
    {'icon': Icons.receipt, 'label': 'Bill'},
    {'icon': Icons.language, 'label': 'Data plan'},
    {'icon': Icons.money, 'label': 'Top Up'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((category) {
          return Column(
            children: [
              Icon(
                category['icon'],
                size: 30.0,
                color: Colors.grey[700],
              ),
              SizedBox(height: 8.0),
              Text(
                category['label'],
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[700],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class BestSaleHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Best Sale Product',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'See more',
            style: TextStyle(
              color: Colors.green,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class BestSaleProductList extends StatelessWidget {
  final List<Product> products;

  const BestSaleProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: BestSaleProductCard(
            title: product.title,
            price: product.price,
            category: product.category,
            rating: product.rating,
            reviews: product.reviews,
            imageUrl: product.image,
          ),
        );
      },
    );
  }
}

class BestSaleProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String category;
  final double rating;
  final int reviews;
  final String imageUrl;

  const BestSaleProductCard({
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 120.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14.0),
                    SizedBox(width: 4.0),
                    Text(
                      '$rating | $reviews',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
