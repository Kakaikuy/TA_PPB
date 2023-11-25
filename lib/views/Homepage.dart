import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ta_ppb/views/sayur_page.dart';
import 'package:ta_ppb/views/buah_page.dart';
import 'package:ta_ppb/views/widgets/produk_card.dart';
import 'gacha_page.dart';
import 'search_page.dart';
import 'account/account_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.food_bank_outlined),
            SizedBox(width: 10),
            Text('Buahpedia'),
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: GNav(
        gap: 8,
        padding: EdgeInsets.all(16),
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.amberAccent,
        tabBackgroundColor: Colors.grey.shade800,
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.card_giftcard_sharp,
            text: 'Gacha',
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.account_circle,
            text: 'Account',
          ),
        ],
        selectedIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        // Tombol ProdukCard yang dapat ditekan
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigasi ke halaman baru (ganti dengan halaman yang diinginkan)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuahPage(), // Ganti dengan halaman yang diinginkan
                  ),
                );
              },
              child: ProdukCard(
                title: 'Buah-Buahan',
                thumbnailUrl:
                    'https://cdn0-production-images-kly.akamaized.net/Z0dnxL4CcaIF9CSKYQ3ai-CiL2A=/800x450/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/4517425/original/082526500_1690526212-assorted-mixed-fruits.jpg',
              ),
            ),
          ],
        );
      case 1:
        return GachaPage();
      case 2:
        return SearchPage();
      case 3:
        return AccountPage();
      case 4:
        return SayurPage();
      case 5:
        return BuahPage();
      default:
        return SizedBox.shrink();
    }
  }
}