import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worldscope/core/widgets/app_error_widget.dart';
import 'package:worldscope/features/deep_dive/presentation/bloc/deep_dive/deep_dive_bloc.dart';

class DeepDiveNewsTab extends StatelessWidget {
  const DeepDiveNewsTab({super.key, required this.state});

  final DeepDiveSuccess state;

  @override
  Widget build(BuildContext context) {
    if (state.newsError != null) {
      return AppErrorWidget(message: state.newsError!);
    }
    if (state.news.isEmpty) {
      return const Center(child: Text('No news available'));
    }

    return ListView.builder(
      itemCount: state.news.length,
      itemBuilder: (context, index) {
        final article = state.news[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(article.title),
            subtitle: Text(article.source),
            trailing: const Icon(Icons.open_in_new_rounded),
            onTap: () async {
              final uri = Uri.tryParse(article.url);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        );
      },
    );
  }
}
