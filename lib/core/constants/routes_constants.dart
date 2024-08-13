class _NestedRoute {
  const _NestedRoute({
    required this.fullPath,
    required this.relativePath,
  });
  final String fullPath;
  final String relativePath;
}

final class PlotweaverRoutes {
  static const welcome = '/';
  static const editor = '/editor';
  static const projectEditor = _NestedRoute(
    fullPath: '/editor/project',
    relativePath: 'project',
  );
}
