import 'dart:io';

import 'package:blogapp/src/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogapp/src/core/common/widgets/loader.dart';
import 'package:blogapp/src/core/constants/constants.dart';
import 'package:blogapp/src/core/utils/image_handler.dart';
import 'package:blogapp/src/core/utils/show_snackbar.dart';
import 'package:blogapp/src/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogapp/src/features/blog/presentation/page/blog_page.dart';
import 'package:blogapp/src/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';

class AddNewBlogPage extends StatefulWidget {
  static router() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleControler = TextEditingController();
  final contentControler = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<String> selectTopics = [];
  File? image;
  bool isUploading = false;

  Future<void> selectImage() async {
    final selectedImage = await ImageHandler.selectAndCropImage(context);
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleControler.dispose();
    contentControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar un nuevo blog'),
        actions: [
          IconButton(
            onPressed: _uploadBlog,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            setState(() => isUploading = false);
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            // Mostrar feedback antes de navegar
            showSnackBar(context, '¡Blog publicado con éxito!',
                backgroundColor: Colors.green);
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushAndRemoveUntil(
                context,
                BlogListPage.route(),
                (route) => false,
              );
            });
          }
        },
        builder: (context, state) {
          if (isUploading || state is BlogLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loader(),
                  SizedBox(height: 20),
                  Text(
                    'Publicando tu blog...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => selectImage(),
                            child: DottedBorder(
                              color: ColorTheme.greyColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(20),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: const SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open_outlined, size: 50),
                                    SizedBox(height: 15),
                                    Text(
                                      'Selecciona una imagen',
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectTopics.contains(e)) {
                                      selectTopics.remove(e);
                                    } else {
                                      selectTopics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectTopics.contains(e)
                                        ? WidgetStateProperty.all(
                                            ColorTheme.gradient1)
                                        : WidgetStateProperty.all(
                                            ColorTheme.backgroundColor),
                                    side: const BorderSide(
                                        color: ColorTheme.borderColor),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    BlogEditor(controller: titleControler, hintext: 'Titulo'),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentControler,
                      hintext: 'Contenido',
                      minLines: 5,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _uploadBlog() {
    if (!formKey.currentState!.validate()) {
      showSnackBar(context, 'Por favor completa todos los campos requeridos');
      return;
    }

    if (selectTopics.isEmpty) {
      showSnackBar(context, 'Por favor selecciona al menos un topico');
      return;
    }

    if (image == null) {
      showSnackBar(context, 'Por favor selecciona una imagen');
      return;
    }

    setState(() => isUploading = true);

    final posterId = context.read<AppUserCubit>().state as AppUserLoggedIn;
    context.read<BlogBloc>().add(BlogUpload(
          posterId: posterId.user.id,
          title: titleControler.text.trim(),
          content: contentControler.text.trim(),
          image: image!,
          topics: selectTopics,
        ));
  }
}
