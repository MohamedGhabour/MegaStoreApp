import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../models/category.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../widgets/category_image_card.dart';
import '../../../widgets/custom_text_field.dart';
import '../provider/category_provider.dart';

class CategorySubmitForm extends StatelessWidget {
  final Category? category;

  const CategorySubmitForm({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final catProvider = context.categoryProvider;
    catProvider.setDataForUpdateCategory(category);

    return SingleChildScrollView(
      child: Form(
        key: catProvider.addCategoryFormKey,
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(defaultPadding),
              Consumer<CategoryProvider>(
                builder: (context, provider, child) {
                  return CategoryImageCard(
                    labelText: "Image",
                    imageFile: provider.selectedImage,
                    imageUrlForUpdateImage: category?.image == null
                        ? category?.image
                        : '$MAIN_URL${category!.image}',
                    onTap: () {
                      provider.pickImage();
                    },
                  );
                },
              ),
              const Gap(defaultPadding),
              CustomTextField(
                controller: catProvider.categoryNameCtrl,
                labelText: 'Category Name',
                onSave: (val) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const Gap(defaultPadding * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: secondaryColor,
                    ),
                    onPressed: () {
                      catProvider.clearFields();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const Gap(defaultPadding),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      if (catProvider.addCategoryFormKey.currentState!
                          .validate()) {
                        catProvider.addCategoryFormKey.currentState!.save();
                        catProvider.submitCategory();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// How to show the category popup safely
void showAddCategoryForm(
    BuildContext context, Category? category, String buttonText) {
  final catProvider = context.categoryProvider; // احفظ الـ provider

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: bgColor,
        title: Center(
          child: Text(
            buttonText.toUpperCase(),
            style: const TextStyle(color: primaryColor),
          ),
        ),
        content: CategorySubmitForm(category: category),
      );
    },
  ).then((val) {
    catProvider.clearFields(); // استخدم المتغير المخزن وليس الـ context بعد async
  });
}
