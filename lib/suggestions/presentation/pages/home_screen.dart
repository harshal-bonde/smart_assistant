import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_assistant/common/themes/app_theme.dart';
import 'package:smart_assistant/common/themes/theme_controller.dart';
import 'package:smart_assistant/navigation/application/controllers/navigation_controller.dart';
import 'package:smart_assistant/suggestions/application/controllers/suggestions_controller.dart';
import 'package:smart_assistant/suggestions/presentation/widgets/suggestion_card.dart';
import 'package:smart_assistant/suggestions/presentation/widgets/suggestion_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  late final SuggestionsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SuggestionsController>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _controller.loadMoreSuggestions();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    return _scrollController.offset >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeCtrl = Get.find<ThemeController>();
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const SuggestionShimmer();
        }

        if (_controller.errorMessage.value != null &&
            _controller.suggestions.isEmpty) {
          return _buildErrorView(context);
        }

        if (_controller.suggestions.isEmpty) {
          return _buildEmptyView(context);
        }

        return RefreshIndicator(
          color: AppColors.primaryStart,
          onRefresh: _controller.refreshSuggestions,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Gradient header
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).padding.top + 16,
                    20,
                    20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [AppColors.darkSurface, AppColors.darkBg]
                          : [
                              AppColors.primaryStart.withOpacity(0.05),
                              AppColors.lightBg,
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.primaryStart.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Smart Assistant',
                                style: theme.textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Obx(() => _ThemeToggle(
                                isDark: themeCtrl.isDark,
                                onTap: themeCtrl.toggleTheme,
                              )),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'What can I help\nyou with today?',
                        style: theme.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap a suggestion to start chatting',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              // Counter badge
              if (_controller.pagination.value != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primaryStart.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            '${_controller.suggestions.length} of ${_controller.pagination.value!.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Suggestion list
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= _controller.suggestions.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryStart,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final suggestion = _controller.suggestions[index];
                      return SuggestionCard(
                        suggestion: suggestion,
                        onTap: () {
                          Get.find<NavigationController>().changePage(1);
                        },
                      );
                    },
                    childCount: _controller.suggestions.length +
                        (_controller.isLoadingMore.value ? 1 : 0),
                  ),
                ),
              ),

              if (_controller.hasReachedMax)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : AppColors.lightDivider.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'You\'ve explored all suggestions!',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ),

              // Bottom padding for floating nav
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _controller.errorMessage.value ?? 'Please try again',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _controller.loadSuggestions,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text('No suggestions yet', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeToggle({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? AppColors.darkCard
        : AppColors.primaryStart.withOpacity(0.08);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) =>
              RotationTransition(turns: anim, child: child),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(isDark),
            size: 22,
            color: isDark ? AppColors.warning : AppColors.primaryStart,
          ),
        ),
      ),
    );
  }
}
