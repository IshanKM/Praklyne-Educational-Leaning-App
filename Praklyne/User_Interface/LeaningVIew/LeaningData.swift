import SwiftUI

// MARK: - Learning Resource
struct LearningResource: Identifiable {
    let id: Int
    let title: String
    let url: String
    let source: String // e.g. "Khan Academy", "Wikipedia"
}

// MARK: - Topic Video
struct TopicVideo: Identifiable {
    let id: Int
    let title: String
    let duration: String
    let videoUrl: String
}

// MARK: - Topic (full rich model)
struct Topic: Identifiable {
    let id: Int
    let name: String
    let subject: String
    let description: String
    let videos: [TopicVideo]

    // Rich content sections
    let keyConcepts: [String]
    let funFacts: [String]
    let diagramImageURLs: [String]
    let resources: [LearningResource]
    let summary: String
    let relatedTopicIds: [Int]

    // Sinhala translations
    let sinhaleName: String
    let sinhalaDescription: String
    let sinhalaKeyConcepts: [String]
    let sinhalaSummary: String

    // Convenience init so existing call-sites with only base fields still compile
    init(
        id: Int, name: String, subject: String, description: String, videos: [TopicVideo],
        keyConcepts: [String] = [], funFacts: [String] = [],
        diagramImageURLs: [String] = [], resources: [LearningResource] = [],
        summary: String = "", relatedTopicIds: [Int] = [],
        sinhaleName: String = "", sinhalaDescription: String = "",
        sinhalaKeyConcepts: [String] = [], sinhalaSummary: String = ""
    ) {
        self.id = id; self.name = name; self.subject = subject
        self.description = description; self.videos = videos
        self.keyConcepts = keyConcepts; self.funFacts = funFacts
        self.diagramImageURLs = diagramImageURLs; self.resources = resources
        self.summary = summary; self.relatedTopicIds = relatedTopicIds
        self.sinhaleName = sinhaleName; self.sinhalaDescription = sinhalaDescription
        self.sinhalaKeyConcepts = sinhalaKeyConcepts; self.sinhalaSummary = sinhalaSummary
    }
}

// MARK: - Learning Subject
struct LearningSubject {
    let id: Int
    let name: String
    let color: Color
}

// MARK: - All Topics Data
let allTopics: [Topic] = [

    // ─── SCIENCE ────────────────────────────────────────────────────────────

    Topic(
        id: 1,
        name: "Electricity",
        subject: "Science",
        description: """
Electricity is the flow of electric charge through a conductor. It is the foundation of modern technology, powering homes, industries, and devices. Key concepts include current, voltage, resistance, Ohm's law, circuits (series and parallel), and safety precautions. Understanding electricity is essential for physics, engineering, and daily life.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Electricity", duration: "10:30", videoUrl: "https://www.youtube.com/watch?v=mc979OhitAg"),
            TopicVideo(id: 2, title: "Ohm's Law Explained", duration: "12:45", videoUrl: "https://www.youtube.com/watch?v=kcL2_D33k3o"),
            TopicVideo(id: 3, title: "Series & Parallel Circuits", duration: "15:20", videoUrl: "https://www.youtube.com/watch?v=J-otRZCiPDE")
        ],
        keyConcepts: [
            "Current (A) – flow of electric charge",
            "Voltage (V) – electric potential difference",
            "Resistance (Ω) – opposition to current flow",
            "Ohm's Law: V = I × R",
            "Series circuit – same current through all components",
            "Parallel circuit – same voltage across all branches",
            "Power (W) = Voltage × Current"
        ],
        funFacts: [
            "Lightning bolts can reach temperatures of 30,000 K — five times hotter than the Sun's surface!",
            "Benjamin Franklin didn't actually discover electricity — he proved lightning is electrical in 1752.",
            "The human brain generates about 20 watts of electrical power — enough to power a dim light bulb.",
            "Electric eels can produce up to 600 volts — enough to stun a horse!"
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/OhmsLaw.svg/400px-OhmsLaw.svg.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Series_circuit.svg/400px-Series_circuit.svg.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Parallel_circuit.svg/400px-Parallel_circuit.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Electricity – Khan Academy", url: "https://www.khanacademy.org/science/physics/electric-charge-electric-force-and-voltage", source: "Khan Academy"),
            LearningResource(id: 2, title: "Electricity – Wikipedia", url: "https://en.wikipedia.org/wiki/Electricity", source: "Wikipedia"),
            LearningResource(id: 3, title: "How Circuits Work – HowStuffWorks", url: "https://electronics.howstuffworks.com/electric-motor1.htm", source: "HowStuffWorks")
        ],
        summary: "Electricity powers modern life. Current flows through conductors driven by voltage and opposed by resistance. Ohm's Law (V=IR) ties these together. Series circuits share current; parallel circuits share voltage. Always respect safety rules around live circuits.",
        relatedTopicIds: [4, 5],
        sinhaleName: "විද්‍යුත් ශක්තිය",
        sinhalaDescription: """
විද්‍යුත් ශක්තිය යනු සන්නායකයක් හරහා ගලා යන ආරෝපණ ප්‍රවාහයයි. නවීන තාක්ෂණයේ ප්‍රධාන පදනම වන මෙය නිවාස, කර්මාන්ත සහ උපකරණ ධාවනය කරයි. ධාරාව, වෝල්ටීයතාව, ප්‍රතිරෝධය, ඕමිගේ නියමය, ශ්‍රේණිය හා සමාන්තර පරිපථ සහ ආරක්ෂිත ක්‍රමවේද ප්‍රධාන සංකල්ප වේ.
""",
        sinhalaKeyConcepts: [
            "ධාරාව (A) – ආරෝපණ ප්‍රවාහය",
            "වෝල්ටීයතාව (V) – විභව අන්තරය",
            "ප්‍රතිරෝධය (Ω) – ධාරා ප්‍රවාහයට බාධාව",
            "ඕමිගේ නියමය: V = I × R",
            "ශ්‍රේණි පරිපථය – සමාන ධාරාව",
            "සමාන්තර පරිපථය – සමාන වෝල්ටීයතාව"
        ],
        sinhalaSummary: "විද්‍යුත් ශක්තිය නවීන ජීවිතය ශක්තිමත් කරයි. ඕමිගේ නියමය (V=IR) ධාරාව, වෝල්ටීයතාව සහ ප්‍රතිරෝධය සම්බන්ධ කරයි. සජීව පරිපථ වලදී ආරක්ෂිත ක්‍රමවේද සැමවිටම පිළිපදිය යුතුය."
    ),

    Topic(
        id: 2,
        name: "Gravitation",
        subject: "Science",
        description: """
Gravitation is the force of attraction between all objects with mass. It governs planetary motion, causes objects to fall to the ground, and explains tidal phenomena. Topics include Newton's law of universal gravitation, gravitational acceleration, weight vs mass, and real-world applications in astronomy and space exploration.
""",
        videos: [
            TopicVideo(id: 1, title: "Gravitational Force Basics", duration: "11:20", videoUrl: "https://www.youtube.com/watch?v=7gf6YpdvtE0"),
            TopicVideo(id: 2, title: "Newton's Law of Gravitation", duration: "14:10", videoUrl: "https://www.youtube.com/watch?v=Cc0sbMHTLKs")
        ],
        keyConcepts: [
            "Gravity: F = G × (m₁ × m₂) / r²",
            "G = 6.674 × 10⁻¹¹ N·m²/kg² (gravitational constant)",
            "g = 9.8 m/s² on Earth's surface",
            "Weight = mass × gravitational acceleration",
            "Escape velocity – speed needed to leave a planet",
            "Tidal forces – differential gravity across an object",
            "Orbital velocity – speed to stay in orbit"
        ],
        funFacts: [
            "If you weigh 60 kg on Earth, you'd weigh only 10 kg on the Moon!",
            "A neutron star's gravity is so strong that a teaspoon of its material weighs about 10 million tonnes.",
            "Gravity travels at the speed of light — if the Sun disappeared, we'd have 8 minutes before Earth's orbit changed.",
            "An apple reportedly inspired Newton's theory of universal gravitation in 1666."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/NewtonsLawOfUniversalGravitation.svg/400px-NewtonsLawOfUniversalGravitation.svg.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Gravity_field_lines.jpg/400px-Gravity_field_lines.jpg"
        ],
        resources: [
            LearningResource(id: 1, title: "Gravitation – Khan Academy", url: "https://www.khanacademy.org/science/physics/gravity", source: "Khan Academy"),
            LearningResource(id: 2, title: "Gravity – Wikipedia", url: "https://en.wikipedia.org/wiki/Gravity", source: "Wikipedia"),
            LearningResource(id: 3, title: "NASA: Gravity Explainer", url: "https://spaceplace.nasa.gov/what-is-gravity/en/", source: "NASA")
        ],
        summary: "Every object with mass attracts every other object. Newton's law gives us F = Gm₁m₂/r². On Earth, gravity gives us g ≈ 9.8 m/s². Weight is not the same as mass — it depends on the local gravitational field. Gravity keeps planets in orbit and causes tides.",
        relatedTopicIds: [3, 5],
        sinhaleName: "ගුරුත්වාකර්ෂණය",
        sinhalaDescription: """
ගුරුත්වාකර්ෂණය යනු ස්කන්ධය සහිත සියලුම වස්තූන් අතර ආකර්ෂණ බලයයි. ග්‍රහලෝක චලනය, වස්තූන් බිමට වැටීම සහ රළු ප්‍රතිසන්ධාන සංසිද්ධිය ගුරුත්වාකර්ෂණය මගින් පැහැදිළි කෙරේ.
""",
        sinhalaKeyConcepts: [
            "ගුරුත්ව බලය: F = G × (m₁ × m₂) / r²",
            "g = 9.8 m/s² (පෘථිවි මතුපිට)",
            "ගුරුත්ව නියතාංකය G = 6.674 × 10⁻¹¹",
            "බර = ස්කන්ධය × ගුරුත්ව ත්වරණය",
            "මිදීමේ ප්‍රවේගය – ග්‍රහලෝකයෙන් ගැළවීමට අවශ්‍ය ප්‍රවේගය"
        ],
        sinhalaSummary: "ස්කන්ධය සහිත සෑම වස්තුවක්ම අනෙකා ආකර්ෂණය කරයි. නිව්ටන්ගේ නියමය: F = Gm₁m₂/r². ගුරුත්වාකර්ෂණය ග්‍රහලෝක කක්ෂවල තබා, රළු ගෙන ඒ සිදු කරයි."
    ),

    Topic(
        id: 3,
        name: "Oscillation",
        subject: "Science",
        description: """
Oscillation refers to repetitive motion around an equilibrium point. Examples include pendulums, springs, sound waves, and alternating currents. Topics cover amplitude, frequency, period, damping, resonance, and their applications in physics, engineering, and natural phenomena.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Oscillation", duration: "9:50", videoUrl: "https://www.youtube.com/watch?v=qJLFjWqxTmw"),
            TopicVideo(id: 2, title: "Pendulums and Springs", duration: "13:05", videoUrl: "https://www.youtube.com/watch?v=QnB9YSIDW6g")
        ],
        keyConcepts: [
            "Amplitude – maximum displacement from equilibrium",
            "Period (T) – time for one complete oscillation",
            "Frequency (f) – oscillations per second (Hz)",
            "Damping – energy loss reducing amplitude over time",
            "Resonance – forcing at natural frequency causes large oscillations",
            "Simple Harmonic Motion (SHM) – restoring force proportional to displacement",
            "f = 1/T relationship"
        ],
        funFacts: [
            "The Tacoma Narrows Bridge collapsed in 1940 due to wind-induced resonance!",
            "A pendulum clock in a tall building keeps slightly different time at the top vs the bottom due to gravity differences.",
            "Quartz watches use the oscillation of a quartz crystal (32,768 Hz) to keep time.",
            "Your heart beats in a rhythm — it's a biological oscillator!"
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Simple_harmonic_motion_animation.gif/400px-Simple_harmonic_motion_animation.gif",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Simple_pendulum_height.svg/300px-Simple_pendulum_height.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Oscillations – Khan Academy", url: "https://www.khanacademy.org/science/physics/mechanical-waves-and-sound", source: "Khan Academy"),
            LearningResource(id: 2, title: "Oscillation – Wikipedia", url: "https://en.wikipedia.org/wiki/Oscillation", source: "Wikipedia")
        ],
        summary: "Oscillation is repetitive back-and-forth motion. Key quantities are amplitude, frequency, and period. SHM occurs when restoring force is proportional to displacement. Resonance — matching the natural frequency — can be destructive (bridges) or useful (musical instruments).",
        relatedTopicIds: [2, 4],
        sinhaleName: "දෝලනය",
        sinhalaDescription: """
දෝලනය යනු සමතුලිත ස්ථානය වටා නැවත නැවත ඇතිවන චලනයයි. එල්ලය, ස්ප්‍රිං, ශබ්ද තරංග සහ AC ධාරා ඊට උදාහරණ ලෙස දැක්විය හැකිය.
""",
        sinhalaKeyConcepts: [
            "විස්තාරය – සමතුලිත ස්ථානයෙන් උපරිම අපගමනය",
            "කාලාවර්තය (T) – සම්පූර්ණ දෝලනයකට ගත වන කාලය",
            "සම්ප්‍රාප්තිය (f) – තත්පරයකට දෝලන සංඛ්‍යාව",
            "අවාහකය – ශක්ති හානිය නිසා විස්තාරය අඩු වීම",
            "අනුනාදය – ස්වාභාවික සම්ප්‍රාප්තියෙදී ලොකු දෝලනය"
        ],
        sinhalaSummary: "දෝලනය යනු ඉදිරිපසට හා පසුපසට නැවත නැවත ඇතිවන චලනයයි. විස්තාරය, සම්ප්‍රාප්තිය සහ කාලාවර්තය ප්‍රධාන ප්‍රමාණ වේ. අනුනාදය ප්‍රයෝජනවත් හෝ විනාශකාරී විය හැකිය."
    ),

    Topic(
        id: 4,
        name: "Magnetic Fields",
        subject: "Science",
        description: """
Magnetism arises from moving electric charges and magnetic materials. This topic explores magnetic fields, their effects on materials, electromagnetism, and applications in motors, generators, and electronics. Understanding magnetic fields is critical in physics and engineering.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Magnetism", duration: "10:45", videoUrl: "https://www.youtube.com/watch?v=hFAOXdXZ5TM"),
            TopicVideo(id: 2, title: "Electromagnetic Fields", duration: "12:50", videoUrl: "https://www.youtube.com/watch?v=qMVznRQhFoI")
        ],
        keyConcepts: [
            "Magnetic field (B) – region where magnetic forces act",
            "Magnetic flux – total magnetic field passing through a surface",
            "Faraday's Law – changing magnetic flux induces EMF",
            "Lenz's Law – induced current opposes change",
            "Electromagnet – magnetic field created by electric current",
            "Right-hand rule – direction of magnetic force",
            "Tesla (T) – SI unit of magnetic field strength"
        ],
        funFacts: [
            "Earth's magnetic field protects us from deadly solar wind particles.",
            "MRI machines use incredibly strong magnetic fields — about 60,000 times Earth's field!",
            "Migratory birds like pigeons have tiny magnetite crystals in their brains to navigate using Earth's field.",
            "A magnet loses its magnetism permanently if heated above its Curie temperature."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Magnet0873.png/400px-Magnet0873.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Electromagnetism.svg/400px-Electromagnetism.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Magnetic Forces – Khan Academy", url: "https://www.khanacademy.org/science/physics/magnetic-forces-and-magnetic-fields", source: "Khan Academy"),
            LearningResource(id: 2, title: "Magnetism – Wikipedia", url: "https://en.wikipedia.org/wiki/Magnetism", source: "Wikipedia")
        ],
        summary: "Magnetic fields arise from moving charges. Faraday's Law links changing magnetic flux to induced voltage — the principle behind generators. The Earth's magnetic field protects life. MRI, motors, and compasses all rely on magnetic principles.",
        relatedTopicIds: [1, 5],
        sinhaleName: "චුම්භකීය ක්ෂේත්‍ර",
        sinhalaDescription: """
චලනය වන ආරෝපණ සහ චුම්භකීය ද්‍රව්‍ය වලින් චුම්භකත්වය ඇතිවේ. මෙම මාතෘකාව චුම්භකීය ක්ෂේත්‍ර, ඒවායේ ද්‍රව්‍ය කෙරේ බලපෑම්, විද්‍යුත් චුම්භකත්වය, සහ මෝටර, ජනක සහ ඉලෙක්ට්‍රොනික් අංශවල යෙදීම් ගවේෂණය කරයි.
""",
        sinhalaKeyConcepts: [
            "චුම්භකීය ක්ෂේත්‍රය (B) – චුම්භකීය බල ක්‍රියා කරන ප්‍රදේශය",
            "ෆැරඩේ නියමය – වෙනස් වන ප්‍රවාහය EMF ජනනය කරයි",
            "ලෙන්ස් නියමය – ජනනය කළ ධාරාව වෙනස්කමට විරුද්ධ වේ",
            "විද්‍යුත් චුම්භකය – ධාරාවෙන් ඇතිවන චුම්භකීය ක්ෂේත්‍රය",
            "ටෙස්ලා (T) – චුම්භකීය ක්ෂේත්‍ර ශක්තියේ SI ඒකකය"
        ],
        sinhalaSummary: "චලනය වන ආරෝපණ චුම්භකීය ක්ෂේත්‍ර ඇති කරයි. ෆැරඩේ නියමය ජනකවල ක්‍රියාකාරිත්වයේ පදනමයි. MRI, මෝටර් සහ කොමස් චුම්භකීය මූලධර්ම භාවිතා කරයි."
    ),

    Topic(
        id: 5,
        name: "Thermodynamics",
        subject: "Science",
        description: """
Thermodynamics studies heat, work, energy transfer, and temperature. Topics include the laws of thermodynamics, heat engines, entropy, and real-world applications in engines, refrigerators, and climate science. It forms the basis of physics and engineering.
""",
        videos: [
            TopicVideo(id: 1, title: "Laws of Thermodynamics", duration: "11:35", videoUrl: "https://www.youtube.com/watch?v=NyOYW07-L5g"),
            TopicVideo(id: 2, title: "Heat and Energy Transfer", duration: "14:15", videoUrl: "https://www.youtube.com/watch?v=VYIIvLAzb6g")
        ],
        keyConcepts: [
            "1st Law: Energy cannot be created or destroyed",
            "2nd Law: Entropy of an isolated system always increases",
            "3rd Law: Absolute zero (0 K) cannot be reached",
            "Zeroth Law: Thermal equilibrium is transitive",
            "Heat (Q) – energy transferred due to temperature difference",
            "Entropy (S) – measure of disorder/randomness",
            "Carnot efficiency – maximum possible heat engine efficiency"
        ],
        funFacts: [
            "The 2nd law of thermodynamics explains why you can't un-scramble an egg — entropy always increases.",
            "A 100% efficient heat engine is impossible — always some energy lost as waste heat.",
            "Absolute zero (–273.15°C) is the coldest possible temperature — particles stop moving.",
            "Your body is a heat engine — you generate enough waste heat to boil 1 litre of water per hour!"
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Carnot_cycle_p-V_diagram.svg/400px-Carnot_cycle_p-V_diagram.svg.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Refrigerator_Thermodynamic_cycle.svg/400px-Refrigerator_Thermodynamic_cycle.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Thermodynamics – Khan Academy", url: "https://www.khanacademy.org/science/chemistry/thermodynamics-chemistry", source: "Khan Academy"),
            LearningResource(id: 2, title: "Thermodynamics – Wikipedia", url: "https://en.wikipedia.org/wiki/Thermodynamics", source: "Wikipedia")
        ],
        summary: "Thermodynamics governs energy transfer. The 4 laws set absolute limits on heat engines and explain why entropy always grows. Refrigerators, car engines, and power plants all operate within these laws. Absolute zero marks the coldest possible state of matter.",
        relatedTopicIds: [1, 4],
        sinhaleName: "තාප ගතිකය",
        sinhalaDescription: """
තාප ගතිකය උෂ්ණත්වය, තාපය, කාර්යය සහ ශක්ති හුවමාරුව පිළිබඳ අධ්‍යයනය කරයි. මෙහි නිතී, තාප යන්ත්‍ර, ශ්‍රොපිය සහ යන්ත්‍ර, ශීතකාරක, දේශගුණ විද්‍යාව ඇතුළු ව්‍යවහාරික යෙදීම් ඇතුළත් වේ.
""",
        sinhalaKeyConcepts: [
            "1 වන නියමය: ශක්තිය නිර්මාණය හෝ විනාශ නොවේ",
            "2 වන නියමය: ශ්‍රොපිය සැමවිටම වැඩිවේ",
            "3 වන නියමය: නිරපේක්ෂ ශුන්‍ය (0 K) ළඟාවිය නොහැකිය",
            "තාපය (Q) – උෂ්ණත්ව වෙනස නිසා හුවමාරු ශක්තිය",
            "ශ්‍රොපිය (S) – අවිනිශ්චිතතාවෙහි මිනුම"
        ],
        sinhalaSummary: "තාප ගතිකය ශක්ති හුවමාරුව පාලනය කරයි. 4 නිතී ශ්‍රොපිය සැමවිටම වැඩිවන බව පෙන්වයි. ශීතකාරක, ඩීසල් යන්ත්‍ර සහ ජල විදුලිය මෙම නිතී යටතේ ක්‍රියා කරයි."
    ),

    // ── AIR PRESSURE (new topic for short-video link testing) ────────────────
    Topic(
        id: 21,
        name: "Air Pressure",
        subject: "Science",
        description: """
Air pressure is the force exerted by the weight of the atmosphere on any surface below it. At sea level, this pressure is approximately 101,325 pascals (1 atm). Atmospheric pressure decreases with altitude. It drives weather patterns, allows us to breathe, and enables many everyday phenomena like sucking through a straw.
""",
        videos: [
            TopicVideo(id: 1, title: "Air Pressure — Crushing a Drum", duration: "2:45", videoUrl: "https://www.youtube.com/watch?v=A3524wNjxHk"),
            TopicVideo(id: 2, title: "Atmospheric Pressure Explained", duration: "8:20", videoUrl: "https://www.youtube.com/watch?v=iu0fBrY-5Vo"),
            TopicVideo(id: 3, title: "Bernoulli's Principle & Air Pressure", duration: "11:00", videoUrl: "https://www.youtube.com/watch?v=TUqMqAkQ2Ys")
        ],
        keyConcepts: [
            "Atmospheric pressure ≈ 101,325 Pa at sea level",
            "1 atm = 760 mmHg = 101.325 kPa",
            "Pressure decreases ~12 Pa for every 1 m increase in altitude",
            "Boyle's Law: P × V = constant (at fixed temperature)",
            "Pascal's Principle: pressure applied to fluid transmits equally",
            "Barometer – instrument to measure air pressure",
            "Vacuum – space with pressure much lower than atmosphere"
        ],
        funFacts: [
            "The entire atmosphere above you weighs about 10,000 kg per square metre — the same as an elephant on every square metre of your body!",
            "We don't feel this pressure because our bodies have equal internal pressure pushing outward.",
            "A simple 55-gallon steel drum can be crushed by atmospheric pressure when the air inside is removed.",
            "At the top of Mount Everest, air pressure is only about 33% of sea-level pressure.",
            "Suction cups work by removing air — the surrounding atmospheric pressure pushes the cup against the surface."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Atmosphere_layers.svg/400px-Atmosphere_layers.svg.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Barometer_mercury_column_en.svg/200px-Barometer_mercury_column_en.svg.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Boyle%27s_Law_animated.gif/400px-Boyle%27s_Law_animated.gif"
        ],
        resources: [
            LearningResource(id: 1, title: "Atmospheric Pressure – Khan Academy", url: "https://www.khanacademy.org/science/physics/fluids/pressure-and-pascals-principle/a/what-is-pressure", source: "Khan Academy"),
            LearningResource(id: 2, title: "Atmospheric Pressure – Wikipedia", url: "https://en.wikipedia.org/wiki/Atmospheric_pressure", source: "Wikipedia"),
            LearningResource(id: 3, title: "NASA: Atmosphere Layers", url: "https://www.nasa.gov/mission_pages/sunearth/science/atmosphere-layers2.html", source: "NASA"),
            LearningResource(id: 4, title: "Boyle's Law – Physics Classroom", url: "https://www.physicsclassroom.com/class/gases/Lesson-2/Boyle-s-Law", source: "The Physics Classroom")
        ],
        summary: "Air pressure is the weight of the atmosphere pressing down on surfaces. At sea level it is ~101,325 Pa. It decreases with altitude. Pascal's Principle and Boyle's Law describe how pressure behaves in fluids and gases. Everyday examples include straws, suction cups, and crushable drums.",
        relatedTopicIds: [3, 5],
        sinhaleName: "වායු පීඩනය",
        sinhalaDescription: """
වායු පීඩනය යනු වායුගෝලය ඕනෑම මතුපිටකට ඇති කරන බලයයි. මුහුදු මට්ටමේදී මෙය ආසන්න වශයෙන් 101,325 Pa (1 atm) වේ. උසට ගිය විට වායු පීඩනය අඩු වේ. කාලගුණ රටා, හුස්ම ගැනීම සහ දිනචරිය ජීවිතයේ බොහෝ සංසිද්ධිවලට වායු පීඩනය බලපායි.
""",
        sinhalaKeyConcepts: [
            "වායුගෝල පීඩනය ≈ 101,325 Pa (මුහුදු මට්ටමේ)",
            "1 atm = 760 mmHg = 101.325 kPa",
            "බොයිල් නියමය: P × V = නියතය",
            "පැස්කල් ප්‍රතිපාදය: ද්‍රව්‍ය හරහා පීඩනය සමානව සම්ප්‍රේෂිත වේ",
            "බේරෝමීටරය – වායු පීඩනය මැනීමේ උපකරණය",
            "රික්තය – වායුගෝල පීඩනයට වඩා පහළ පීඩනය ඇති අවකාශය"
        ],
        sinhalaSummary: "වායු පීඩනය යනු ධරා ගෝල වායු ස්ථරයේ බරෙන් ඇතිවන බලයයි. මුහුදු මට්ටමේ ~101,325 Pa, උසේ ගිය විට අඩු වේ. රෝස තෙලු කෝප්ප, නල, සහ ට්‍රොම්බෝ (drum) ඒ.ස.ව. ශ‍ොෂිත කිරීම දෛනික ජීවිතේ උදාහරණ ලෙස දැක්විය හැකිය."
    ),

    // ─── MATHS ───────────────────────────────────────────────────────────────

    Topic(
        id: 6,
        name: "Algebra",
        subject: "Maths",
        description: """
Algebra deals with symbols and rules for manipulating them. Topics include variables, equations, functions, polynomials, and inequalities. Algebra is the foundation for higher mathematics, problem solving, and applications in science and engineering.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Algebra", duration: "9:50", videoUrl: "https://www.youtube.com/watch?v=NybHckSEQBI"),
            TopicVideo(id: 2, title: "Equations & Expressions", duration: "11:30", videoUrl: "https://www.youtube.com/watch?v=Ge0-f7n2_gY")
        ],
        keyConcepts: [
            "Variable – symbol representing an unknown value",
            "Expression – combination of variables and numbers",
            "Equation – statement that two expressions are equal",
            "Linear equation: ax + b = 0",
            "Quadratic equation: ax² + bx + c = 0",
            "Function: maps each input to exactly one output",
            "FOIL method for expanding (a+b)(c+d)"
        ],
        funFacts: [
            "The word 'algebra' comes from the Arabic 'al-jabr' meaning 'reunion of broken parts'.",
            "Al-Khwarizmi, a 9th-century Persian mathematician, is considered the father of algebra.",
            "Algebra is used in everything from financial modeling to computer graphics to cryptography.",
            "The quadratic formula (–b ± √(b²–4ac) / 2a) was known to Babylonian mathematicians 4,000 years ago!"
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Quadratic_formula.svg/400px-Quadratic_formula.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Algebra – Khan Academy", url: "https://www.khanacademy.org/math/algebra", source: "Khan Academy"),
            LearningResource(id: 2, title: "Algebra – Wikipedia", url: "https://en.wikipedia.org/wiki/Algebra", source: "Wikipedia")
        ],
        summary: "Algebra lets us solve problems with unknown quantities using symbols and equations. From linear to quadratic equations, algebra is the gateway to all advanced mathematics.",
        relatedTopicIds: [7, 8],
        sinhaleName: "බීජ ගණිතය",
        sinhalaDescription: "බීජ ගණිතය සංකේත සහ ඒවා හැසිරවීමේ නිතී පිළිබඳ ය. විචල්‍ය, සමීකරණ, ශ්‍රිත, බහුපද සහ අසමානතා ඇතුළත් වේ. ගණිතයේ ඉහළ ශාඛා සඳහා පදනම ලෙස ක්‍රියා කරයි.",
        sinhalaKeyConcepts: [
            "විචල්‍ය – නොදන්නා අගය නියෝජනය කරන සංකේතය",
            "සමීකරණය – ප්‍රකාශන දෙකක් සමාන ය යන ප්‍රකාශය",
            "රේඛීය සමීකරණය: ax + b = 0",
            "ද්විමාත්‍ර සමීකරණය: ax² + bx + c = 0",
            "ශ්‍රිතය – සෑම ආදාන අගයකටම ඒකීය ප්‍රතිදානයක් ලබා දෙයි"
        ],
        sinhalaSummary: "බීජ ගණිතය සංකේත සහ සමීකරණ යොදා ගෙන නොදන්නා ප්‍රමාණ ශ්‍රේෂ්ඨ ලෙස විසඳීමට ඉඩ සලසයි."
    ),

    Topic(
        id: 7,
        name: "Geometry",
        subject: "Maths",
        description: """
Geometry studies shapes, sizes, positions, and spatial relationships. Topics include points, lines, angles, triangles, circles, and polygons. Geometry is essential for mathematics, architecture, engineering, and real-world problem solving.
""",
        videos: [
            TopicVideo(id: 1, title: "Basic Geometry Concepts", duration: "10:25", videoUrl: "https://www.youtube.com/watch?v=g1ib43q3uXQ"),
            TopicVideo(id: 2, title: "Triangles and Pythagoras", duration: "12:00", videoUrl: "https://www.youtube.com/watch?v=CAkMUdeB06o")
        ],
        keyConcepts: [
            "Point, line, ray, line segment",
            "Angle types: acute, right, obtuse, straight, reflex",
            "Triangle types: equilateral, isosceles, scalene",
            "Pythagorean theorem: a² + b² = c²",
            "Circle: area = πr², circumference = 2πr",
            "Congruence vs Similarity",
            "Area and perimeter of common shapes"
        ],
        funFacts: [
            "The word 'geometry' means 'earth measurement' in Greek — ancient Egyptians used it to re-draw farm boundaries after Nile floods.",
            "Pythagoras' theorem was known to Babylonians 1,000 years before Pythagoras!",
            "Honeybees build hexagonal cells — the most efficient shape for storing honey with minimum wax.",
            "The Great Pyramid of Giza's base has a perimeter of 922 m and is almost a perfect square."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Pythagorean.svg/400px-Pythagorean.svg.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Circle_slices.svg/400px-Circle_slices.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Geometry – Khan Academy", url: "https://www.khanacademy.org/math/geometry", source: "Khan Academy"),
            LearningResource(id: 2, title: "Geometry – Wikipedia", url: "https://en.wikipedia.org/wiki/Geometry", source: "Wikipedia")
        ],
        summary: "Geometry studies shapes and space. Pythagoras' theorem (a²+b²=c²) is its most famous result. From triangles to circles, geometry is used in architecture, GPS, and computer graphics every day.",
        relatedTopicIds: [6, 8],
        sinhaleName: "ජ්‍යාමිතිය",
        sinhalaDescription: "ජ්‍යාමිතිය ස්වරූප, ප්‍රමාණ, ස්ථාන සහ අවකාශ සම්බන්ධතා අධ්‍යයනය කරයි. ගොඩනැඟිලි, ඉංජිනේරු හා ව්‍යාවහාරික ගැටළු විසඳීමේ මූලිකාංශයයි.",
        sinhalaKeyConcepts: [
            "කෝණ වර්ග: උග්‍ර, ලම්භ, ස්ථූල, ගොනු",
            "ත්‍රිකෝණ: සම, ද්විබාහු, සාමාන්‍ය",
            "පිතාගරස් ප්‍රමේය: a² + b² = c²",
            "වෘත්ත: ක්ෂේත්‍රය = πr², පරිධිය = 2πr"
        ],
        sinhalaSummary: "ජ්‍යාමිතිය ස්වරූප හා අවකාශය අධ්‍යයනය කරයි. පිතාගරස් ප්‍රමේය (a²+b²=c²) මෙහි ප්‍රසිද්ධ ප්‍රතිඵලයකි."
    ),

    Topic(
        id: 8,
        name: "Calculus",
        subject: "Maths",
        description: """
Calculus studies change and motion through derivatives and integrals. Topics include limits, differentiation, integration, and applications in physics, engineering, and economics.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Calculus", duration: "12:10", videoUrl: "https://www.youtube.com/watch?v=WUvTyaaNkzM"),
            TopicVideo(id: 2, title: "Derivatives Explained", duration: "14:30", videoUrl: "https://www.youtube.com/watch?v=9vKqVkMQHKk")
        ],
        keyConcepts: [
            "Limit – value a function approaches as input approaches a point",
            "Derivative – instantaneous rate of change (slope of tangent)",
            "Integral – area under a curve",
            "Fundamental Theorem of Calculus: links derivatives and integrals",
            "Chain Rule for composite function derivatives",
            "Power Rule: d/dx(xⁿ) = nxⁿ⁻¹",
            "Definite vs Indefinite integrals"
        ],
        funFacts: [
            "Newton and Leibniz independently invented calculus at nearly the same time in the 1660s–1680s.",
            "Without calculus, we couldn't calculate planetary orbits, design aircraft, or predict stock markets.",
            "The GPS in your phone uses calculus-based algorithms to calculate your position.",
            "Calculus was invented to solve the problem of calculating the area under curves."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Tangent-calculus.svg/400px-Tangent-calculus.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Calculus – Khan Academy", url: "https://www.khanacademy.org/math/calculus-1", source: "Khan Academy"),
            LearningResource(id: 2, title: "Calculus – Wikipedia", url: "https://en.wikipedia.org/wiki/Calculus", source: "Wikipedia")
        ],
        summary: "Calculus studies change. Derivatives give instantaneous rates of change; integrals give areas and totals. Together they describe the physical world — from planetary motion to quantum mechanics.",
        relatedTopicIds: [6, 9],
        sinhaleName: "ගණනය (Calculus)",
        sinhalaDescription: "ගණනය (Calculus) ව්‍යුත්පන්න (derivatives) සහ අනුකලන (integrals) හරහා වෙනස්කම් සහ චලනය අධ්‍යයනය කරයි.",
        sinhalaKeyConcepts: [
            "සීමාව – ශ්‍රිතයක් ළඟාවන අගය",
            "ව්‍යුත්පන්නය – ක්ෂණිකව වෙනස් වීමේ අනුපාතය",
            "අනුකලනය – රේඛාවක් යටතේ ඇති ක්ෂේත්‍රය",
            "ප්‍රාථමික ප්‍රමේය: ව්‍යුත්පන්න හා අනුකලන සම්බන්ධ කරයි"
        ],
        sinhalaSummary: "Calculus වෙනස්කම් අධ්‍යයනය කරයි. ව්‍යුත්පන්නය ක්ෂණිකව වෙනස් වීමේ අනුපාතය ලබා දෙයි; අනුකලනය ප්‍රදේශ ලබා දෙයි."
    ),

    Topic(
        id: 9,
        name: "Statistics",
        subject: "Maths",
        description: """
Statistics is the study of data collection, analysis, interpretation, and presentation. Topics include probability, mean, median, variance, standard deviation, and hypothesis testing. Statistics is widely used in science, business, and social studies.
""",
        videos: [
            TopicVideo(id: 1, title: "Basics of Statistics", duration: "10:00", videoUrl: "https://www.youtube.com/watch?v=uhxtUt_-GyM"),
            TopicVideo(id: 2, title: "Probability and Distributions", duration: "13:45", videoUrl: "https://www.youtube.com/watch?v=KzfWUEJjG18")
        ],
        keyConcepts: [
            "Mean – arithmetic average of a dataset",
            "Median – middle value when sorted",
            "Mode – most frequently occurring value",
            "Standard Deviation – spread of data around the mean",
            "Variance – square of standard deviation",
            "Probability: P(event) = favourable / total outcomes",
            "Normal distribution – bell curve"
        ],
        funFacts: [
            "Florence Nightingale was a pioneering statistician who used data visualization to save lives during the Crimean War.",
            "The entire US Census uses complex statistical sampling because counting every person is impractical.",
            "Netflix saves $1 billion per year by using statistics to recommend shows you'll keep watching.",
            "The birthday paradox: in a group of just 23 people, there's a >50% chance two share a birthday."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Standard_deviation_diagram.svg/400px-Standard_deviation_diagram.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Statistics & Probability – Khan Academy", url: "https://www.khanacademy.org/math/statistics-probability", source: "Khan Academy"),
            LearningResource(id: 2, title: "Statistics – Wikipedia", url: "https://en.wikipedia.org/wiki/Statistics", source: "Wikipedia")
        ],
        summary: "Statistics turns raw data into meaningful insights. Mean, median, and mode describe central tendency; standard deviation describes spread. Probability measures likelihood of events. Used everywhere from medicine to machine learning.",
        relatedTopicIds: [6, 8],
        sinhaleName: "සංඛ්‍යාන",
        sinhalaDescription: "සංඛ්‍යාන යනු දත්ත එකතු කිරීම, විශ්ලේෂණය, අර්ථ නිරූපණය සහ ඉදිරිපත් කිරීමේ අධ්‍යයනයයි.",
        sinhalaKeyConcepts: [
            "මධ්‍යකය – දත්ත කට්ටලයේ අංකගණිත සාමාන්‍යය",
            "මාධ්‍ය – වර්ග කළ විට මැද අගය",
            "ප්‍රමිත අපගමනය – සාමාන්‍යයේ සිට දත්ත ව්‍යාප්තිය",
            "සම්භාවිතාව: P = හිතකර / මුළු ප්‍රතිඵල"
        ],
        sinhalaSummary: "සංඛ්‍යාන අමු දත්ත අර්ථවත් අවබෝධයකට පරිවර්තනය කරයි. ඖෂධ, ව්‍යාපාර, සහ AI ඇතුළු සෑම ක්ෂේත්‍රයකම භාවිතා වේ."
    ),

    // ─── PROGRAMMING ─────────────────────────────────────────────────────────

    Topic(
        id: 10,
        name: "Swift Basics",
        subject: "Programming",
        description: """
Swift is a modern programming language for Apple platforms. This topic introduces variables, constants, data types, operators, control flow, functions, and basic object-oriented concepts. Learning Swift basics is essential for app development.
""",
        videos: [
            TopicVideo(id: 1, title: "Variables & Constants", duration: "8:30", videoUrl: "https://www.youtube.com/watch?v=Ulp1Kimblg0"),
            TopicVideo(id: 2, title: "Control Flow in Swift", duration: "12:00", videoUrl: "https://www.youtube.com/watch?v=dJ8wG0RPQGE")
        ],
        keyConcepts: [
            "var – mutable variable declaration",
            "let – immutable constant declaration",
            "Type inference – Swift infers types automatically",
            "Optionals (?) – variables that may be nil",
            "if / else, switch, for, while control flow",
            "Functions: func name(params) -> ReturnType { }",
            "Struct vs Class – value vs reference types"
        ],
        funFacts: [
            "Swift was developed by Chris Lattner at Apple, with work starting in 2010.",
            "Swift replaced Objective-C for Apple development — it is much safer and faster to write.",
            "Swift is open-source and now runs on Linux too, not just Apple platforms.",
            "Swift's type system prevents entire categories of bugs common in C/Objective-C."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Swift_logo.svg/400px-Swift_logo.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Swift Docs – Apple", url: "https://developer.apple.com/swift/", source: "Apple"),
            LearningResource(id: 2, title: "Hacking with Swift", url: "https://www.hackingwithswift.com/read", source: "HackingWithSwift")
        ],
        summary: "Swift is Apple's modern, safe programming language. var is mutable, let is constant. Optionals handle nil safely. Control flow, functions, and structs form the building blocks of any Swift app.",
        relatedTopicIds: [11, 12],
        sinhaleName: "Swift මූලික කරුණු",
        sinhalaDescription: "Swift Apple ප්ලැට්ෆෝම සඳහා නිර්මිත නූතන ක්‍රමලේඛන භාෂාවකි. විචල්‍ය, නියතාංශ, දත්ත වර්ග, සහ ශ්‍රිත ඉගෙනීම app සංවර්ධනය ආරම්භ කිරීමට අත්‍යවශ්‍ය ය.",
        sinhalaKeyConcepts: [
            "var – විකෘති විචල්‍ය",
            "let – නොවෙනස් නියතාංශ",
            "Optionals (?) – nil විය හැකි විචල්‍ය",
            "ශ්‍රිත: func නාමය(params) -> ප්‍රතිලාභ { }"
        ],
        sinhalaSummary: "Swift Apple හි නූතන ආරක්ෂිත ක්‍රමලේඛන භාෂාවයි. var, let, Optionals, සහ ශ්‍රිත Swift app ගේ ගොඩ නැගීමේ කොටස් ය."
    ),

    Topic(
        id: 11,
        name: "Data Structures",
        subject: "Programming",
        description: """
Data structures organize data for efficient access and modification. Topics include arrays, linked lists, stacks, queues, trees, and graphs. Understanding data structures is essential for algorithm design and programming.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Data Structures", duration: "11:45", videoUrl: "https://www.youtube.com/watch?v=RBSGKlAvoiM"),
            TopicVideo(id: 2, title: "Arrays and Linked Lists", duration: "14:20", videoUrl: "https://www.youtube.com/watch?v=njTh_OwMljA")
        ],
        keyConcepts: [
            "Array – ordered, fixed-size collection with O(1) access",
            "Linked List – nodes connected by pointers",
            "Stack – LIFO (Last In, First Out)",
            "Queue – FIFO (First In, First Out)",
            "Tree – hierarchical structure with parent/child nodes",
            "Binary Search Tree – left < root < right",
            "Graph – nodes (vertices) connected by edges"
        ],
        funFacts: [
            "The 'undo' feature in apps uses a Stack data structure.",
            "Your browser's back button uses a Stack — each visited page is pushed on, back pops it.",
            "Social networks like Facebook model friendships as graphs with billions of nodes.",
            "The binary search algorithm only works because data is sorted — it cuts search time from O(n) to O(log n)."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Binary_tree.svg/400px-Binary_tree.svg.png",
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Deque.svg/400px-Deque.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "Data Structures – GeeksForGeeks", url: "https://www.geeksforgeeks.org/data-structures/", source: "GeeksForGeeks"),
            LearningResource(id: 2, title: "Data Structures – Wikipedia", url: "https://en.wikipedia.org/wiki/Data_structure", source: "Wikipedia")
        ],
        summary: "Data structures organise data for efficient use. Arrays give O(1) access, stacks are LIFO, queues are FIFO, and trees/graphs model hierarchical and relational data. Choosing the right structure determines algorithm speed.",
        relatedTopicIds: [10, 12],
        sinhaleName: "දත්ත ව්‍යූහ",
        sinhalaDescription: "දත්ත ව්‍යූහ දත්ත කාර්යක්ෂමව ප්‍රවේශ වීම සහ සංශෝධනය කිරීම සඳහා සංවිධානය කරයි. Array, Linked List, Stack, Queue, Tree, Graph ඇතුළු ව්‍යූහ ඇතුළත් වේ.",
        sinhalaKeyConcepts: [
            "Array – O(1) ප්‍රවේශ සහිත ක්‍රමානුකූල එකතුව",
            "Stack – LIFO (අවසානයෙන් ඇතුළු, අවසානයෙන් ඉවත)",
            "Queue – FIFO (ප්‍රථමයෙන් ඇතුළු, ප්‍රථමයෙන් ඉවත)",
            "Tree – ධූරාවලි ව්‍යූහය"
        ],
        sinhalaSummary: "දත්ත ව්‍යූහ දත්ත කාර්යක්ෂමව භාවිතය සඳහා සංවිධානය කරයි. නිවැරදි ව්‍යූහය තෝරා ගැනීම ඇල්ගොරිතම වේගය නිර්ණය කරයි."
    ),

    Topic(
        id: 12,
        name: "Object-Oriented Programming",
        subject: "Programming",
        description: """
OOP is a programming paradigm using objects and classes. Topics include inheritance, polymorphism, encapsulation, and abstraction. OOP improves code modularity, reusability, and maintainability.
""",
        videos: [
            TopicVideo(id: 1, title: "OOP Concepts", duration: "13:20", videoUrl: "https://www.youtube.com/watch?v=pTB0EiLXUC8"),
            TopicVideo(id: 2, title: "Classes and Inheritance", duration: "11:05", videoUrl: "https://www.youtube.com/watch?v=pTB0EiLXUC8")
        ],
        keyConcepts: [
            "Class – blueprint for creating objects",
            "Object – instance of a class",
            "Encapsulation – bundling data and methods, hiding internals",
            "Inheritance – child class inherits from parent",
            "Polymorphism – same method name, different behaviour",
            "Abstraction – hiding complex details, exposing simple interface",
            "SOLID principles for good OOP design"
        ],
        funFacts: [
            "OOP was first developed in the 1960s in Simula, a Norwegian programming language.",
            "Smalltalk (1972) popularised OOP — Alan Kay coined the term 'object-oriented'.",
            "Java was designed from the ground up to be object-oriented.",
            "Swift uses both OOP and Protocol-Oriented Programming — Apple calls Swift 'protocol-first'."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/CPT-OOP-objects_and_classes_-_attmeth.svg/400px-CPT-OOP-objects_and_classes_-_attmeth.svg.png"
        ],
        resources: [
            LearningResource(id: 1, title: "OOP – GeeksForGeeks", url: "https://www.geeksforgeeks.org/object-oriented-programming-oops-concept-in-java/", source: "GeeksForGeeks"),
            LearningResource(id: 2, title: "OOP – Wikipedia", url: "https://en.wikipedia.org/wiki/Object-oriented_programming", source: "Wikipedia")
        ],
        summary: "OOP models software as objects with data and behaviour. The four pillars are Encapsulation, Inheritance, Polymorphism, and Abstraction. OOP makes large codebases manageable and reusable.",
        relatedTopicIds: [10, 11],
        sinhaleName: "Object-Oriented Programming",
        sinhalaDescription: "OOP යනු Objects සහ Classes භාවිතා කරන ක්‍රමලේඛන ආකෘතියයි. Inheritance, Polymorphism, Encapsulation, Abstraction ප්‍රධාන සංකල්ප ය.",
        sinhalaKeyConcepts: [
            "Class – Objects නිර්මාණය සඳහා ආකෘතිය",
            "Object – Class හි නිදර්ශකය",
            "Encapsulation – දත්ත සහ ක්‍රම එකතු කිරීම",
            "Inheritance – ළමා Class, ජනක Class ව‌ෙතින් උරුම ගනී",
            "Polymorphism – එකම ක්‍රමයේ නාමය, වෙනත් හැසිරීම"
        ],
        sinhalaSummary: "OOP Software Objects ලෙස ආකෘතිගත කරයි. Encapsulation, Inheritance, Polymorphism, Abstraction යන සතර ශ්‍රේෂ්ඨ ගුණ OOP ශ්‍රේෂ්ඨ කරයි."
    ),

    // ─── HISTORY ─────────────────────────────────────────────────────────────

    Topic(
        id: 16,
        name: "World War II",
        subject: "History",
        description: """
World War II was a global conflict from 1939 to 1945 involving major world powers. Topics include causes of the war, major battles, political leaders, the Holocaust, technological advancements, and the war's impact on global politics and society.
""",
        videos: [
            TopicVideo(id: 1, title: "WWII Overview", duration: "15:00", videoUrl: "https://www.youtube.com/watch?v=_uk_6vfqwTA"),
            TopicVideo(id: 2, title: "Key Battles of WWII", duration: "17:30", videoUrl: "https://www.youtube.com/watch?v=fo2Rb9h788s")
        ],
        keyConcepts: [
            "Causes: Treaty of Versailles, Great Depression, rise of fascism",
            "Allied Powers: UK, USA, USSR, France",
            "Axis Powers: Germany, Italy, Japan",
            "Holocaust – genocide of ~6 million Jewish people",
            "D-Day (6 June 1944) – Allied invasion of Normandy",
            "Manhattan Project – development of atomic bomb",
            "VE Day (8 May 1945) – Germany surrenders"
        ],
        funFacts: [
            "WWII was the deadliest conflict in human history — estimates range from 70 to 85 million deaths.",
            "The Enigma machine's cipher was broken by Alan Turing — historians say this shortened the war by 2 years.",
            "More Soviet citizens died in WWII (estimated 27 million) than any other nation.",
            "The first electronic computer ENIAC was developed partly to calculate artillery trajectories during WWII."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Allied_World_War_II.png/400px-Allied_World_War_II.png"
        ],
        resources: [
            LearningResource(id: 1, title: "WWII – Khan Academy", url: "https://www.khanacademy.org/humanities/world-history/euro-hist/wwii-casualties/a/world-war-ii-an-overview-article", source: "Khan Academy"),
            LearningResource(id: 2, title: "World War II – Wikipedia", url: "https://en.wikipedia.org/wiki/World_War_II", source: "Wikipedia"),
            LearningResource(id: 3, title: "WWII Museum", url: "https://www.nationalww2museum.org/students-teachers", source: "National WWII Museum")
        ],
        summary: "WWII (1939–1945) was the deadliest war in history. Allied forces defeated the Axis powers. The Holocaust killed ~6 million Jews. The war ended with atomic bombs on Hiroshima and Nagasaki and led to the creation of the United Nations.",
        relatedTopicIds: [17, 18],
        sinhaleName: "දෙවන ලෝක යුද්ධය",
        sinhalaDescription: "1939–1945 දෙවන ලෝක යුද්ධය ලෝකයේ ප්‍රධාන රාජ්‍යයන් සම්බන්ධ ගෝලීය ගැටුමක් විය. යුද්ධයේ හේතු, ප්‍රධාන සටන්, Holocaust, සහ ලෝකයට ඇති කළ බලපෑම ඇතුළත් ය.",
        sinhalaKeyConcepts: [
            "හේතු: Versailles ගිවිසුම, ආර්ථික අවකාශය, ෆැසිස්ට්වාදයේ නැගීම",
            "සන්ධාන බලවේග: UK, USA, USSR, France",
            "Axis: ජර්මනිය, ඉතාලිය, ජපානය",
            "Holocaust – ~60 ලක්ෂ යුදෙව් ජනයාගේ ඝාතනය",
            "D-Day (1944.06.06) – නෝර්මන්ඩි ආක්‍රමණය"
        ],
        sinhalaSummary: "WWII (1939–1945) ඉතිහාසයේ රෞද්‍රතම යුද්ධය විය. Axis රාජ්‍යයන් Allied රාජ්‍යයන් විසින් පරාජය කළේ ය. Holocaust, Hiroshima, Nagasaki, සහ UN ස්ථාපනය ඊට ප‍රවෘති ය."
    ),

    Topic(
        id: 17,
        name: "Ancient Civilizations",
        subject: "History",
        description: """
Study of early civilizations such as Egypt, Greece, and Rome. Topics include culture, governance, economy, architecture, and achievements. Understanding ancient civilizations helps explain the roots of modern society.
""",
        videos: [
            TopicVideo(id: 1, title: "Egyptian Civilization", duration: "12:30", videoUrl: "https://www.youtube.com/watch?v=Z3Wvw6BuQvE"),
            TopicVideo(id: 2, title: "Ancient Greece Overview", duration: "14:10", videoUrl: "https://www.youtube.com/watch?v=z-TP6UxPHX4")
        ],
        keyConcepts: [
            "Mesopotamia – world's first civilization (~3500 BCE)",
            "Egyptian pharaohs – divine rulers of ancient Egypt",
            "Pyramids of Giza – built ~2560 BCE as royal tombs",
            "Greek democracy – developed in Athens ~507 BCE",
            "Roman Republic → Roman Empire",
            "Silk Road – trade route connecting East and West",
            "Cuneiform – earliest known writing system"
        ],
        funFacts: [
            "The Great Pyramid was the world's tallest man-made structure for 3,800 years!",
            "Ancient Romans had fast-food restaurants called 'thermopolia' — over 80 have been found in Pompeii.",
            "Cleopatra lived closer in time to the Moon landing than to the building of the Great Pyramid.",
            "Ancient Greeks believed the Earth was round — Eratosthenes calculated its circumference in 240 BCE with remarkable accuracy."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Kheops-Pyramid.jpg/400px-Kheops-Pyramid.jpg"
        ],
        resources: [
            LearningResource(id: 1, title: "Ancient History – Khan Academy", url: "https://www.khanacademy.org/humanities/world-history/ancient-medieval-history", source: "Khan Academy"),
            LearningResource(id: 2, title: "Ancient Civilizations – Wikipedia", url: "https://en.wikipedia.org/wiki/Ancient_history", source: "Wikipedia")
        ],
        summary: "Ancient civilizations like Mesopotamia, Egypt, Greece, and Rome laid the foundations of modern law, democracy, architecture, science, and culture. Their achievements echo in every aspect of today's world.",
        relatedTopicIds: [16, 18],
        sinhaleName: "පුරාණ ශිෂ්ටාචාර",
        sinhalaDescription: "ඊජිප්තු, ග්‍රීසිය, රෝමය ආදී ශිෂ්ටාචාර අධ්‍යයනය. සංස්කෘතිය, පාලනය, ආර්ථිකය, ගෘහ නිර්මාණ ශිල්පය සහ ජයග්‍රහණ ඇතුළත් ය.",
        sinhalaKeyConcepts: [
            "මෙසපොතේමියාව – ලෝකයේ පළමු ශිෂ්ටාචාරය (~3500 BCE)",
            "ඊජිප්තු ගොළුවන් – දේව පාලකයින්",
            "ගිසාවේ පිරමිඩ – ~2560 BCE ඉදිකරන ලදී",
            "ග්‍රීක ප්‍රජාතන්ත්‍රවාදය – ~507 BCE"
        ],
        sinhalaSummary: "පුරාණ ශිෂ්ටාචාර නූතන නීතිය, ප්‍රජාතන්ත්‍රවාදය, ගෘහ නිර්මාණ ශිල්පය, විද්‍යාව සහ සංස්කෘතියේ පදනම දැමූවේය."
    ),

    Topic(
        id: 18,
        name: "Industrial Revolution",
        subject: "History",
        description: """
The Industrial Revolution brought technological and social changes in the 18th and 19th centuries. Topics include inventions, factories, urbanization, and economic transformation. It is key to understanding modern industry and society.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Industrial Revolution", duration: "14:10", videoUrl: "https://www.youtube.com/watch?v=zhL5DCizj5c"),
            TopicVideo(id: 2, title: "Steam Power and Factories", duration: "12:50", videoUrl: "https://www.youtube.com/watch?v=3TJ13gEQBCg")
        ],
        keyConcepts: [
            "Started in Britain ~1760, spread globally by 1900",
            "Steam engine – James Watt's improvement (1769) powered factories",
            "Cotton gin – Eli Whitney (1793) mechanized cotton processing",
            "Urbanization – mass migration from rural to urban areas",
            "Child labour – widespread exploitation in early factories",
            "Railways – dramatically reduced transport time and cost",
            "Led to capitalism and the modern global economy"
        ],
        funFacts: [
            "Before the Industrial Revolution, ~90% of people worked in agriculture.",
            "The Luddites (1811) smashed machines fearing job losses — their name is still used today.",
            "London's smog during the revolution was so thick that streetlamps were needed at midday.",
            "Life expectancy in early industrial cities was often below 30 due to disease and poor conditions."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Gipkens_Watt_steam_engine.jpg/400px-Gipkens_Watt_steam_engine.jpg"
        ],
        resources: [
            LearningResource(id: 1, title: "Industrial Revolution – Khan Academy", url: "https://www.khanacademy.org/humanities/world-history/1600s-1800s/the-industrial-revolution/a/intro-to-the-industrial-revolution", source: "Khan Academy"),
            LearningResource(id: 2, title: "Industrial Revolution – Wikipedia", url: "https://en.wikipedia.org/wiki/Industrial_Revolution", source: "Wikipedia")
        ],
        summary: "The Industrial Revolution (1760–1900) transformed agriculture-based economies into manufacturing powerhouses. Steam power, factories, railways, and urbanization reshaped society. It created both unprecedented wealth and severe social inequalities.",
        relatedTopicIds: [16, 17],
        sinhaleName: "කාර්මික විප්ලවය",
        sinhalaDescription: "18 හා 19 සියවස්වල කාර්මික විප්ලවය තාක්ෂණික හා සමාජීය වෙනස්කම් ගෙනා. කල්‍යාරු, කර්මාන්ත ශාලා, නාගරීකරණය සහ ආර්ථික පරිවර්තනය ඇතුළත් ය.",
        sinhalaKeyConcepts: [
            "~1760 දී බ්‍රිතාන්‍යයේ ආරම්භ වූ කාර්මික විප්ලවය",
            "වාෂ්ප එන්ජිම – ජේම්ස් වොට් (1769)",
            "Cotton Gin – Eli Whitney (1793)",
            "නාගරීකරණය – ග්‍රාමීය ජනයා නගරවලට ගලා ආ"
        ],
        sinhalaSummary: "කාර්මික විප්ලවය (1760–1900) ගොවිතැන් ආශ්‍රිත ආර්ථිකය කාර්මික ශක්‍ය ආර්ථිකයකට පරිවර්තනය කළේ ය."
    ),

    // ─── GEOGRAPHY ───────────────────────────────────────────────────────────

    Topic(
        id: 19,
        name: "Rivers of the World",
        subject: "Geography",
        description: """
Rivers are natural watercourses important for ecology, transport, agriculture, and human settlements. Topics include major rivers, river systems, hydrology, and the environmental impact of human activity.
""",
        videos: [
            TopicVideo(id: 1, title: "Major Rivers Overview", duration: "11:00", videoUrl: "https://www.youtube.com/watch?v=YwVAGVcncdk"),
            TopicVideo(id: 2, title: "Nile River – The Longest River", duration: "13:20", videoUrl: "https://www.youtube.com/watch?v=gJkJJGn6n1A")
        ],
        keyConcepts: [
            "River – natural watercourse flowing toward ocean/lake",
            "Nile (6,650 km) – longest river in the world",
            "Amazon – world's largest river by water volume",
            "Watershed – area of land draining into a river",
            "Erosion – rivers carve valleys and canyons",
            "Floodplain – flat land beside a river liable to flood",
            "Delta – sediment deposit at river mouth"
        ],
        funFacts: [
            "The Amazon River discharges 20% of all freshwater entering the world's oceans.",
            "The River Nile flows northward — one of the few major rivers in the world to do so.",
            "The Yangtze River in China is home to the world's largest hydroelectric dam — the Three Gorges Dam.",
            "Antarctica is the driest continent on Earth, yet it holds 60% of the world's fresh water as ice."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Nile_River_and_delta_from_orbit.jpg/400px-Nile_River_and_delta_from_orbit.jpg"
        ],
        resources: [
            LearningResource(id: 1, title: "Rivers – National Geographic", url: "https://education.nationalgeographic.org/resource/river/", source: "National Geographic"),
            LearningResource(id: 2, title: "List of Rivers – Wikipedia", url: "https://en.wikipedia.org/wiki/List_of_rivers_by_length", source: "Wikipedia")
        ],
        summary: "Rivers are vital for life, transport, and agriculture. The Nile (6,650 km) is the longest; the Amazon moves the most water. Rivers erode land, form deltas and floodplains, and support billions of people.",
        relatedTopicIds: [20],
        sinhaleName: "ලෝකයේ ගංගා",
        sinhalaDescription: "ගංගා පාරිසරික, ප්‍රවාහන, කෘෂිකාර්මික හා ජනාවාස ශිෂ්ටාචාර සඳහා වැදගත් ය.",
        sinhalaKeyConcepts: [
            "නයිල් (6,650 km) – ලෝකේ දිගම ගඟ",
            "Amazon – ජල ප්‍රමාණයෙන් ලොකුම ගඟ",
            "Delta – ගඟ ළඟ ක‌ෙළවරේ රෙදිලි",
            "ජල ශිරා (Watershed) – ගඟකට ගලා එන ගොඩ"
        ],
        sinhalaSummary: "ගංගා ජීවිතය, ප්‍රවාහනය, සහ කෘෂිකාර්මය සඳහා වැදගත් ය. නයිල් දිගම; Amazon ලොකු ජල ප‍්‍රවාහය."
    ),

    Topic(
        id: 20,
        name: "Mountains and Plateaus",
        subject: "Geography",
        description: """
Mountains and plateaus shape Earth's surface and influence climate, biodiversity, and human activity. Topics include mountain formation, major ranges, types of plateaus, and geological processes.
""",
        videos: [
            TopicVideo(id: 1, title: "Mountain Formation", duration: "10:50", videoUrl: "https://www.youtube.com/watch?v=6MtMiPmBOoA"),
            TopicVideo(id: 2, title: "Highest Mountains on Earth", duration: "9:30", videoUrl: "https://www.youtube.com/watch?v=5H7-LlMh6O4")
        ],
        keyConcepts: [
            "Mountain – landform rising at least 300 m above surroundings",
            "Mount Everest – 8,849 m — highest peak above sea level",
            "Himalayan Range – formed by India-Eurasia plate collision",
            "Plateau – flat-topped highland area",
            "Tibetan Plateau – world's highest and largest plateau",
            "Tectonic plates – Earth's crust divided into moving sections",
            "Erosion – wind and water wear mountains down over millions of years"
        ],
        funFacts: [
            "If measured from the Earth's centre, Chimborazo in Ecuador is farther from the centre than Everest!",
            "The Himalayas are still growing by about 5 mm per year as India continues pushing into Asia.",
            "Mount Olympus on Mars is 21 km high — nearly three times taller than Everest.",
            "The Rocky Mountains were formed by the subduction of the Pacific tectonic plate under North America."
        ],
        diagramImageURLs: [
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg/400px-Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg"
        ],
        resources: [
            LearningResource(id: 1, title: "Mountains – National Geographic", url: "https://education.nationalgeographic.org/resource/mountain/", source: "National Geographic"),
            LearningResource(id: 2, title: "Mountain – Wikipedia", url: "https://en.wikipedia.org/wiki/Mountain", source: "Wikipedia")
        ],
        summary: "Mountains and plateaus are formed by tectonic plate movement. The Himalayas are still growing. Everest (8,849 m) is the tallest peak. Plateaus like Tibet influence climate over vast regions.",
        relatedTopicIds: [19],
        sinhaleName: "කඳු හා සානු",
        sinhalaDescription: "කඳු හා සානු පෘථිවි මතුපිට හැඩ ගන්නා, දේශගුණය, ජෛව විවිධත්වය, හා ජනාවාස කෙරෙහි බලපායි.",
        sinhalaKeyConcepts: [
            "කඳු – පරිසරයට වඩා 300 m+ ඉහළ ගොඩ",
            "Everest – 8,849 m – ඉහළ ම කඳු මුදුන",
            "හිමාලය – ඉන්දිය-යුරේෂියා තලා ගැටීමෙන් ඇතිවූ",
            "Tibetan Plateau – ලෝකේ ඉහළ ම හා ලොකු ම සානුව"
        ],
        sinhalaSummary: "කඳු හා සානු තලා ගෙවීමෙන් ඇති වේ. හිමාලය තවමත් 5 mm/year ලෙස ඉහළ යයි. Everest (8,849 m) උසම කඳු මුදුනය."
    )
]
