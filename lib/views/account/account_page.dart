import 'package:flutter/material.dart';
import 'package:ta_ppb/views/widgets/info_card.dart';

const email = "Muhammadkaisan3@gmail.com";
const phone = "+62 877-7704-7415";
const Location = "Tanjung Barat, DKI Jakarta";

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('ta_ppb/assets/kakai.jpeg'),
            ),
            Text(
              "Muhammad Kaisan A.R.",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "BebasNeue",
              ),
            ),
            Text(
              "Passionate Learner",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
                fontFamily: "BebasNeue",
              ),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(color: Colors.white),
            ),
            InfoCard(
              text: "Phone",
              icon: Icons.phone,
              onPressed: () async {
                // Remove spaces from the phone number
                String removeSpacefromPhoneNumber = phone.replaceAll(' ', '');
                print(removeSpacefromPhoneNumber);
                // You can add further actions related to the phone number here
              },
            ),
          ],
        ),
      ),
    );
  }
}
