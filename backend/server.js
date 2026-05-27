const express = require('express');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

// --- MOCK DATA ---
const users = [];

const banners = [
  "assets/banner_explore.png",
  "assets/banner_explore.png",
];

const journeys = [
  { 
    id: "1", 
    image: "assets/DN-BN-HA.jpg", 
    title: "Da Nang - Ba Na - Hoi An", 
    date: "Jan 30, 2020", 
    days: "3 days", 
    price: "$400.00" 
  },
  { 
    id: "2", 
    image: "assets/thailan.png", 
    title: "Thailand", 
    date: "Jan 30, 2020", 
    days: "3 days", 
    price: "$600.00" 
  },
  { 
    id: "3", 
    image: "assets/HanoiHaLongBay.png", 
    title: "Ha Long Bay", 
    date: "Jan 30, 2020", 
    days: "3 days", 
    price: "$500.00" 
  },
];

const guides = [
  { id: "1", image: "assets/anna.png", name: "Emmy", role: "Hanoi, Vietnam", reviews: 127 },
  { id: "2", image: "assets/John.png", name: "Khai Ho", role: "Ho Chi Minh, Vietnam", reviews: 85 },
  { id: "3", image: "assets/lina.png", name: "Linh Hana", role: "Danang, Vietnam", reviews: 156 },
  { id: "4", image: "assets/TuanTran.png", name: "Tuan Tran", role: "Danang, Vietnam", reviews: 204 },
];

const experiences = [
  { 
    id: "1", 
    image: "assets/hoian.png", 
    avatar: "assets/TuanTran.png", 
    name: "Tuan Tran", 
    title: "2 Hour Bicycle Tour exploring Hoian", 
    location: "Hoian, Vietnam" 
  },
  { 
    id: "2", 
    image: "assets/bana.png", 
    avatar: "assets/lina.png", 
    name: "Linh Hana", 
    title: "1 day at Bana Hill", 
    location: "Bana, Vietnam" 
  }
];

const tours = [
  { 
    id: "1", 
    image: "assets/img1.png", 
    title: "Da Nang - Ba Na - Hoi An", 
    date: "Jan 30, 2020", 
    days: "3 days", 
    price: "$400.00", 
    isLiked: false, 
    isSaved: false 
  },
  { 
    id: "2", 
    image: "assets/MelbourneSydney.png", 
    title: "Melbourne - Sydney", 
    date: "Jan 30, 2020", 
    days: "3 days", 
    price: "$600.00", 
    isLiked: true, 
    isSaved: false 
  },
];

const trips = {
  "Current Trips": [
    { id: "1", title: "Dragon Bridge Trip", location: "Da Nang, Vietnam", date: "Jan 30, 2020", time: "13:00 - 15:00", image: "assets/dragonbridge.png", avatar: "assets/anna.png" },
    { id: "2", title: "Ho Guom Trip", location: "Hanoi, Vietnam", date: "Feb 2, 2020", time: "8:00 - 10:00", image: "assets/HanoiHaLongBay.png", avatar: "assets/lina.png" },
  ],
  "Next Trips": [
    { id: "3", title: "Ba Na Hill Discovery", location: "Da Nang, Vietnam", date: "May 10, 2026", time: "08:00 - 17:00", image: "assets/bana.png", avatar: "assets/TuanTran.png" },
  ],
  "Past Trips": [
     { id: "4", title: "Old Town Walk", location: "Hoi An, Vietnam", date: "Dec 15, 2019", time: "10:00 - 12:00", image: "assets/hoian.png", avatar: "assets/lina.png" },
  ],
  "Wish List": [
     { id: "5", title: "Sydney Opera House", location: "Sydney, Australia", date: "TBD", time: "Anytime", image: "assets/MelbourneSydney.png", avatar: "assets/John.png" },
  ]
};


// --- ENDPOINTS ---
app.post('/api/signup', (req, res) => {
  const { email, password, firstName, lastName, country, userType } = req.body;
  const user = { id: Date.now().toString(), email, password, firstName, lastName, country, userType };
  users.push(user);
  console.log('User signed up:', user);
  res.status(201).json({ message: 'User created successfully', user: { id: user.id, email: user.email } });
});

app.post('/api/login', (req, res) => {
  const { email, password } = req.body;
  const user = users.find(u => u.email === email && u.password === password);
  if (user) {
    res.json({ message: 'Login successful', user: { id: user.id, email: user.email } });
  } else {
    res.status(401).json({ message: 'Invalid credentials' });
  }
});

app.get('/api/banners', (req, res) => res.json(banners));
app.get('/api/journeys', (req, res) => res.json(journeys));
app.get('/api/guides', (req, res) => res.json(guides));
app.get('/api/experiences', (req, res) => res.json(experiences));
app.get('/api/tours', (req, res) => res.json(tours));
app.get('/api/trips', (req, res) => {
  const status = req.query.status || "Current Trips";
  res.json(trips[status] || []);
});

app.post('/api/trips', (req, res) => {
  const { title, location, date, time, status } = req.body;
  const newTrip = {
    id: Date.now().toString(),
    title: title || "New Trip",
    location: location || "Unknown Location",
    date: date || "TBD",
    time: time || "TBD",
    image: "assets/hoian.png", // Giả lập hình ảnh
    avatar: "assets/anna.png"  // Giả lập avatar
  };
  
  const tripCategory = status || "Current Trips";
  if (!trips[tripCategory]) {
    trips[tripCategory] = [];
  }
  trips[tripCategory].push(newTrip);
  
  res.status(201).json({ message: 'Trip added successfully', trip: newTrip });
});

app.delete('/api/trips/:id', (req, res) => {
  const { id } = req.params;
  let deleted = false;
  for (const category in trips) {
    const initialLength = trips[category].length;
    trips[category] = trips[category].filter(t => t.id !== id);
    if (trips[category].length < initialLength) {
      deleted = true;
    }
  }
  if (deleted) {
    res.json({ message: 'Trip deleted successfully', id });
  } else {
    res.status(404).json({ message: 'Trip not found' });
  }
});

app.listen(port, () => {
  console.log(`Travel API running at http://localhost:${port}`);
});

