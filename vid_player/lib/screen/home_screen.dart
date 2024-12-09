import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: video != null
            ? _VideoPlayer(
                video: video!,
                onAnotherVideoPicked: onLogoTap,
              )
            : _VideoSelector(
                onLogoTap: onLogoTap,
              ));
  }


  onLogoTap() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    setState(() {
      this.video = video;
    });
    print(video);
  }
}




class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'asset/image/logo.png',
      ),
    );
  }
}




class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 32.0,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VIDEO',
          style: textStyle,
        ),
        Text(
          'PLAYER',
          style: textStyle.copyWith(
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}





class _VideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onAnotherVideoPicked;

  const _VideoPlayer({
    required this.onAnotherVideoPicked,
    required this.video,
    super.key,
  });

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  bool showIcons = true;
  late VideoPlayerController videoPlayerController;


  //late는 지금 초기화는 안할건데, 사용하기전에는 반드시 초기화 해놓을거다.

  @override
  void initState() {
    super.initState();
    initializeController();
  }
  ///새로운 비디오를 선택하고싶을때, videoPlayerController 변수가 바뀌었음에도, initState()를 한번 더 하지않고, 이미 할당되어있는 변수를 자동으로 찾아서 실행하기때문에,
  ///상태가 변경도었다는 didUpdateWidget라이프사이클을 선언하여, 다시 controller 초기화를 해주어야한다. oldWidget = 삭제된, 바꾸기전 비디오 콘트롤러, widget = 새로운 비디오 콘트롤러
  ///두 컨트롤러의 경로가 다를경우, 다른 비디오 이기떄문에 컨트롤러를 다시 이니셜라이즈 하겠다.

  @override
  didUpdateWidget(covariant _VideoPlayer oldWidget){
    super.didUpdateWidget(oldWidget);

    if(oldWidget.video.path!=widget.video.path){
      initializeController();
    }
  }

  initializeController() async {
    videoPlayerController = VideoPlayerController.file(
      File(
        widget.video.path,
      ),
    );

    await videoPlayerController.initialize();
    videoPlayerController.addListener(() {
      ///동영상에 변화가 있을때 마다 무언가 변화를 주려면,addListener()를 통해, setstate로 build함수를 계속 재실행 시켜주면 슬라이더가 동영상이 진행될수록
      ///변화가 생긴다.
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          showIcons=!showIcons;
        });
      },
      child: Center(
          child: AspectRatio(
        aspectRatio: videoPlayerController.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              videoPlayerController,
            ),
            if(showIcons)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
            ),

            ///Align자리
            if(showIcons)
            _PlayButtons(
              onReversePressed: onReversePressed,
              onPlayPressed: onPlayPressed,
              onForwardPressed: onForwardPressed,
              isPlaying: videoPlayerController.value.isPlaying,
            ),
            _Bottom(
              position: videoPlayerController.value.position,
              maxPostion: videoPlayerController.value.duration,
              onSliderChanged: onSliderChanged,
            ),
            if(showIcons)
            _PickAnotherVideo(
              onPressed: widget.onAnotherVideoPicked,
            ),

          ],
        ),
      )),
    );
  }

  onSliderChanged(double val){
    final position = Duration(seconds: val.toInt());
    videoPlayerController.seekTo(position);
  }

  onReversePressed() {
    final currentPosition = videoPlayerController.value.position;

    Duration position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoPlayerController.seekTo(position);
  }

  onPlayPressed() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
    setState(() {});
  }

  onForwardPressed() {
    final maxPosition = videoPlayerController.value.duration;
    final currentPosition = videoPlayerController.value.position;

    Duration position = maxPosition;

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoPlayerController.seekTo(position);
  }
}





class _VideoSelector extends StatelessWidget {
  final VoidCallback onLogoTap;

  const _VideoSelector({required this.onLogoTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A7C),
          Color(0XFF000118),
        ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onLogoTap,
          ),
          SizedBox(
            height: 28.0,
          ),
          _Title(),
        ],
      ),
    );
  }
}





class _PlayButtons extends StatelessWidget {
  final VoidCallback onReversePressed;
  final VoidCallback onPlayPressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _PlayButtons({
    required this.onReversePressed,
    required this.onPlayPressed,
    required this.onForwardPressed,
    required this.isPlaying,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            color: Colors.white,
            onPressed: onReversePressed,
            icon: Icon(Icons.rotate_left),
          ),
          IconButton(
            color: Colors.white,
            onPressed: onPlayPressed,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          IconButton(
            color: Colors.white,
            onPressed: onForwardPressed,
            icon: Icon(Icons.rotate_right),
          ),
        ],
      ),
    );
  }
}







class _Bottom extends StatelessWidget {
  final Duration position;
  final Duration maxPostion;
  final ValueChanged<double> onSliderChanged;

  const _Bottom({
    required this.onSliderChanged,
    required this.position,
    required this.maxPostion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: [
            Text(
              '${position.inMinutes.toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                value: position.inSeconds.toDouble(),
                max: maxPostion.inSeconds.toDouble(),
                onChanged: onSliderChanged,
              ),
            ),
            Text(
              '${maxPostion.inMinutes.toString().padLeft(2, '0')}:${(maxPostion.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}








class _PickAnotherVideo extends StatelessWidget {
  final VoidCallback onPressed;

  const _PickAnotherVideo({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        color: Colors.white,
        onPressed: onPressed,
        icon: Icon(Icons.photo_camera_back),
      ),
    );
  }
}
