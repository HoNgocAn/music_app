import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/ui/discovery/discovery.dart';
import 'package:music_app/ui/home/viewmodel.dart';
import 'package:music_app/ui/login/login.dart';
import 'package:music_app/ui/now_playing/audio_player_manager.dart';
import 'package:music_app/ui/settings/settings.dart';
import 'package:music_app/ui/user/user.dart';

import '../../data/model/Song.dart';
import '../../service/auth_service.dart';
import '../now_playing/nowPlaying.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MusicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final List<Widget> _tabs = [
    const HomeTab(),
    const DiscoveryTab(),
    AccountTab(),
    const SettingsTab(),
  ];

  AuthService authService = AuthService();
  User? currentUser; // Khai báo currentUser mà chưa gán giá trị

  int _currentIndex = 0; // Theo dõi tab hiện tại

  logOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  void initState() {
    super.initState();

    // Kiểm tra người dùng đã đăng nhập hay chưa trong initState
    currentUser = authService.checkUserLoggedIn();

    if (currentUser != null) {
      print("User is logged in: ${currentUser!.email}");
    } else {
      print("No user is logged in.");
    }

    // Nếu muốn cập nhật UI khi user thay đổi
    setState(() {
      currentUser = authService.checkUserLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Music App"),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.album), label: "Discovery"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
          onTap: (int index) {
            if (index == 3) {
              // Kiểm tra nếu tab "Settings" được nhấn
              _showSettingsMenu(context);
            } else {
              setState(() {
                _currentIndex = index; // Cập nhật tab hiện tại
              });
            }
          },
        ),
        tabBuilder: (BuildContext context, int index) {
          return _tabs[_currentIndex]; // Hiển thị tab tương ứng
        },
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text("Settings Menu"),
        actions: [
          currentUser == null
              ? CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context); // Đóng bảng menu
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              const LoginView()), // Điều hướng đến trang Login
                    );
                  },
                  child: const Text("Login"),
                )
              : CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    logOut(context);
                  },
                  child: const Text("Logout"),
                ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context); // Đóng bảng menu
          },
          child: const Text("Cancel"),
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSong();
    observeData();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.songStream.close(); // Đóng StreamController
    AudioPlayerManager().dispose();
    super.dispose(); // Gọi dispose từ lớp cha
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  ListView getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
            color: Colors.grey, thickness: 1, indent: 24, endIndent: 24);
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(
      parent: this,
      song: songs[index],
    );
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 400,
              color: Colors.grey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Model Bottom Sheet"),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close Bottom Sheet"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void navigate(Song song) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NowPlaying(
        songs: songs,
        playingSong: song,
      );
    }));
  }
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({
    required this.parent,
    required this.song,
  });

  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: FadeInImage.assetNetwork(
          placeholder: "assets/img_err.png",
          image: song.image,
          width: 48,
          height: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/img_err.png",
              width: 48,
              height: 48,
            );
          },
        ),
      ),
      title: Text(
        song.title,
      ),
      subtitle: Text(song.artist),
      trailing: IconButton(
          onPressed: () {
            parent.showBottomSheet();
          },
          icon: const Icon(Icons.more_horiz)),
      onTap: () {
        parent.navigate(song);
      },
    );
  }
}
