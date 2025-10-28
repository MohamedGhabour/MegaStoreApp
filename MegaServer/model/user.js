const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      unique: true, // 🔹 يضمن عدم تكرار اسم المستخدم
      trim: true,
    },
    password: {
      type: String,
      required: true,
      minlength: 6, // 🔹 تأمين إضافي (اختياري)
    },
  },
  {
    timestamps: true, // 🔹 يضيف createdAt و updatedAt تلقائيًا
  }
);

// 🔒 Hash the password before saving
userSchema.pre("save", function (next) {
  if (!this.isModified("password")) return next();
  this.password = bcrypt.hashSync(this.password, bcrypt.genSaltSync(8));
  next();
});

// 🔑 Method to check if password is valid
userSchema.methods.validPassword = function (password) {
  return bcrypt.compareSync(password, this.password);
};

// 🧩 Hide password field when converting to JSON (optional but recommended)
userSchema.methods.toJSON = function () {
  const userObject = this.toObject();
  delete userObject.password;
  return userObject;
};

const User = mongoose.model("User", userSchema);

module.exports = User;
