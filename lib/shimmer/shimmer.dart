import 'package:flutter/material.dart';
class NewsCardSkelton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Skeleton(height: 60, width: 60),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Skeleton(width: 80),
              const SizedBox(height: 16 / 2),
              const Skeleton(),
              const SizedBox(height: 16 / 2),
              const Skeleton(),
              const SizedBox(height: 16 / 2),
              Row(
                children: const [
                  Expanded(
                    child: Skeleton(),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Skeleton(),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }}
class Skeleton extends StatelessWidget {
  final double?  height, width;
  const Skeleton({  this.height, this.width})  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(5 / 2),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.09),
          borderRadius:
          const BorderRadius.all(Radius.circular(5))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({  this.size = 24})  ;

  final double  size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}