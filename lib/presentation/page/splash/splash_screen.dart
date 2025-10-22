import 'package:flutter/material.dart';
          import 'package:lottie/lottie.dart';
          import 'package:go_router/go_router.dart';

          class SplashScreen extends StatefulWidget {
            const SplashScreen({super.key});

            @override
            State<SplashScreen> createState() => _SplashScreenState();
          }

          class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
            late final AnimationController _controller;

            @override
            void initState() {
              super.initState();
              _controller = AnimationController(vsync: this);
              _controller.addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  context.go('/home');
                }
              });
            }

            @override
            void dispose() {
              _controller.dispose();
              super.dispose();
            }

       @override
       Widget build(BuildContext context) {
         return Scaffold(
           body: SizedBox.expand(
             child: Lottie.asset(
               'assets/animations/halloween_splash_screen.json',
               controller: _controller,
               fit: BoxFit.cover,
               onLoaded: (composition) {
                 _controller
                   ..duration = composition.duration
                   ..forward();
               },
             ),
           ),
         );
       }
          }