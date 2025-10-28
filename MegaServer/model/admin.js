const mongoose = require("mongoose");

const adminSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true, // سيتم حفظه plain text
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// دالة التحقق ببساطة تقارن نصيًا
adminSchema.methods.validPassword = function (password) {
  return password === this.password;
};

const Admin = mongoose.model("Admin", adminSchema);
module.exports = Admin;
