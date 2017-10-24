<?php

$databases = array(
  'default' => array(
    'default' => array(
      'driver' => 'mysql',
      'database' => getenv('DB_ENV_MYSQL_DATABASE'),
      'username' => getenv('DB_ENV_MYSQL_USER'),
      'password' => getenv('DB_ENV_MYSQL_PASSWORD'),
      'host' => 'db',
      'prefix' => '',
    ),
  ),
);

$conf['cache'] = 1;
$conf['block_cache'] = 1;
$conf['preprocess_css'] = 1;
$conf['preprocess_js'] = 1;


if (file_exists(__DIR__ . '/settings.local.php')) {
  include __DIR__ . '/settings.local.php';
}

// // Ensures that form data is not moved out of the database. It's important to
// // keep this in non-volatile memory (e.g. the database).
// $conf['cache_class_cache_form'] = 'DrupalDatabaseCache';

// // Ensure fast tracks for files not found.
// drupal_fast_404();

// // Tell Drupal it's behind a proxy.
// $conf['reverse_proxy'] = TRUE;

// // Tell Drupal what addresses the proxy server(s) use.
// $conf['reverse_proxy_addresses'] = array('127.0.0.1');

// // Bypass Drupal bootstrap for anonymous users so that Drupal sets max-age < 0.
// $conf['page_cache_invoke_hooks'] = FALSE;

// // Set varnish configuration.
// $conf['varnish_control_key'] = 'THE KEY';
// $conf['varnish_socket_timeout'] = 500;

// // Set varnish server IP's sperated by spaces
// $conf['varnish-control-terminal'] = 'IP:6082 IP:6082';

// $conf['profile'] = 'ding2';

/**
 * Memcached.
 */
// $conf += array(
//     'memcache_extension' => 'Memcache',
//     'show_memcache_statistics' => 0,
//     'memcache_persistent' => TRUE,
//     'memcache_stampede_protection' => TRUE,
//     'memcache_stampede_semaphore' => 15,
//     'memcache_stampede_wait_time' => 5,
//     'memcache_stampede_wait_limit' => 3,
//     'memcache_key_prefix' => YOUR_SITE_NAME,
//   );

//   $conf['cache_backends'][] = 'profiles/ding2/modules/contrib/memcache/memcache.inc';
//   $conf['cache_default_class'] = 'MemCacheDrupal';

//   // Configure cache servers.
//   $conf['memcache_servers'] = array(
//     'memcached:11211' => 'default',
//   );
//   $conf['memcache_bins'] = array(
//     'cache' => 'default',
//   );
