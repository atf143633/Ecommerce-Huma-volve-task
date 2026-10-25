import 'package:ecommerce_app_huma_volve/features/home/presentaton/view_model/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentaton/view_model/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme.dart';
import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  late final ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onListen);
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onListen)
      ..dispose();
    super.dispose();
  }

  void _onListen() {
    if (scrollController.hasClients &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: AppTheme.primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.person_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Explore',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (previous, current) {
                        if (current is ProductsLoading ||
                            current is ProductsSuccess ||
                            current is ProductsError ||
                            current is ProductLoadingError ||
                            current is ProductLoadingMore) {
                          return false;
                        } else {
                          return true;
                        }
                      },
                      builder: (BuildContext context, state) {
                        if (state is CategoriesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is CategoiresError) {
                          return Center(
                            child: Column(
                              children: [
                                Text(state.errorMassege),
                                TextButton(
                                  onPressed: context
                                      .read<HomeCubit>()
                                      .loadHomeData,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (state is CategoiresSuccess) {
                          final categories = state.categories;
                          if (categories.isEmpty) {
                            return const SizedBox(
                              height: 44,
                              child: Center(child: Text('No categories found')),
                            );
                          }
                          return SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return CategoryChip(
                                  label: category.name,
                                  isSelected: _selectedCategoryIndex == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryIndex = index;
                                    });
                                    context
                                        .read<HomeCubit>()
                                        .getProductCategories(category.id);
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (previous, current) {
                if (current is ProductLoadingError ||
                    current is ProductLoadingMore) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is ProductsError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          Text(state.errorMassege),
                          TextButton(
                            onPressed: () {
                              final categoryId = context
                                  .read<HomeCubit>()
                                  .selectedCategory;
                              if (categoryId != null) {
                                context.read<HomeCubit>().getProductCategories(
                                  categoryId,
                                );
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is ProductsSuccess) {
                  final products = state.products;
                  if (products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('No products found')),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ProductCard(productModel: products[index]);
                      }, childCount: products.length),
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
              },
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is ProductLoadingMore) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                } else if (state is ProductLoadingError) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            Text(state.errorMassege),
                            TextButton(
                              onPressed: context
                                  .read<HomeCubit>()
                                  .loadMoreProducts,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(child: SizedBox(height: 24));
                }
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
