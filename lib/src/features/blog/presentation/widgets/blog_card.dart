import 'package:blogapp/src/core/constants/constants.dart';
import 'package:blogapp/src/core/theme/color_theme.dart';
import 'package:blogapp/src/core/utils/calculate_reading_time.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/presentation/page/blog_viewer_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  final VoidCallback onDelete; // Nueva propiedad para manejar la eliminación

  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
    required this.onDelete, // Añade esta línea
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, BlogViewerPage.router(blog)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.18,
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          // Usamos Stack para superponer el botón de eliminar
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: blog.topics
                            .map(
                              (topic) => Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: Chip(
                                  label: Text(
                                    topic,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor:
                                      Constants.topicColors[topic] ??
                                          Colors.grey[700],
                                  side: const BorderSide(
                                    color: ColorTheme.borderColor,
                                    width: 0.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${calculateReadingTime(blog.content)} min read',
                  style: const TextStyle(
                    color: ColorTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Botón de eliminar en la esquina superior derecha
            Positioned(
              top: 0,
              right: 0,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmationDialog(context);
                  } else if (value == 'edit') {
                    // Lógica para editar
                  }
                },
                itemBuilder: (context) => [
                  // const PopupMenuItem(
                  //   value: 'edit',
                  //   child: Text('Editar'),
                  // ),
                  const PopupMenuItem(
                    value: 'delete',
                    child:
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar este blog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(); // Ejecuta la función de eliminación
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Blog eliminado correctamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
