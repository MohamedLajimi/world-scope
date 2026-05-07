import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worldscope/core/widgets/app_error_widget.dart';
import 'package:worldscope/features/deep_dive/presentation/bloc/deep_dive/deep_dive_bloc.dart';
import 'package:worldscope/features/deep_dive/presentation/widgets/country_info_tab.dart';
import 'package:worldscope/features/deep_dive/presentation/widgets/news_tab.dart';
import 'package:worldscope/features/deep_dive/presentation/widgets/weather_tab.dart';

class DeepDiveTabs extends StatelessWidget {
  const DeepDiveTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Country'),
              Tab(text: 'Weather'),
              Tab(text: 'News'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<DeepDiveBloc, DeepDiveState>(
              builder: (context, state) {
                if (state is DeepDiveLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DeepDiveFailure) {
                  return AppErrorWidget(message: state.message);
                }
                if (state is! DeepDiveSuccess) {
                  return const SizedBox.shrink();
                }

                return TabBarView(
                  children: [
                    CountryInfoTab(state: state),
                    DeepDiveWeatherTab(state: state),
                    DeepDiveNewsTab(state: state),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
