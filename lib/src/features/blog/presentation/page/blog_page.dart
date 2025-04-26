import 'package:blogapp/src/core/common/widgets/loader.dart';
import 'package:blogapp/src/core/constants/constants.dart';
import 'package:blogapp/src/core/theme/color_theme.dart';
import 'package:blogapp/src/core/utils/show_snackbar.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogapp/src/features/blog/presentation/page/add_new_blog_page.dart';
import 'package:blogapp/src/features/blog/presentation/widgets/blog_card.dart';
import 'package:blogapp/src/features/blog/presentation/widgets/blog_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({super.key});
  static route() =>
      MaterialPageRoute(builder: (context) => const BlogListPage());

  @override
  State<BlogListPage> createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  String selectedTopic = '';
  List<Blog> allBlogs = [];

  @override
  void initState() {
    _fetchBlogs();
    super.initState();
  }

  void _fetchBlogs() {
    context.read<BlogBloc>().add(BlogFecthAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Blogs'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.refresh),
            onPressed: _fetchBlogs,
            tooltip: 'Recargar blogs',
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          // Actualizar lista cuando llegan nuevos datos
          if (state is BlogDisplaySuccess) {
            allBlogs = state.blogs;
          }

          // Filtrar blogs por topic seleccionado
          final filteredBlogs = selectedTopic.isEmpty
              ? allBlogs
              : allBlogs
                  .where((blog) => blog.topics.contains(selectedTopic))
                  .toList();

          return Column(
            children: [
              // Selector de topics
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TopicsTabBar(
                  allTopics: Constants.topics,
                  selectedTopic: selectedTopic,
                  onTopicSelected: (topic) {
                    setState(() {
                      selectedTopic = topic;
                    });
                  },
                ),
              ),
              // Lista de blogs
              Expanded(
                child: _buildBlogContent(state, filteredBlogs),
              ),
            ],
          );
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            AddNewBlogPage.router(),
          ).then((_) => _fetchBlogs());
        },
        child: const Icon(CupertinoIcons.add_circled),
      ),
    );
  }

  Widget _buildBlogContent(BlogState state, List<Blog> blogs) {
    if (state is BlogLoading && allBlogs.isEmpty) {
      return const Center(child: Loader());
    } else if (state is BlogFailure && allBlogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error al cargar blogs: ${state.error}'),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: _fetchBlogs,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else if (blogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.doc, size: 50, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              selectedTopic.isEmpty
                  ? 'No hay blogs disponibles'
                  : 'No hay blogs sobre $selectedTopic',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (selectedTopic.isNotEmpty)
              CupertinoButton(
                child: const Text('Mostrar todos'),
                onPressed: () {
                  setState(() {
                    selectedTopic = '';
                  });
                },
              ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final blog = blogs[index];
          return BlogCard(
            blog: blog,
            color: index % 2 == 0 ? ColorTheme.gradient1 : ColorTheme.gradient2,
          );
        },
      );
    }
  }
}
