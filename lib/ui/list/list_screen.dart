import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store/common/consts.dart';
import 'package:nike_store/data/product.dart';
import 'package:nike_store/data/repository/product_reopsitory.dart';
import 'package:nike_store/ui/list/bloc/list_bloc.dart';
import 'package:nike_store/ui/widgets/error_widget.dart';
import 'package:nike_store/ui/widgets/product_item.dart';

class ListScreen extends StatefulWidget {
  ListScreen({Key? key, required this.sort}) : super(key: key);
  final int sort;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

enum ViewType { grid, list }

class _ListScreenState extends State<ListScreen> {
  ListBloc? listBloc;
  ViewType viewType = ViewType.grid;
  @override
  void dispose() {
    // TODO: implement dispose
    listBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('کفش های ورزشی'),
        ),
        body: BlocProvider<ListBloc>(
          create: (context) {
            listBloc = ListBloc(productRepository)
              ..add(ListStarted(widget.sort));

            return listBloc!;
          },
          child: BlocBuilder<ListBloc, ListState>(
            builder: (context, state) {
              if (state is ListSuccess) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 1, color: Colors.grey)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ]),
                      height: 56,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 400,
                                        child: Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                'انتخاب مرتب سازی',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                    itemCount:
                                                        state.sortName.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var selectedsort =
                                                          state.sort;
                                                      return InkWell(
                                                        onTap: () {
                                                          listBloc!.add(
                                                              ListStarted(
                                                                  index));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: SizedBox(
                                                            height: 32,
                                                            child: Row(
                                                              children: [
                                                                Text(state
                                                                        .sortName[
                                                                    index]),
                                                                SizedBox(
                                                                  width: 30,
                                                                ),
                                                                if (index ==
                                                                    selectedsort)
                                                                  Icon(
                                                                    CupertinoIcons
                                                                        .check_mark_circled_solid,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(CupertinoIcons.sort_down),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'مرتب سازی',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                      Text(ProductSort.names[widget.sort])
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              width: 1,
                              decoration: BoxDecoration(
                                  color: Colors.grey, border: Border.all()),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  viewType = viewType == ViewType.grid
                                      ? ViewType.list
                                      : ViewType.grid;
                                });
                              },
                              icon: Icon(viewType == ViewType.grid
                                  ? CupertinoIcons.square_grid_2x2
                                  : CupertinoIcons.square))
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          physics: scrollPhysic,
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return ProductItem(
                                product: product,
                                borderRadius: BorderRadius.circular(0));
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 3,
                                  crossAxisCount:
                                      viewType == ViewType.grid ? 2 : 1,
                                  childAspectRatio: 0.65)),
                    ),
                  ],
                );
              } else if (state is ListLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ListError) {
                return ErrorWidgetCustom(
                    errorMessage: state.appException.message,
                    tapCallback: () {});
              } else {
                throw Exception('state not valid');
              }
            },
          ),
        ));
  }
}
