import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eguideapp/servises/post_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../utils/app_styles.dart';
import '../../widgets/post_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

PostServices _postServices = PostServices();

class _HomepageState extends State<Homepage> {
  late TextEditingController _searchController;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 4),
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Discover the country \n      Live like a native',
                        style: AppStyles.authTitleStyle),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: CupertinoSearchTextField(
                  backgroundColor: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  controller: _searchController,
                  placeholder: 'Search a question...',
                  onChanged: (value) {
                    setState(() {
                      _searchText = value.toLowerCase();
                    });
                  },
                ),
              ),
              SizedBox(height: 1),
              StreamBuilder<QuerySnapshot>(
                stream: _postServices.fetchAllPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final filteredPosts = snapshot.data!.docs.where((doc) {
                      final post = doc.data() as Map<String, dynamic>;
                      final question = post['question']?.toString().toLowerCase() ?? '';
                      final text = post['text']?.toString().toLowerCase() ?? '';
                      return question.contains(_searchText) || 
                             text.contains(_searchText);
                    }).toList();

                    if (filteredPosts.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text('No posts found',
                              style: TextStyle(color: Colors.white))),
                      );
                    }

                    return Expanded(
                      child: ListView.separated(
                        itemCount: filteredPosts.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        itemBuilder: (context, index) {
                          Post p = Post(
                            author: filteredPosts[index]["author"],
                            text: filteredPosts[index]["text"],
                            question: filteredPosts[index]["question"],
                            media: filteredPosts[index]["media"] ?? '',
                            addedAt: filteredPosts[index]["addedAt"],
                            liked: filteredPosts[index]["liked"],
                            comments: filteredPosts[index]["comments"],
                            savedPosts: filteredPosts[index]["savedPosts"],
                          );
                          
                          return PostWidget(
                            postIdx: index,
                            postId: filteredPosts[index].id,
                            post: p,
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading posts'));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}