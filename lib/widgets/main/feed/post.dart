import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socially/models/post_model.dart';

import 'package:socially/utils/constants/app_constants.dart';
import 'package:socially/utils/constants/colors.dart';
import 'package:socially/utils/functions/mood.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String currentUserId;

  const PostWidget({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
    required this.currentUserId,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(widget.post.datePublished);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: webBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  widget.post.profImage.isEmpty
                      ? profileImage
                      : widget.post.profImage,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: mainWhiteColor,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: mainWhiteColor.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              // ignore: deprecated_member_use
              color: mainPurpleColor.withOpacity(0.5),
            ),
            child: Text(
              "Feeling ${widget.post.mood.name} ${widget.post.mood.emoji}",
              style: TextStyle(color: mainWhiteColor),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.post.postCaption,
            // ignore: deprecated_member_use
            style: TextStyle(
              color: mainWhiteColor.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          if (widget.post.postImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.post.postImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border_outlined),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${widget.post.likes.toString()} likes",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              if (widget.post.userId == widget.currentUserId)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              _buildDialogOption(
                                context: context,
                                icon: Icons.edit,
                                text: "Edit",
                                onTap: () {},
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  // ignore: deprecated_member_use
                                  color: mainWhiteColor.withOpacity(0.5),
                                ),
                              ),
                              _buildDialogOption(
                                context: context,
                                icon: Icons.delete,
                                text: "Delete",
                                onTap: () {},
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.more_vert),
                ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildDialogOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: mainWhiteColor),
            const SizedBox(width: 12),
            Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: mainWhiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
