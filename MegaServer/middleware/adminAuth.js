const jwt = require("jsonwebtoken");

function verifyAdmin(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res
      .status(401)
      .json({ success: false, message: "Access denied. No token provided." });
  }

  const token = authHeader.split(" ")[1];
  try {
    jwt.verify(token, process.env.JWT_SECRET); // فقط التحقق، بدون قراءة أي id
    next();
  } catch (err) {
    res.status(400).json({ success: false, message: "Invalid token." });
  }
}

module.exports = verifyAdmin;
