const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Use environment variable for MongoDB connection
const mongoURI = process.env.MONGO_URI || 'mongodb://mongo:27017/employees';

const connectDB = async () => {
    try {
        await mongoose.connect(mongoURI);
        console.log('MongoDB connected');
    } catch (err) {
        console.error('MongoDB connection error:', err);
        process.exit(1);
    }
};

connectDB();

const employeeSchema = new mongoose.Schema({
    name: String,
    surname: String,
    salary: Number,
    position: String
});

const Employee = mongoose.model('Employee', employeeSchema);

// Get all employees
app.get('/api/employees', async (req, res) => {
    try {
        const employees = await Employee.find();
        res.json(employees);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// Add an employee
app.post('/api/employees', async (req, res) => {
    try {
        const { name, surname, salary, position } = req.body;
        const employee = new Employee({ name, surname, salary, position });
        await employee.save();
        res.json(employee);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Delete an employee
app.delete('/api/employees/:id', async (req, res) => {
    try {
        await Employee.findByIdAndDelete(req.params.id);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
