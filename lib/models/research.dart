// ResearchStatus drives which screen a card appears on:
//   active    → Participate tab (still collecting data)
//   completed → Library tab (finished research)

enum ResearchStatus { active, completed }

enum ResearchType { survey, interview, observation, experiment }

class Research {
  final String id;
  final String title;
  final String researcher;
  final String institution;
  final String topic;          // e.g. "Mental Health", "AI"
  final String researchType;   // human-readable: "Survey", "Interview" …
  final String city;
  final String duration;
  final ResearchStatus status;

  // Participation-request fields (active only)
  final String? googleFormUrl;
  final String? deadline;
  final String? targetParticipants;

  // Completed-research fields
  final bool isPaid;
  final String? price;         // e.g. "5,000 IQD" — shown only when isPaid
  final String summary;        // short description / abstract

  bool isSaved;

  Research({
    required this.id,
    required this.title,
    required this.researcher,
    required this.institution,
    required this.topic,
    required this.researchType,
    required this.city,
    required this.duration,
    required this.status,
    required this.summary,
    this.googleFormUrl,
    this.deadline,
    this.targetParticipants,
    this.isPaid = false,
    this.price,
    this.isSaved = false,
  });
}
