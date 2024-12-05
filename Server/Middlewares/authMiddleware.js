const jwt = require('jsonwebtoken');
const User = require('../Models/User');

const ROLES = {
  USER: 'user',
  ADMIN: 'admin',
};

const authorize = (roles = []) => {
  return async (req, res, next) => {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res.status(403).json({ message: 'Authorization header is missing.' });
    }

    const token = authHeader.split(' ')[1];
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const user = await User.findById(decoded.id);
      
      if (!user ) {
        return res.status(401).json({ message: 'Unauthorized: user', data: user });
      }

      if (roles.length && !roles.includes(user.role)) {
        return res.status(403).json({ message: 'Access denied: insufficient permissions.' });
      }
      console.log(user.role);
      console.log(user.email);
      req.user = user; // Attach user to request object
      next();
    } catch (error) {
      console.error('Authorization error:', error); // Log error for debugging
      return res.status(401).json({ message: 'Unauthorized: invalid or expired token.' });
    }
  };
};

module.exports = { authorize, ROLES };
