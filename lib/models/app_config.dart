import 'package:flutter/material.dart';

class AppConfig {
  final String name;
  final String url;
  final String description;
  final List<String> keyFeatures;
  final String targetAudience;
  final String storyAngle;
  final Color primaryColor;
  final String appId;

  const AppConfig({
    required this.name,
    required this.url,
    required this.description,
    required this.keyFeatures,
    required this.targetAudience,
    required this.storyAngle,
    required this.primaryColor,
    required this.appId,
  });

  static const Map<String, AppConfig> apps = {
    'helpothon': AppConfig(
      name: "Helpothon",
      url: "https://helpothon.com/",
      description:
          "A platform dedicated to helping everyone, businesses, and communities by leveraging technology for good",
      keyFeatures: [
        "Technology for social good",
        "Community building",
        "Global impact",
      ],
      targetAudience:
          "Businesses and communities seeking positive technological impact",
      storyAngle:
          "Mission-driven technology company spreading smiles worldwide",
      primaryColor: Color(0xFF4CAF50), // Green for helping/good
      appId: 'helpothon',
    ),
    'scanmeee': AppConfig(
      name: "ScanMeee",
      url: "https://scanmeee.com/",
      description:
          "A fun QR code generator that creates and shares entertaining QR codes with various categories and themes",
      keyFeatures: [
        "Fun QR code creation",
        "Category-based themes",
        "Social sharing",
        "Entertainment focus",
      ],
      targetAudience:
          "Social media users, content creators, and anyone looking to add fun to QR codes",
      storyAngle:
          "Making QR codes entertaining and shareable for social engagement",
      primaryColor: Color(0xFF9C27B0), // Purple for fun/entertainment
      appId: 'scanmeee',
    ),
    'formatweaver': AppConfig(
      name: "FormatWeaver",
      url: "https://formatweaver.com/",
      description:
          "A universal file format converter that transforms any file format to any other format with browser-based processing",
      keyFeatures: [
        "Universal file conversion",
        "Browser-based processing",
        "No data storage",
        "Privacy-focused",
      ],
      targetAudience:
          "Professionals, students, and anyone needing file format conversion",
      storyAngle:
          "Seamless file format transformation with complete privacy protection",
      primaryColor: Color(0xFF2196F3), // Blue for professional/tech
      appId: 'formatweaver',
    ),
    'snapcompress': AppConfig(
      name: "SnapCompress",
      url: "https://snapcompress.com/",
      description:
          "Free online image compression tool that reduces file sizes while maintaining quality, supporting JPEG and PNG formats",
      keyFeatures: [
        "Image compression",
        "Adjustable compression levels",
        "No data storage",
        "JPEG and PNG support",
      ],
      targetAudience:
          "Web developers, bloggers, photographers, and content creators",
      storyAngle: "Effortless image optimization for faster web performance",
      primaryColor: Color(0xFFFF5722), // Orange for optimization/speed
      appId: 'snapcompress',
    ),
    'pixelartz': AppConfig(
      name: "PixelArtz",
      url: "https://pixelartz.com/",
      description:
          "Free online pixel art creator that allows users to draw, convert images to pixel art, and share their creations",
      keyFeatures: [
        "Pixel art creation",
        "Image to pixel art conversion",
        "Drawing tools",
        "Community sharing",
      ],
      targetAudience:
          "Game developers, digital artists, hobbyists, and retro gaming enthusiasts",
      storyAngle: "Unleashing pixel creativity for the digital art community",
      primaryColor: Color(0xFFE91E63), // Pink for creativity/art
      appId: 'pixelartz',
    ),
    'allrandomtools': AppConfig(
      name: "AllRandomTools",
      url: "https://allrandomtools.com/",
      description:
          "A collection of random selection and decision-making tools including wheels, generators, and choice makers",
      keyFeatures: [
        "Decision-making wheel",
        "Random number generator",
        "Coin flip",
        "Dice roller",
        "Yes/No decisions",
      ],
      targetAudience:
          "Anyone needing help with decisions, gamers, teachers, and event organizers",
      storyAngle: "Simplifying life's choices with fun random decision tools",
      primaryColor: Color(0xFF795548), // Brown for random/natural
      appId: 'allrandomtools',
    ),
    'casualgamezone': AppConfig(
      name: "CasualGameZone",
      url: "https://casualgamezone.com/",
      description:
          "A collection of fun, free online casual games including brain teasers, action games, and skill challenges",
      keyFeatures: [
        "Multiple game categories",
        "Browser-based games",
        "Free to play",
        "Skill and brain challenges",
      ],
      targetAudience:
          "Casual gamers, office workers on breaks, students, and entertainment seekers",
      storyAngle: "Quick entertainment hub for casual gaming enthusiasts",
      primaryColor: Color(0xFFFF9800), // Orange for gaming/fun
      appId: 'casualgamezone',
    ),
    'calculatedaily': AppConfig(
      name: "CalculateDaily",
      url: "https://calculatedaily.com/",
      description:
          "Comprehensive calculator hub offering various everyday calculators for health, finance, conversions, and more",
      keyFeatures: [
        "BMI calculator",
        "Financial calculators",
        "Unit converters",
        "Grade calculators",
        "Utility calculations",
      ],
      targetAudience:
          "Students, professionals, homeowners, and anyone needing quick calculations",
      storyAngle:
          "Your everyday mathematical companion for life's calculations",
      primaryColor: Color(0xff0b84fe), // Blue-grey for calculations/utility
      appId: 'calculatedaily',
    ),
    'picxcraft': AppConfig(
      name: "PicxCraft",
      url: "https://picxcraft.com/",
      description:
          "Free online image editing tool with photo filters, drawing capabilities, and ASCII art creation features",
      keyFeatures: [
        "Photo filters",
        "Drawing tools",
        "ASCII art creation",
        "Multiple export formats",
        "Free image editing",
      ],
      targetAudience:
          "Content creators, social media users, hobbyists, and digital artists",
      storyAngle:
          "Transforming ordinary photos into extraordinary creative expressions",
      primaryColor: Color(0xFF0A80F9), // Deep purple for creativity
      appId: 'picxcraft',
    ),
    'aimageasy': AppConfig(
      name: "AImagEasy",
      url: "https://aimageasy.com/",
      description:
          "AI-powered art generation platform that transforms ideas into stunning digital artwork using artificial intelligence",
      keyFeatures: [
        "AI art generation",
        "Text-to-image creation",
        "Stunning visual output",
        "Creative AI tools",
      ],
      targetAudience:
          "Digital artists, content creators, marketers, and AI enthusiasts",
      storyAngle: "Democratizing art creation through accessible AI technology",
      primaryColor: Color(0xFF3F51B5), // Indigo for AI/tech
      appId: 'aimageasy',
    ),
    'pichaverse': AppConfig(
      name: "PichaVerse",
      url: "https://pichaverse.com/",
      description:
          "AI-powered image transformation tool that applies creative filters and styles to pictures with various artistic themes",
      keyFeatures: [
        "AI filters",
        "Multiple artistic styles",
        "Ghibli and anime styles",
        "Cyberpunk and vintage effects",
        "Easy sharing",
      ],
      targetAudience:
          "Social media users, content creators, photographers, and digital art enthusiasts",
      storyAngle:
          "Unleashing endless creative possibilities with AI-powered image transformation",
      primaryColor: Color(0xFF009688), // Teal for transformation/magic
      appId: 'pichaverse',
    ),
    'prettyparser': AppConfig(
      name: "PrettyParser",
      url: "https://prettyparser.com/",
      description:
          "Code beautifier and minifier for JSON, HTML, and XML that formats code for better readability and optimization",
      keyFeatures: [
        "Code beautification",
        "Code minification",
        "JSON/HTML/XML support",
        "No data storage",
        "Developer-focused",
      ],
      targetAudience:
          "Web developers, programmers, API developers, and software engineers",
      storyAngle:
          "Making code beautiful and readable for the developer community",
      primaryColor: Color(0xFF37474F), // Dark blue-grey for code/development
      appId: 'prettyparser',
    ),
    'moodybuddy': AppConfig(
      name: "MoodyBuddy",
      url: "https://moodybuddy.com/",
      description:
          "AI companion chatbot named Emma that provides emotional support through voice, video, and text conversations",
      keyFeatures: [
        "AI companion",
        "Voice and video chat",
        "Multilingual support",
        "Emotional support",
        "Always available",
      ],
      targetAudience:
          "People seeking emotional support, companionship, or someone to talk to",
      storyAngle:
          "Your AI companion for every mood and moment, bringing comfort and connection",
      primaryColor: Color(0xFFF06292), // Light pink for emotional support
      appId: 'moodybuddy',
    ),
  };

  static AppConfig get current {
    // Get app ID from environment or default to scanmeee
    const String appId = String.fromEnvironment(
      'APP_ID',
      defaultValue: 'scanmeee',
    );
    return apps[appId] ?? apps['scanmeee']!;
  }
}
