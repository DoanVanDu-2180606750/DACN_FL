const mongoose = require('mongoose');

const StepsSchema = new mongoose.Schema({
    calocaloriesBurned: { type: Number, required: true },
    runningSteps: { type: Number,  },
    currentSteps: { type: String, required: true },
    targetSteps: { type: String, required: true },
    elapsedTime: { type: String,  },
}, { timestamps: true });

const Steps = mongoose.model('Steps', StepsSchema);
module.exports = Steps;
