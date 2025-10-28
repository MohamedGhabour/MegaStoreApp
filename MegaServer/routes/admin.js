const express = require("express");
const asyncHandler = require("express-async-handler");
const jwt = require("jsonwebtoken");
const Admin = require("../model/admin");
const router = express.Router();

// 🟢 Register new admin
router.post(
  "/register",
  asyncHandler(async (req, res) => {
    const { name, email, password } = req.body;

    if (!name || !email || !password)
      return res
        .status(400)
        .json({ success: false, message: "All fields are required." });

    const existing = await Admin.findOne({ email });
    if (existing)
      return res
        .status(400)
        .json({ success: false, message: "Admin already exists." });

    const admin = new Admin({ name, email, password }); // plain text
    await admin.save();

    res.json({
      success: true,
      message: "Admin registered successfully.",
      data: { email: admin.email },
    });
  })
);

// 🔵 Login
router.post(
  "/login",
  asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    const admin = await Admin.findOne({ email });
    if (!admin || !admin.validPassword(password))
      return res
        .status(401)
        .json({ success: false, message: "Invalid email or password." });

    // نرسل توكن بدون أي id
    const token = jwt.sign({}, process.env.JWT_SECRET, { expiresIn: "7d" });

    res.json({
      success: true,
      message: "Login successful.",
      data: {
        token,
        admin: {
          name: admin.name,
          email: admin.email,
        },
      },
    });
  })
);

module.exports = router;
