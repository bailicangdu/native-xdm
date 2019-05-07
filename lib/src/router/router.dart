import '../utils/router/router.dart';
import '../pages/home/home.dart';
import '../pages//gallery/gallery.dart';

Router router = Router(
  routes: [
    {
      'path': '/home',
      'name': 'home',
      'widget': Home,
      'transition': 'xxx',
    },
    {
      'path': '/gallery',
      'name': 'gallery',
      'widget': Gallery,
    }
  ],
);
