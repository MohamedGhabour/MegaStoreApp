const express = require("express");
const router = express.Router();
const asyncHandler = require("express-async-handler");
const Notification = require("../model/notification");
const admin = require("firebase-admin");
const dotenv = require("dotenv");
dotenv.config();

// Send notification
router.post(
  "/send-notification",
  asyncHandler(async (req, res) => {
    const { title, description, imageUrl, tokens } = req.body;

    if (!tokens || tokens.length === 0) {
      return res.status(400).json({
        success: false,
        message: "No device tokens provided",
      });
    }

    const message = {
      notification: {
        title,
        body: description,
      },
      android: {
        notification: {
          imageUrl: imageUrl || undefined,
        },
      },
      tokens, // array of FCM device tokens
    };

    try {
      const response = await admin.messaging().sendMulticast(message);

      // Log notification in DB
      const notification = new Notification({
        notificationId: response.responses.map((r, i) => r.messageId || "").join(","),
        title,
        description,
        imageUrl,
      });

      await notification.save();

      res.json({
        success: true,
        message: "Notification sent successfully",
        data: {
          successCount: response.successCount,
          failureCount: response.failureCount,
          responses: response.responses,
        },
      });
    } catch (error) {
      console.error("Error sending notification:", error);
      res.status(500).json({
        success: false,
        message: "Failed to send notification",
        error,
      });
    }
  })
);

// Get all notifications
router.get(
  "/all-notification",
  asyncHandler(async (req, res) => {
    try {
      const notifications = await Notification.find({}).sort({ _id: -1 });
      res.json({
        success: true,
        message: "Notifications retrieved successfully.",
        data: notifications,
      });
    } catch (error) {
      res.status(500).json({ success: false, message: error.message });
    }
  })
);

// Delete a notification
router.delete(
  "/delete-notification/:id",
  asyncHandler(async (req, res) => {
    const notificationID = req.params.id;
    try {
      const notification = await Notification.findByIdAndDelete(notificationID);
      if (!notification) {
        return res
          .status(404)
          .json({ success: false, message: "Notification not found." });
      }
      res.json({
        success: true,
        message: "Notification deleted successfully.",
        data: null,
      });
    } catch (error) {
      res.status(500).json({ success: false, message: error.message });
    }
  })
);

module.exports = router;
