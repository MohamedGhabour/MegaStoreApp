const multer = require("multer");
const cloudinary = require("cloudinary").v2;
const { CloudinaryStorage } = require("multer-storage-cloudinary");

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

const createStorage = (folderName) => {
  return new CloudinaryStorage({
    cloudinary: cloudinary,
    params: {
      folder: folderName,
      allowed_formats: ["jpg", "png", "jpeg"],
    },
  });
};

const uploadCategory = multer({ storage: createStorage("category") });
const uploadProduct = multer({ storage: createStorage("products") });
const uploadPosters = multer({ storage: createStorage("posters") });

module.exports = {
  uploadCategory,
  uploadProduct,
  uploadPosters,
};
