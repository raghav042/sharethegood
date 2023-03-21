import 'package:sharethegood/ui/forms/books_form.dart';
import 'package:sharethegood/ui/forms/clothes_form.dart';
import 'package:sharethegood/ui/forms/food_form.dart';
import 'package:sharethegood/ui/forms/other_form.dart';
import 'package:sharethegood/ui/forms/volunteer_form.dart';

import '../modal/donation_model.dart';

const List<DonationModel> donationList = [
  DonationModel(
    label: "Books",
    imagePath: "assets/Books.jpg",
    form: BooksForm(),
  ),
  DonationModel(
    label: "Clothes",
    imagePath: "assets/Clothes.jpg",
    form: ClothesForm(),
  ),
  DonationModel(
    label: "Food",
    imagePath: "assets/Food.jpg",
    form: FoodForm(),
  ),
  DonationModel(
    label: "Other",
    imagePath: "assets/Others.jpg",
    form: OtherForm(),
  ),
  DonationModel(
    label: "Volunteer",
    imagePath: "assets/Volunteer.jpg",
    form: VolunteerForm(),
  ),
];
