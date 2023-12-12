enum Genders {
  male(value: "male"),
  female(value: "female"),
  other(value: "other");

  const Genders({
    required this.value,
  });

  final String value;
}
