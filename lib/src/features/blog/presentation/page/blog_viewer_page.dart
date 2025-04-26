import 'package:blogapp/src/core/constants/constants.dart';
import 'package:blogapp/src/core/theme/color_theme.dart';
import 'package:blogapp/src/core/utils/calculate_reading_time.dart';
import 'package:blogapp/src/core/utils/format_date.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;
  const BlogViewerPage({
    super.key,
    required this.blog,
  });

  static router(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista del blog'),
        elevation: 0,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título del blog
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Autor y fecha
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      blog.posterName ?? 'Autor desconocido',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      formatDateBydMMMYYYY(blog.updatedAt),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.timer_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${calculateReadingTime(blog.content)} min',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Imagen del blog
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    blog.imageUrl,
                    height: MediaQuery.of(context).size.height * 0.45 ,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        color: ColorTheme.backgroundColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorTheme.gradient1,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Error al cargar la imagen'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (blog.topics.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: blog.topics
                        .map((topic) => Chip(
                              avatar: Constants.topicIcons.containsKey(topic)
                                  ? Icon(
                                      Constants.topicIcons[topic],
                                      size: 18,
                                      color: Colors.white,
                                    )
                                  : null,
                              label: Text(
                                topic,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              backgroundColor: Constants.topicColors[topic] ??
                                  Colors.grey[700],
                              elevation: 1,
                              shadowColor: Colors.black.withOpacity(0.2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.8,
                                ),
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),

                const SizedBox(height: 20),

                // Contenido del blog
                Text(
                  blog.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
