const express = require("express");
const asyncHandler = require("express-async-handler");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const router = express.Router();
const User = require("../model/user");
const verifyAdmin = require("../middleware/adminAuth");

const JWT_SECRET = process.env.JWT_SECRET || "your_secret_key_here";

// 🟢 Register new user (NO admin required)
router.post(
  "/register",
  asyncHandler(async (req, res) => {
    const { name, password } = req.body;
    if (!name || !password) {
      return res
        .status(400)
        .json({ success: false, message: "Name and password are required." });
    }

    const existingUser = await User.findOne({ name });
    if (existingUser) {
      return res
        .status(400)
        .json({ success: false, message: "User already exists." });
    }

    const user = new User({ name, password });
    await user.save();

    const token = jwt.sign({ id: user._id, name: user.name }, JWT_SECRET, {
      expiresIn: "7d",
    });

    res.status(201).json({
      success: true,
      message: "User registered successfully.",
      token,
      data: { id: user._id, name: user.name },
    });
  })
);

// 🟢 Login user
router.post(
  "/login",
  asyncHandler(async (req, res) => {
    const { name, password } = req.body;

    const user = await User.findOne({ name });
    if (!user || !user.validPassword(password)) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid name or password." });
    }

    const token = jwt.sign({ id: user._id, name: user.name }, JWT_SECRET, {
      expiresIn: "7d",
    });

    res.status(200).json({
      success: true,
      message: "Login successful.",
      token,
      data: { id: user._id, name: user.name },
    });
  })
);

// 🟢 Get all users (admin only)
router.get(
  "/",
  verifyAdmin,
  asyncHandler(async (req, res) => {
    const users = await User.find();
    res.json({
      success: true,
      message: "Users retrieved successfully.",
      data: users,
    });
  })
);

// 🟢 Get one user (admin only)
router.get(
  "/:id",
  verifyAdmin,
  asyncHandler(async (req, res) => {
    const user = await User.findById(req.params.id);
    if (!user)
      return res.status(404).json({ success: false, message: "User not found." });
    res.json({
      success: true,
      message: "User retrieved successfully.",
      data: user,
    });
  })
);

// 🟢 Update user (admin only)
router.put(
  "/:id",
  verifyAdmin,
  asyncHandler(async (req, res) => {
    const { name, password } = req.body;
    if (!name || !password) {
      return res
        .status(400)
        .json({ success: false, message: "Name and password are required." });
    }

    const user = await User.findById(req.params.id);
    if (!user)
      return res.status(404).json({ success: false, message: "User not found." });

    user.name = name;
    user.password = bcrypt.hashSync(password, bcrypt.genSaltSync(8));
    await user.save();

    res.json({ success: true, message: "User updated successfully.", data: user });
  })
);

// 🟢 Delete user (admin only)
router.delete(
  "/:id",
  verifyAdmin,
  asyncHandler(async (req, res) => {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user)
      return res.status(404).json({ success: false, message: "User not found." });

    res.json({ success: true, message: "User deleted successfully." });
  })
);

module.exports = router;
