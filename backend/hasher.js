// Import bcrypt for hashing passwords
import bcrypt from 'bcrypt';

// Function to hash a password
async function hashPassword(password) {
	const saltRounds = 10; // Number of salt rounds
	try {
		const hashedPassword = await bcrypt.hash(password, saltRounds);
		return hashedPassword;
	} catch (error) {
		console.error('Error hashing password:', error);
		throw error;
	}
}

// Function to compare a plain text password with a hashed password
async function comparePassword(plainPassword, hashedPassword) {
	try {
		const isMatch = await bcrypt.compare(plainPassword, hashedPassword);
		return isMatch;
	} catch (error) {
		console.error('Error comparing password:', error);
		throw error;
	}
}

export { hashPassword, comparePassword };