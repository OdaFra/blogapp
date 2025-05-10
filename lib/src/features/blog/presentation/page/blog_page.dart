import 'package:blogapp/src/core/core.dart';
import 'package:blogapp/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/src/features/auth/presentation/pages/pages.dart';
import 'package:blogapp/src/features/blog/domain/entities/blog.dart';
import 'package:blogapp/src/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogapp/src/features/blog/presentation/page/add_new_blog_page.dart';
import 'package:blogapp/src/features/blog/presentation/page/blog_viewer_page.dart';
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
  String _sortOrder = 'recent';

  @override
  void initState() {
    _fetchBlogs();
    super.initState();
  }

  void _fetchBlogs() {
    context.read<BlogBloc>().add(BlogFecthAllBlogs());
  }

  List<Blog> _sortBlogs(List<Blog> blogs) {
    final sortedBlogs = List<Blog>.from(
        blogs); // Crear una copia de la lista original para no modificarla directamente

    if (_sortOrder == 'recent') {
      sortedBlogs.sort((a, b) =>
          b.updatedAt.compareTo(a.updatedAt)); // Más recientes primero
    } else {
      sortedBlogs.sort(
          (a, b) => a.updatedAt.compareTo(b.updatedAt)); // Más antiguos primero
    }

    return sortedBlogs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Blogs'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.refresh),
            onPressed: _fetchBlogs,
            tooltip: 'Recargar blogs',
          ),
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onSelected: (value) {
              setState(() {
                _sortOrder = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'recent',
                child: Text('Recientes'),
              ),
              const PopupMenuItem(
                value: 'oldest',
                child: Text('Antiguos'),
              ),
            ],
            icon: const Icon(CupertinoIcons.sort_down),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogDeleteSuccess) {
            showSnackBar(context, 'Blog eliminado con éxito');
          }
        },
        builder: (context, state) {
          if (state is BlogDisplaySuccess) {
            allBlogs = _sortBlogs(state.blogs);
          }

          final filteredBlogs = selectedTopic.isEmpty
              ? allBlogs
              : allBlogs
                  .where((blog) => blog.topics.contains(selectedTopic))
                  .toList();

          return Column(
            children: [
              // Selector de topics y ordenación
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
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
                  ],
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
            AppTransitions.sharedAxisTransition(const AddNewBlogPage()),
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
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              AppTransitions.sharedAxisTransition(BlogViewerPage(blog: blog)),
            ),
            child: BlogCard(
              blog: blog,
              color:
                  index % 2 == 0 ? ColorTheme.gradient1 : ColorTheme.gradient2,
              onDelete: () {
                context.read<BlogBloc>().add(DeleteBlog(blog.id));
              },
            ),
          );
        },
      );
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        final user = state is AppUserLoggedIn ? state.user : null;

        return Drawer(
          backgroundColor: ColorTheme.backgroundColor,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: ColorTheme.gradient1,
                ),
                accountName: Text(user?.name ?? 'Invitado'),
                accountEmail: Text(user?.email ?? 'No has iniciado sesión'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: ColorTheme.backgroundColor,
                  child: Text(
                    user?.email.isNotEmpty == true
                        ? user!.email[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  Navigator.pop(context);
                  _logout(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              navigator.pop();

              try {
                // 1. Disparar el logout a través del Bloc
                context.read<AuthBloc>().add(AuthLogout());

                // 2. Navegar al login limpiando el stack
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );

                showSnackBar(context, 'Sesión cerrada correctamente');
              } catch (e) {
                showSnackBar(context, 'Error al cerrar sesión: $e');
              }
            },
            child: const Text('Cerrar sesión',
                style: TextStyle(color: ColorTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
