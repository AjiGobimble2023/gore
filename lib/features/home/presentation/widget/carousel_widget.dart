import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gokreasi_new/features/home/presentation/bloc/data/data_bloc.dart';
import '../../model/carousel_model.dart';
import '../../../../core/config/extensions.dart';
import '../../../../core/shared/widget/loading/shimmer_widget.dart';
import '../../../../core/shared/widget/image/custom_image_network.dart';
import '../../../../core/shared/widget/exception/refresh_exception_widget.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({Key? key}) : super(key: key);

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentImageIndex = 0;
  late Future<List<CarouselModel>> _fetchCarousel;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];

    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    // Membuat dan memicu event untuk memuat data Carousel saat initState
    context.read<DataBloc>().add(LoadCarouselEvent());
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataError) {
          return _buildContainer(
            deviceSize,
            RefreshExceptionWidget(
              message: state.error,
              onTap: () {
                // Memicu event untuk memuat ulang data Carousel
                context.read<DataBloc>().add(LoadCarouselEvent());
              },
            ),
          );
        } else {
          final List<CarouselModel> listCarousel = state.items;

          if (listCarousel.isNotEmpty) {
            return _buildCarousel(listCarousel);
          } else {
            return _buildContainer(
              deviceSize,
              RefreshExceptionWidget(
                message: 'Tidak ada data Carousel.',
                onTap: () {
                  // Memicu event untuk memuat ulang data Carousel
                  context.read<DataBloc>().add(LoadCarouselEvent());
                },
              ),
            );
          }
        }
      },
    );
  }

  Widget _buildCarousel(List<CarouselModel> listCarousel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: (context.isMobile) ? 64 / 18 : 6,
            autoPlayCurve: Curves.easeOutCubic,
            pageSnapping: true,
            pauseAutoPlayOnTouch: true,
            viewportFraction: (context.isMobile) ? 0.8 : 0.5,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) =>
                setState(() => _currentImageIndex = index),
          ),
          items: map<Widget>(
            listCarousel,
            (index, carouselModel) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: max(4, context.dp(4)),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    (context.isMobile) ? context.dp(12) : context.dp(10),
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    (context.isMobile) ? context.dp(12) : context.dp(10),
                  ),
                ),
                child: CustomImageNetwork.rounded(
                  carouselModel.namaFile,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(
                    (context.isMobile) ? context.dp(12) : context.dp(10),
                  ),
                ),
              ),
            ),
          ).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(
            listCarousel,
            (index, carouselModel) => AnimatedContainer(
              height: (context.isMobile) ? context.dp(8) : 14,
              width: _currentImageIndex == index
                  ? context.dp(20)
                  : (context.isMobile)
                      ? context.dp(8)
                      : 14,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              margin: EdgeInsets.only(
                top: (context.isMobile) ? max(6, context.dp(6)) : 14,
                left: (context.isMobile) ? max(4, context.dp(4)) : 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(max(30, context.dp(30))),
                color: _currentImageIndex == index
                    ? context.secondaryColor
                    : context.secondaryColor.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContainer(Size deviceSize, [Widget? refreshWidget]) {
    return AspectRatio(
      aspectRatio: (context.isMobile) ? 3 / 1 : 5,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: context.dp(8)),
        decoration: BoxDecoration(
          color: context.background.withOpacity(0.34),
          borderRadius: BorderRadius.circular(
            (context.isMobile) ? max(12, context.dp(12)) : context.dp(10),
          ),
        ),
        child: refreshWidget,
      ),
    );
  }
}
