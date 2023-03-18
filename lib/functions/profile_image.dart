String? profileImage(String type) {
  return userImage[type];
}

const Map<String, String> userImage = {
  "Individual":
      "https://firebasestorage.googleapis.com/v0/b/share-the-good.appspot.com/o/appdata%2FprofileImage%2Findividual.jpg?alt=media&token=541bc3c1-4b14-428c-924a-e3bd8526296d",
  "Library":
      "https://firebasestorage.googleapis.com/v0/b/share-the-good.appspot.com/o/appdata%2FprofileImage%2Flibrary.jpg?alt=media&token=867af69a-6b3e-4eb3-9ed8-45dcde82c6ad",
  "NGO":
      "https://firebasestorage.googleapis.com/v0/b/share-the-good.appspot.com/o/appdata%2FprofileImage%2Fngo.jpg?alt=media&token=455bd032-2cfa-4974-8865-1ac55a797c86",
};
