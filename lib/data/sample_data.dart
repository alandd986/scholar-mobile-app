import '../models/research.dart';

// ── Sample research items ────────────────────────────────────────
// Completed research → appears in Library tab
// Active research    → appears in Participate tab

final List<Research> sampleResearch = [

  // ── COMPLETED ───────────────────────────────────────────────────

  Research(
    id: 'c1',
    title: 'Sleep Quality Among Medical Students',
    researcher: 'Dr. Sara Ahmed',
    institution: 'College of Medicine – University of Baghdad',
    topic: 'Medicine',
    researchType: 'Survey',
    city: 'Baghdad',
    duration: '6 weeks',
    status: ResearchStatus.completed,
    isPaid: false,
    summary:
        'A study examining sleep duration, quality, and its effect on exam '
        'performance among 3rd and 4th year medical students. Findings showed '
        'that 68% of students sleep fewer than 6 hours per night during exam '
        'periods, with measurable impact on academic outcomes.',
    isSaved: false,
  ),

  Research(
    id: 'c2',
    title: 'AI Adoption in Iraqi Universities',
    researcher: 'Omar Khalid',
    institution: 'University of Basra – CS Department',
    topic: 'Technology',
    researchType: 'Survey',
    city: 'Basra',
    duration: '1 month',
    status: ResearchStatus.completed,
    isPaid: true,
    price: '5,000 IQD',
    summary:
        'An investigation into faculty and student awareness of AI tools in '
        'Iraqi higher education. The study identifies key barriers to adoption '
        'and maps current usage patterns across five universities.',
    isSaved: true,
  ),

  Research(
    id: 'c3',
    title: 'Social Media and Academic Performance',
    researcher: 'Lina Hassan',
    institution: 'Salahaddin University – Erbil',
    topic: 'Psychology',
    researchType: 'Observation',
    city: 'Erbil',
    duration: '3 weeks',
    status: ResearchStatus.completed,
    isPaid: false,
    summary:
        'This research explores the relationship between daily social media '
        'use and GPA scores among undergraduate students. Screen-time logs '
        'were collected over three weeks and correlated with academic records.',
    isSaved: false,
  ),

  Research(
    id: 'c4',
    title: 'Remote Work Productivity in the Tech Sector',
    researcher: 'Yusuf Al-Amin',
    institution: 'Al-Mustansiriyah University',
    topic: 'Business',
    researchType: 'Interview',
    city: 'Mosul',
    duration: '6 weeks',
    status: ResearchStatus.completed,
    isPaid: true,
    price: '3,000 IQD',
    summary:
        'Interviews with 40 remote tech workers in northern Iraq revealed '
        'patterns in productivity, communication habits, and work-life balance. '
        'Key findings highlight the importance of structured daily routines.',
    isSaved: false,
  ),

  Research(
    id: 'c5',
    title: 'Arabic NLP Benchmark Evaluation',
    researcher: 'Nour Saadi',
    institution: 'University of Technology – Baghdad',
    topic: 'Linguistics',
    researchType: 'Experiment',
    city: 'Baghdad',
    duration: '2 months',
    status: ResearchStatus.completed,
    isPaid: false,
    summary:
        'Native speakers annotated Arabic text samples to evaluate existing '
        'NLP benchmarks for Modern Standard Arabic and Iraqi dialect. The study '
        'exposes significant gaps in current dialect coverage.',
    isSaved: false,
  ),

  // ── ACTIVE (Participation Requests) ─────────────────────────────

  Research(
    id: 'a1',
    title: 'Mental Health Survey for University Students',
    researcher: 'Hana Kareem',
    institution: 'University of Sulaymaniyah',
    topic: 'Psychology',
    researchType: 'Survey',
    city: 'Sulaymaniyah',
    duration: '2 weeks',
    status: ResearchStatus.active,
    targetParticipants: '150',
    deadline: 'June 30, 2025',
    googleFormUrl: 'https://forms.google.com/demo',
    summary:
        'We are collecting data on stress, anxiety, and coping strategies '
        'among university students. The survey takes about 8 minutes to complete '
        'and all responses are anonymous.',
    isSaved: false,
  ),

  Research(
    id: 'a2',
    title: 'Study Habits Questionnaire',
    researcher: 'Rawan Majid',
    institution: 'Tikrit University',
    topic: 'Education',
    researchType: 'Survey',
    city: 'Tikrit',
    duration: '3 weeks',
    status: ResearchStatus.active,
    targetParticipants: '200',
    deadline: 'July 15, 2025',
    googleFormUrl: 'https://forms.google.com/demo',
    summary:
        'A short questionnaire about how students organise their study time, '
        'preferred environments, and revision techniques. Results will be used '
        'to improve academic guidance services.',
    isSaved: false,
  ),

  Research(
    id: 'a3',
    title: 'AI Tools Usage Among Students',
    researcher: 'Ali Hassan',
    institution: 'Erbil Polytechnic University',
    topic: 'Technology',
    researchType: 'Survey',
    city: 'Erbil',
    duration: '1 month',
    status: ResearchStatus.active,
    targetParticipants: '120',
    deadline: 'July 20, 2025',
    googleFormUrl: 'https://forms.google.com/demo',
    summary:
        'Help us understand how students are using AI tools like ChatGPT and '
        'similar platforms in their academic work. The survey covers frequency '
        'of use, perceived benefits, and ethical concerns.',
    isSaved: true,
  ),

  Research(
    id: 'a4',
    title: 'Sleep Pattern Research — Participant Form',
    researcher: 'Dr. Maha Saleh',
    institution: 'College of Medicine – University of Basra',
    topic: 'Medicine',
    researchType: 'Observation',
    city: 'Basra',
    duration: '4 weeks',
    status: ResearchStatus.active,
    targetParticipants: '80',
    deadline: 'August 1, 2025',
    googleFormUrl: 'https://forms.google.com/demo',
    summary:
        'We are looking for students willing to log their sleep times for '
        'four weeks using our simple daily form. Participants will also complete '
        'two short surveys at the start and end of the study.',
    isSaved: false,
  ),
];

// ── Filter lists ─────────────────────────────────────────────────

const List<String> topicOptions = [
  'All Topics',
  'Medicine',
  'Technology',
  'Psychology',
  'Business',
  'Linguistics',
  'Education',
  'Engineering',
  'Sociology',
];

const List<String> cityOptions = [
  'All Cities',
  'Baghdad',
  'Basra',
  'Erbil',
  'Mosul',
  'Sulaymaniyah',
  'Tikrit',
  'Najaf',
];

const List<String> researchTypeOptions = [
  'All Types',
  'Survey',
  'Interview',
  'Observation',
  'Experiment',
];
