const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mongoose = require("mongoose");
const asyncHandler = require("express-async-handler");
const dotenv = require("dotenv");
const admin = require("firebase-admin");

dotenv.config();

const app = express();

// Firebase Admin SDK
try {
  const serviceAccount = JSON.parse(process.env.FIREBASE_ADMIN_KEY);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
  console.log("✅ Firebase Admin initialized");
} catch (err) {
  console.error("❌ Firebase Admin init error:", err);
}

// Middleware
app.use(cors({
  origin: [
    "https://megastoreadmin.web.app",
    "https://megastoreadmin.firebaseapp.com"
  ],
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));
app.use(bodyParser.json());


// Connect to MongoDB safely
const URL = process.env.MONGO_URL;
mongoose.connect(URL)
  .then(() => console.log("✅ Connected to Database"))
  .catch(err => {
    console.error("❌ DB connection error:", err);
    process.exit(1); // Stop app if DB fails
  });

// Test route to check if server responds
app.get("/ping", (req, res) => res.send("pong"));

// Example API route
app.get("/", asyncHandler(async (req, res) => {
  res.json({
    success: true,
    message: "API working successfully",
    data: null,
  });
}));

// Import other routes
app.use("/categories", require("./routes/category"));
app.use("/subCategories", require("./routes/subCategory"));
app.use("/brands", require("./routes/brand"));
app.use("/variantTypes", require("./routes/variantType"));
app.use("/variants", require("./routes/variant"));
app.use("/products", require("./routes/product"));
app.use("/couponCodes", require("./routes/couponCode"));
app.use("/posters", require("./routes/poster"));
app.use("/users", require("./routes/user"));
app.use("/orders", require("./routes/order"));
app.use("/payment", require("./routes/payment"));
app.use("/notification", require("./routes/notification")); // لاحقًا سيتم استخدام admin.messaging() هنا
app.use("/admin", require("./routes/admin"));

// Global error handler
app.use((error, req, res, next) => {
  console.error("❌ Global error:", error);
  res.status(500).json({ success: false, message: error.message, data: null });
});

// Start server using PORT from Railway
const PORT = process.env.PORT || 8080;
app.listen(PORT, "0.0.0.0", () => {
  console.log(`✅ Server running on port ${PORT}`);
});
