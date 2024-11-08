import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_manager/screens/primaryScreens/compute_filter_attributes.dart';
import 'package:music_manager/screens/primaryScreens/pincode_view.dart';
import 'package:music_manager/screens/primaryScreens/song_listview.dart';
import 'package:music_manager/services/model/app_configuration.dart';
import 'package:music_manager/services/model/app_user.dart';
import 'package:music_manager/services/model/songs_database.dart';
import 'package:music_manager/shared/theme_constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:music_manager/services/providers/app_bg_gradient_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Bottom Navigation bar index, the application starts with the window specified here
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    debugPrint(">> Value inside onItemTapped: $index");
    setState(() {
      _selectedIndex = index;
    });
  }

  // if the field 'deleteDB' is set to true in firestore document 'AppData'
  // this function is triggered that deletes the local database
  void _databaseDeletionInitiatedRemotely() async {
    debugPrint(">>> Remote Database deletion initiated.");
    await SongsDatabase.instance.deleteSongsDB('songs.db', showToastMsg: true);
  }

  // Bottom navigation bar pages
  final List<Widget> _pages = <Widget>[
    // List View
    SongsListView(),

    // Refine View Widget
    Center(
      child: ComputeFilterAttributesFromLocalDB(),
    ),

    // Get Data widget
    // commenting the operations view - if required for testing uncomment the below line
    // OperationsAndConfigurationsView(),

    // commenting the Fetch Songs view - if required for testing uncomment the below code
    // // Fetch Songs List View Widget
    // Container(
    //   padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
    //         child: Text(
    //           "Songs",
    //           style: CustomTextStyles.headingsTextStyle,
    //         ),
    //       ),
    //       // SizedBox(
    //       //   height: 5,
    //       // ),
    //       Expanded(
    //         child: FetchSongs_ListView(),
    //       )
    //     ],
    //   ),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    final appConfigData = Provider.of<AppConfiguration>(context);
    final userData = Provider.of<UserData>(context);

    if (appConfigData.deleteDB || userData.remotelyDeleteDB) {
      _databaseDeletionInitiatedRemotely();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 50,
        leading: IconButton(
          icon: const Image(
            // alignment: Alignment.topRight,
            // image: AssetImage('assets/gramophone_new.png'),
            image: AssetImage('assets/gramophone.png'),
            // fit: BoxFit.contain,
            // width: 100,
            // height: 75,
          ),
          onPressed: () {
            _navigateToSecurityPinScreen(context);
          },
        ),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Text("MusikQ",
            textAlign: TextAlign.start,
            style: GoogleFonts.berkshireSwash(
                fontWeight: FontWeight.w100,
                fontSize: 24,
                height: 1.2,
                color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: const [],
      ),
      body: Container(
        decoration: CustomBackgroundGradientStyles.applicationBackground(
            context.read<GradientBackgroundTheme>().bgThemeType),
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.queue_music_rounded,
              color: Colors.white,
              size: 25,
            ),
            label: 'Song List',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
              size: 25,
            ),
            label: 'Filter',
          ),

          // below widgets are commented, if required for testing then only uncomment them
          // // Operations View
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.subject_rounded,
          //     color: Colors.white,
          //     size: 25,
          //   ),
          //   label: 'Operations',
          // ),

          // // Fetch All Data
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.cloud_download_outlined,
          //     color: Colors.white,
          //     size: 25,
          //   ),
          //   label: 'Fetch',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedLabelStyle:
            GoogleFonts.josefinSans(color: Colors.white, fontSize: 14),
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        unselectedLabelStyle:
            GoogleFonts.josefinSans(color: Colors.white, fontSize: 12),
        unselectedItemColor: Color.fromARGB(255, 195, 195, 195),
      ),
    );
  }

  void _navigateToSecurityPinScreen(BuildContext context) {
    Navigator.of(context).push(PageTransition(
      type: PageTransitionType.scale,
      alignment: Alignment.bottomCenter,
      duration: Duration(milliseconds: 850),
      reverseDuration: Duration(milliseconds: 500),
      child: MultiProvider(providers: [
        Provider(create: (_) => Provider.of<AppConfiguration>(context)),
        Provider(create: (_) => Provider.of<UserData>(context)),
      ], child: SecurityPinView()),
    ));
  }
}
