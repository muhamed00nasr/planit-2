import '../models/post.dart';

final List<Post> mockPosts = [
  Post(
    id: '1',
    author: Author(name: 'Cairo Gourmet Catering', avatar: '', type: 'vendor'),
    content:
        'Just wrapped up an amazing wedding in New Cairo! Check out our latest menu creations. Perfect for your special day 🍽️✨',
    image:
        'https://images.unsplash.com/photo-1668097519018-f7d13a079c0a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYXRlcmluZyUyMGZvb2QlMjBidWZmZXR8ZW58MXx8fHwxNzYwNzIwODgxfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    location: 'New Cairo',
    eventType: 'Wedding',
    timestamp: '2h ago',
    likes: 124,
    comments: 18,
    vendorId: '1',
  ),
  Post(
    id: '2',
    author: Author(name: 'Layla Ahmed', avatar: '', type: 'user'),
    content:
        'Looking for a makeup artist for my engagement party next month in Maadi! Any recommendations? 💄',
    location: 'Maadi',
    eventType: 'Engagement',
    timestamp: '4h ago',
    likes: 45,
    comments: 32,
  ),
  Post(
    id: '3',
    author: Author(
      name: 'Moments Photography Studio',
      avatar: '',
      type: 'vendor',
    ),
    content:
        'Capturing love stories one frame at a time. Now booking for 2025 weddings! Limited spots available 📸',
    image:
        'https://images.unsplash.com/photo-1661668724998-fd8c24e1cd1a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3ZWRkaW5nJTIwcGhvdG9ncmFwaGVyJTIwY2FtZXJhfGVufDF8fHx8MTc2MDc4NDMzN3ww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    location: 'Sheikh Zayed',
    eventType: 'Wedding',
    timestamp: '6h ago',
    likes: 89,
    comments: 12,
    vendorId: '7',
  ),
  Post(
    id: '4',
    author: Author(name: 'Bridal Dreams Boutique', avatar: '', type: 'vendor'),
    content:
        'New collection just arrived! Visit our boutique in Nasr City to find your dream dress 👗✨',
    image:
        'https://images.unsplash.com/photo-1759893362613-8bb8bb057af1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3ZWRkaW5nJTIwZHJlc3MlMjBib3V0aXF1ZXxlbnwxfHx8fDE3NjA3MDY3MTJ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    location: 'Nasr City',
    eventType: 'Wedding',
    timestamp: '1d ago',
    likes: 203,
    comments: 27,
    vendorId: '13',
  ),
  Post(
    id: '5',
    author: Author(name: 'Sara Mohamed', avatar: '', type: 'user'),
    content:
        'Planning my daughter\'s birthday party and need a great decorator! Sheikh Zayed area preferred 🎈🎉',
    location: 'Sheikh Zayed',
    eventType: 'Birthday',
    timestamp: '8h ago',
    likes: 62,
    comments: 24,
  ),
  Post(
    id: '6',
    author: Author(
      name: 'Blooming Affairs Florist',
      avatar: '',
      type: 'vendor',
    ),
    content:
        'Fresh flower arrangements for your special day! Custom bouquets and centerpieces 🌸💐',
    image:
        'https://images.unsplash.com/photo-1719499809556-070ec0dfda8b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmbG9yYWwlMjBhcnJhbmdlbWVudCUyMHdlZGRpbmd8ZW58MXx8fHwxNzYwNzExOTgwfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    location: 'Maadi',
    eventType: 'Wedding',
    timestamp: '12h ago',
    likes: 156,
    comments: 19,
    vendorId: '15',
  ),
  Post(
    id: '7',
    author: Author(name: 'Grand Palace Hall', avatar: '', type: 'vendor'),
    content:
        'Book now for 2025! Our luxurious venue can accommodate up to 500 guests. Limited dates available! ✨🏛️',
    image:
        'https://images.unsplash.com/photo-1674924258890-f4a5d99bb28c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3ZWRkaW5nJTIwdmVudWUlMjBlbGVnYW50fGVufDF8fHx8MTc2MDczOTE1Mnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    location: 'New Cairo',
    eventType: 'Wedding',
    timestamp: '1d ago',
    likes: 234,
    comments: 43,
    vendorId: '10',
  ),
  Post(
    id: '8',
    author: Author(
      name: 'Sweet Celebrations Cakes',
      avatar: '',
      type: 'vendor',
    ),
    content:
        'Custom wedding cakes designed just for you! Schedule a tasting session today 🎂💕',
    image:
        'https://images.unsplash.com/photo-1629687465907-604f9f95e038?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3ZWRkaW5nJTIwY2FrZSUyMGRlY29yYXRpb258ZW58MXx8fHwxNzYwNzE0MDczfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    location: 'Maadi',
    eventType: 'Wedding',
    timestamp: '2d ago',
    likes: 198,
    comments: 31,
    vendorId: '19',
  ),
];
