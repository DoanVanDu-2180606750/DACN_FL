const express = require('express');
const router = express.Router();
const bodyController = require('../Controllers/bodyController');

router.post('/post_body', bodyController.postBody);
router.get('/get_body', bodyController.getBody);

module.exports = router;
