import 'package:day_25/helper/helper.dart';
import 'package:flutter/material.dart';

import '../example_data.dart';
import '../helper/colors.dart';

/// 每一個 Category Section 的樣子。
class CategorySection extends StatelessWidget {
  TextTheme _textTheme(context) => Theme.of(context).textTheme;

  const CategorySection({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16),
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTileHeader(context),
          _buildFoodTileList(context),
        ],
      ),
    );
  }

  /// Section Title
  Widget _buildFoodTileList(BuildContext context) {
    return Column(
      children: List.generate(
        category.foods.length,
        (index) {
          final food = category.foods[index];
          bool isLastIndex = index == category.foods.length - 1;
          return _buildFoodTile(
            food: food,
            context: context,
            isLastIndex: isLastIndex,
          );
        },
      ),
    );
  }

  /// FSection Header
  Widget _buildSectionTileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _sectionTitle(context),
        const SizedBox(height: 8.0),
        category.subtitle != null
            ? _sectionSubtitle(context)
            : const SizedBox(),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Section Title 的 title
  Widget _sectionTitle(BuildContext context) {
    return Row(
      children: [
        if (category.isHotSale) _buildSectionHotSaleIcon(),
        Text(
          category.title,
          style: _textTheme(context).headline6,
          strutStyle: Helper.buildStrutStyle(_textTheme(context).headline6),
          // strutStyle: Helper.buildStrutStyle(_textTheme(context).headline6),
        )
      ],
    );
  }

  /// section Title 的 subTitle
  Widget _sectionSubtitle(BuildContext context) {
    return Text(
      category.subtitle!,
      style: _textTheme(context).subtitle2,
      strutStyle: Helper.buildStrutStyle(_textTheme(context).subtitle2),
    );
  }

  /// Section body 的 Food 樣式。
  Widget _buildFoodTile({
    required BuildContext context,
    required bool isLastIndex,
    required Food food,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFoodDetail(food: food, context: context),
            _buildFoodImage(food.imageUrl),
          ],
        ),
        !isLastIndex ? const Divider(height: 16.0) : const SizedBox(height: 8.0)
      ],
    );
  }

  /// food Image
  Widget _buildFoodImage(String url) {
    return FadeInImage.assetNetwork(
      placeholder: 'images/transparent.png',
      image: url,
      width: 64,
    );
  }

  /// food Detail
  Widget _buildFoodDetail({
    required BuildContext context,
    required Food food,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(food.name, style: _textTheme(context).subtitle1),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              "特價" + food.price + " ",
              style: _textTheme(context).caption,
              strutStyle: Helper.buildStrutStyle(_textTheme(context).caption),
            ),
            Text(
              food.comparePrice,
              strutStyle: Helper.buildStrutStyle(_textTheme(context).caption),
              style: _textTheme(context)
                  .caption
                  ?.copyWith(decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(width: 8.0),
            if (food.isHotSale) _buildFoodHotSaleIcon(),
          ],
        ),
      ],
    );
  }

  /// Section HotSale Icon
  Widget _buildSectionHotSaleIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 4.0),
      child: Icon(
        Icons.whatshot,
        color: scheme.primary,
        size: 20.0,
      ),
    );
  }

  /// Food HotSale Icon
  Widget _buildFoodHotSaleIcon() {
    return Container(
      child: Icon(Icons.whatshot, color: scheme.primary, size: 16.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}
