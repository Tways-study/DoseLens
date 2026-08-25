import 'dart:async';

/// Thrown when a rate-limit bucket has no tokens available.
class RateLimitException implements Exception {
  final String bucket;
  final int secondsUntilRefill;

  const RateLimitException({
    required this.bucket,
    required this.secondsUntilRefill,
  });

  @override
  String toString() =>
      'RateLimitException: bucket "$bucket" exhausted — '
      'try again in $secondsUntilRefill second(s).';
}

class _BucketConfig {
  final int maxTokens;
  final Duration windowDuration;
  const _BucketConfig({required this.maxTokens, required this.windowDuration});
}

class _Bucket {
  final _BucketConfig config;
  int _tokens;
  DateTime _windowStart;
  Timer? _refillTimer;

  _Bucket(this.config)
      : _tokens = config.maxTokens,
        _windowStart = DateTime.now();

  void consume() {
    _ensureRefillScheduled();
    if (_tokens <= 0) {
      final elapsed = DateTime.now().difference(_windowStart);
      final remaining = config.windowDuration - elapsed;
      final secs = remaining.inSeconds.clamp(1, config.windowDuration.inSeconds);
      throw RateLimitException(bucket: '', secondsUntilRefill: secs);
    }
    _tokens--;
  }

  int get secondsUntilRefill {
    final elapsed = DateTime.now().difference(_windowStart);
    final remaining = config.windowDuration - elapsed;
    return remaining.inSeconds.clamp(0, config.windowDuration.inSeconds);
  }

  int get tokensRemaining => _tokens;

  void _ensureRefillScheduled() {
    _refillTimer ??= Timer(config.windowDuration, _refill);
  }

  void _refill() {
    _tokens = config.maxTokens;
    _windowStart = DateTime.now();
    _refillTimer = null;
  }
}

/// Singleton token-bucket rate limiter for external API calls.
///
/// Buckets:
/// - `gemini`   — 5 requests / 60 seconds  (Gemini 2.0 Flash free-tier)
/// - `openFda`  — 10 requests / 60 seconds (conservative for keyless endpoint)
///
/// Usage:
/// ```dart
/// RateLimiter.instance.consume('gemini'); // throws RateLimitException if exhausted
/// ```
class RateLimiter {
  RateLimiter._();
  static final RateLimiter instance = RateLimiter._();

  static const _configs = <String, _BucketConfig>{
    'gemini': _BucketConfig(maxTokens: 5, windowDuration: Duration(seconds: 60)),
    'openFda': _BucketConfig(maxTokens: 10, windowDuration: Duration(seconds: 60)),
  };

  final Map<String, _Bucket> _buckets = {};

  _Bucket _bucket(String name) {
    assert(_configs.containsKey(name), 'Unknown rate-limit bucket: "$name"');
    return _buckets.putIfAbsent(name, () => _Bucket(_configs[name]!));
  }

  /// Consumes one token from [bucket].
  /// Throws [RateLimitException] with seconds-until-refill if the bucket is empty.
  void consume(String bucket) => _bucket(bucket).consume();

  /// Returns how many seconds remain until [bucket] refills.
  int secondsUntilRefill(String bucket) => _bucket(bucket).secondsUntilRefill;

  /// Returns remaining token count for [bucket] without consuming.
  int remaining(String bucket) => _bucket(bucket).tokensRemaining;
}
