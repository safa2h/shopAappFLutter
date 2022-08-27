import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/data/comment.dart';
import 'package:nike_store/data/repository/commet_repository.dart';
import 'package:nike_store/ui/product/comment/bloc/comment_bloc.dart';
import 'package:nike_store/ui/widgets/error_widget.dart';

class CommentList extends StatelessWidget {
  const CommentList({Key? key, required this.productId}) : super(key: key);
  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CommentBloc(commentRepository);
        bloc.add(CommentStarted(productId));
        return bloc;
      },
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state is CommentSuccess) {
            return SliverList(
                delegate: SliverChildBuilderDelegate(
              ((context, index) {
                return CommentItem(commentEntity: state.comments[index]);
              }),
              childCount: state.comments.length,
            ));
          }
          if (state is CommentLoading) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is CommentError) {
            return SliverToBoxAdapter(
              child: ErrorWidgetCustom(
                  errorMessage: state.appException.message,
                  tapCallback: () {
                    BlocProvider.of<CommentBloc>(context)
                        .add(CommentStarted(productId));
                  }),
            );
          } else {
            throw Exception('Unknown state');
          }
        },
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    Key? key,
    required this.commentEntity,
  }) : super(key: key);
  final CommentEntity commentEntity;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200)),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                commentEntity.title,
                style: themeData.textTheme.headline6,
              ),
              Text(
                commentEntity.date,
                style: themeData.textTheme.caption,
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            commentEntity.email,
            style: themeData.textTheme.caption,
          ),
          SizedBox(height: 8),
          Text(commentEntity.content),
        ],
      ),
    );
  }
}
