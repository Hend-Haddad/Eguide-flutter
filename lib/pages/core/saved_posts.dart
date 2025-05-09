import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/models/post.dart';
import 'package:eguideapp/servises/post_services.dart';
import 'package:eguideapp/widgets/post_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PostServices _postServices = PostServices();

class SavedPosts extends StatelessWidget {
  const SavedPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Saved Posts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _postServices.fetchSavedPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.separated(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Container(
                        height: 1,
                        color: theme.dividerColor,
                      ),
                      itemBuilder: (context, index) {
                        Post p = Post(
                          author: snapshot.data!.docs[index]["author"],
                          text: snapshot.data!.docs[index]["text"],
                          question: snapshot.data!.docs[index]["question"],
                          media: snapshot.data!.docs[index]["media"] ?? '',
                          addedAt: snapshot.data!.docs[index]["addedAt"],
                          liked: snapshot.data!.docs[index]["liked"],
                          comments: snapshot.data!.docs[index]["comments"],
                          savedPosts: snapshot.data!.docs[index]["savedPosts"],
                        );
                        
                        return PostWidget(
                          postIdx: index,
                          postId: snapshot.data!.docs[index].id,
                          post: p,
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading posts',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.secondary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}