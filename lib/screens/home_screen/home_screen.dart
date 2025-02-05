import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _logout() async {
    await context.read<AuthProvider>().signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.person),
        title: const Text('Recipe Explorer Pro'),
        actions: [
          GestureDetector(
            onTap: _logout,
            child: Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello ${authProvider.currentUser?.email ?? ""}",textAlign: TextAlign.left,),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                text: "Make your own food,",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: "\nStay at ",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  TextSpan(
                      text: "home",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange))
                ],
              ),
            ),
            // const RecipeSearchBar(),
            // Expanded(
            //   child: FutureBuilder(
            //     future: recipeProvider.loadRecipes(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Center(child: CircularProgressIndicator());
            //       }
            //       return ListView.builder(
            //         itemCount: recipeProvider.recipes.length,
            //         itemBuilder: (ctx, i) => RecipeCard(
            //           recipe: recipeProvider.recipes[i],
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
      //   ),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
