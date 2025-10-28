const mongoose = require('mongoose');
require('dotenv').config();
const Admin = require('./model/admin');

async function run() {
  try {
    const mongoUrl = process.env.MONGO_URL || process.env.MONGO_URI;
    if (!mongoUrl) {
      console.error("Please set MONGO_URL or MONGO_URI in your .env file");
      process.exit(1);
    }

    await mongoose.connect(mongoUrl, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    const name = 'Mega';
    const email = 'Mega@admin.com';
    const plain = 'Mega123'; // plain text

    const existing = await Admin.findOne({ email });
    if (existing) {
      console.log('Admin already exists:', existing.email);
      process.exit(0);
    }

    const admin = new Admin({ name, email, password: plain });
    await admin.save();
    console.log('Admin created:', email);
    console.log('Password (plain):', plain);
    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
}

run();
