<?php

/**
 * @file
 * This is a Drupal settings.local.php file automatically generated by DDEV provided by the annertech-ddev addon.
 *
 * DDEV manages this file and may delete or overwrite it unless this
 * comment, marked with #ddev-generated, is removed. It is recommended
 * that you leave this file alone.
 */

// Simplei settings for local environments. Needs to be overwritten on PSH/Acquia config.
$settings['simple_environment_indicator'] = 'darkgreen LOCAL';

// Stage File Proxy settings.
$config['stage_file_proxy.settings']['origin'] = getenv('STAGE_FILE_PROXY_URL');

// Override SOLR configuration for DDEV.
$config['search_api.server.solr']['backend_config']['connector_config']['scheme'] = 'http';
$config['search_api.server.solr']['backend_config']['connector_config']['host'] = 'solr';
$config['search_api.server.solr']['backend_config']['connector_config']['port'] = '8983';
$config['search_api.server.solr']['backend_config']['connector_config']['path'] = '/';
$config['search_api.server.solr']['backend_config']['connector_config']['core'] = 'dev';

// Set $settings['file_private_path'] if not set in settings.php.
if (empty($settings['file_private_path'])) {
  $settings['file_private_path'] = '../private';
}

/**
 * Developer settings, adapt to will.
 * @see ../example.settings.local.php for more
 */

/**
 * Enable CSS and JS aggregation.
 */
$config['system.performance']['css']['preprocess'] = TRUE;
$config['system.performance']['js']['preprocess'] = TRUE;

/**
 * Enable access to rebuild.php.
 *
 * This setting can be enabled to allow Drupal's php and database cached
 * storage to be cleared via the rebuild.php page. Access to this page can also
 * be gained by generating a query string from rebuild_token_calculator.sh and
 * using these parameters in a request to rebuild.php.
 */
$settings['rebuild_access'] = TRUE;

/**
 * Skip file system permissions hardening.
 *
 * The system module will periodically check the permissions of your site's
 * site directory to ensure that it is not writable by the website user. For
 * sites that are managed with a version control system, this can cause problems
 * when files in that directory such as settings.php are updated, because the
 * user pulling in the changes won't have permissions to modify files in the
 * directory.
 */
$settings['skip_permissions_hardening'] = TRUE;

/**
 * Exclude modules from configuration synchronization.
 *
 * On config export sync, no config or dependent config of any excluded module
 * is exported. On config import sync, any config of any installed excluded
 * module is ignored. In the exported configuration, it will be as if the
 * excluded module had never been installed. When syncing configuration, if an
 * excluded module is already installed, it will not be uninstalled by the
 * configuration synchronization, and dependent configuration will remain
 * intact. This affects only configuration synchronization; single import and
 * export of configuration are not affected.
 *
 * Drupal does not validate or sanity check the list of excluded modules. For
 * instance, it is your own responsibility to never exclude required modules,
 * because it would mean that the exported configuration can not be imported
 * anymore.
 *
 * This is an advanced feature and using it means opting out of some of the
 * guarantees the configuration synchronization provides. It is not recommended
 * to use this feature with modules that affect Drupal in a major way such as
 * the language or field module.
 */
$settings['config_exclude_modules'] = [
  'devel',
  'devel_a11y',
  'stage_file_proxy',
  'twig_vardumper',
  'upgrade_status',
];

/**
 * If there is a projects settings file, then include it.
 */
$project_settings = __DIR__ . "/settings.project.php";
if (file_exists($project_settings)) {
    include $project_settings;
}