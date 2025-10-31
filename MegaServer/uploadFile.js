const multer = require("multer");
const path = require("path");

const fileFilter = (req, file, cb) => {
  const filetypes = /jpeg|jpg|png/;
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());

  if (extname) {
    cb(null, true);
  } else {
    cb(new Error("Error: only .jpeg, .jpg, .png files are allowed!"), false);
  }
};

const createStorage = (destination) =>
  multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, `./public/${destination}`);
    },
    filename: function (req, file, cb) {
      cb(
        null,
        Date.now() +
          "_" +
          Math.floor(Math.random() * 1000) +
          path.extname(file.originalname)
      );
    },
  });

const uploadCategory = multer({
  storage: createStorage("category"),
  limits: {
    fileSize: 1024 * 1024 * 5, // limit filesize to 5MB
  },
  fileFilter,
});

const uploadProduct = multer({
  storage: createStorage("products"),
  limits: {
    fileSize: 1024 * 1024 * 5, // limit filesize to 5MB
  },
  fileFilter,
});

const uploadPosters = multer({
  storage: createStorage("posters"),
  limits: {
    fileSize: 1024 * 1024 * 5, // limit filesize to 5MB
  },
  fileFilter,
});

module.exports = {
  uploadCategory,
  uploadProduct,
  uploadPosters,
};
