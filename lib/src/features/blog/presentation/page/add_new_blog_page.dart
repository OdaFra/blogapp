import 'dart:io';

import 'package:blogapp/src/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogapp/src/core/common/widgets/loader.dart';
import 'package:blogapp/src/core/utils/show_snackbar.dart';
import 'package:blogapp/src/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogapp/src/features/blog/presentation/page/blog_page.dart';
import 'package:blogapp/src/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/pick_image.dart';

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

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
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
        title: const Text('Add New Blog'),
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
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(
              child: Loader(),
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
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
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
                                      'Select your image',
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
                        children: [
                          'Technology',
                          'Programming',
                          'Entertainment',
                          'Business',
                          'Science',
                          'Sports'
                        ]
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
                                            ColorTheme.gradient2)
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
                    BlogEditor(
                        controller: titleControler, hintext: 'Blog Title'),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentControler,
                      hintext: 'Blog content',
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
    if (formKey.currentState!.validate() &&
        selectTopics.isNotEmpty &&
        image != null) {
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
}
