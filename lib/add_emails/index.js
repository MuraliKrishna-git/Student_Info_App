const admin = require("firebase-admin");
const serviceAccount = require("./student-info-app-88119-firebase-adminsdk-fbsvc-2c905f2110.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const users = [
  "arjun.verma@example.com",
  "meera.iyer@example.com",
  "ravi.kumar@example.com",
  "sneha.reddy@example.com",
  "tarun.das@example.com",
  "neha.kapoor@example.com",
  "akash.menon@example.com",
  "riya.sen@example.com",
  "vikram.singh@example.com",
  "aditi.nair@example.com",
  "rohit.sharma@example.com",
  "kavya.balan@example.com",
  "aman.joshi@example.com",
  "shreya.ghosh@example.com",
  "nikhil.rao@example.com",
  "priya.sharma@example.com",
  "surya.narain@example.com",
  "devika.patel@example.com",
  "varun.mehta@example.com",
  "ishita.jain@example.com",
];

const defaultPassword = "test1234";

async function createUsers() {
  for (const email of users) {
    try {
      await admin.auth().createUser({
        email: email,
        password: defaultPassword,
      });
      console.log(`✅ Created: ${email}`);
    } catch (error) {
      console.error(`❌ Error creating ${email}:`, error.message);
    }
  }
}

createUsers();
