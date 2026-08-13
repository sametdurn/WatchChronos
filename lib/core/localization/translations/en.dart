/// English translations.
///
/// This file must contain the same keys as `tr.dart`. Any key missing here
/// automatically falls back to the Turkish text, so the app never crashes
/// or shows a blank string for a missing translation.
final Map<String, String> enTranslations = {
  // === common ===
  'common_cancel': 'Cancel',
  'common_save': 'Save',
  'common_delete': 'Delete',
  'common_ok': 'OK',
  'common_retry': 'Retry',
  'common_close': 'Close',
  'common_continue': 'Continue',
  'common_error_generic': 'An error occurred: {error}',
  'common_loading': 'Loading...',
  'common_unknown_error': 'An unknown error occurred.',

  // === setup / connection settings ===
  'setup_app_title': 'WatchChronos Setup',
  'setup_connection_title': 'Connection Settings',
  'setup_headline': 'WatchChronos Setup',
  'setup_body':
      'Enter your TMDB and Supabase details to continue. This information '
      'is stored securely on this device only.',
  'setup_field_required': 'This field is required',
  'setup_connection_updated':
      'Connection details updated. Restart the app for the changes to '
      'take effect.',
  'setup_start': 'Get Started',
  'setup_error_invalid_tmdb_key': 'Invalid TMDB API key.',
  'setup_error_tmdb_unreachable':
      'Could not reach the TMDB server. Check your internet connection.',
  'setup_error_invalid_supabase_url':
      'Invalid Supabase URL. E.g.: https://xxxxx.supabase.co',
  'setup_error_invalid_supabase_credentials':
      'Invalid Supabase URL or Anon Key.',
  'setup_error_supabase_unreachable':
      'Could not reach the Supabase server. Check the URL.',

  // === setup / QR credential transfer ===
  'qr_scan_button': 'Scan QR Code',
  'qr_scan_title': 'Scan QR Code',
  'qr_scan_invalid': 'Invalid QR code. Please try again.',
  'qr_show_title': 'Show QR Code',
  'qr_show_warning':
      'This QR code contains your connection details (including API '
      'keys). Only share it with devices you trust.',
  'settings_qr_show_title': 'Transfer via QR',
  'settings_qr_show_subtitle':
      'Transfer connection details to another device via QR',
  'settings_reset_connection_title': 'Reset Connection Info',
  'settings_reset_connection_subtitle':
      'Deletes Supabase and TMDB details from this device and returns to setup',
  'settings_reset_connection_confirm_title': 'Delete connection info?',
  'settings_reset_connection_confirm_message':
      'The saved Supabase and TMDB connection details will be deleted from '
      'this device and you\'ll be taken back to the setup screen. Your data '
      'stays safe in Supabase — only the connection details on this device '
      'are removed.',
  'settings_reset_connection_confirm_action': 'Delete and Reset',

  // === setup / first-run mode selection ===
  'setup_mode_headline': 'How are you setting this up?',
  'setup_mode_body':
      'This determines whether the database tables get created '
      'automatically.',
  'setup_mode_first_time_title': 'This is my first setup',
  'setup_mode_first_time_subtitle':
      'I have a new Supabase project and the tables have not been '
      'created yet. Set them up automatically for me.',
  'setup_mode_existing_title': 'I already set this up on another device',
  'setup_mode_existing_subtitle':
      'The Supabase project and tables already exist, I just want to '
      'connect this device.',
  'setup_management_api_section_title': 'Database Setup',
  'setup_management_api_section_body':
      'Creating the tables automatically requires a "Personal Access '
      'Token" generated from your Supabase account settings. This is '
      'different from, and far more powerful than, the project anon '
      'key — it can access ALL projects on your account. This token is '
      'NOT stored on your device; it is only used once during setup.',
  'setup_running_migrations': 'Setting up the database...',
  'setup_error_no_migrations_found':
      'No migration files were bundled with the app.',
  'setup_error_invalid_project_ref':
      'Could not derive a project reference from the Supabase URL. If '
      'you are self-hosting, you will need to create the tables '
      'manually with the Supabase CLI.',
  'setup_error_invalid_access_token':
      'Invalid Personal Access Token. You can create one from the '
      '"Access Tokens" section of your Supabase account settings.',
  'setup_error_migration_failed':
      'Something went wrong while creating the database tables.',

  // === auth: common ===
  'common_email': 'Email',
  'common_password': 'Password',

  // === auth: login ===
  'login_subtitle': 'Welcome to your movie and show tracker',
  'login_email_invalid': 'Enter a valid email address',
  'login_password_too_short': 'Password must be at least 6 characters',
  'login_submit': 'Log In',
  'login_forgot_password': 'Forgot password?',
  'login_no_account': "Don't have an account? Sign up",

  // === auth: register ===
  'register_title': 'Sign Up',
  'register_headline': 'Create a new account',
  'register_username_label': 'Username',
  'register_username_helper':
      'Only shown on your profile; you cannot log in with this.',
  'register_username_too_short': 'Username must be at least 3 characters',
  'register_confirm_password_label': 'Confirm Password',
  'register_passwords_mismatch': 'Passwords do not match',
  'register_submit': 'Sign Up',
  'register_success':
      'Registration successful. Confirm your email to log in.',

  // === auth: forgot password ===
  'forgot_password_title': 'Forgot Password',
  'forgot_password_request_body':
      'Enter the email address on your account and we\'ll send you a '
      '6-digit verification code.',
  'forgot_password_send_code': 'Send Code',
  'forgot_password_reset_body':
      'A code was sent to {email} (if an account exists with this '
      'address). Enter the code and your new password.',
  'forgot_password_otp_label': 'Verification Code',
  'forgot_password_new_password_label': 'New Password',
  'forgot_password_confirm_password_label': 'New Password (again)',
  'forgot_password_reset_submit': 'Reset Password',
  'forgot_password_change_email': "Didn't get the code? Change email",
  'forgot_password_done_headline': 'Your password has been updated',
  'forgot_password_done_body': 'You can now log in with your new password.',
  'forgot_password_back_to_login': 'Back to Login',

  // === auth errors ===
  'auth_error_invalid_credentials': 'Incorrect email or password.',
  'auth_error_already_registered': 'This email address is already registered.',
  'auth_error_email_not_confirmed': 'You need to confirm your email address.',
  'auth_error_same_password':
      'Your new password cannot be the same as your old one.',
  'auth_error_email_in_use':
      'This email address is already in use by another account.',
  'auth_error_token_expired':
      'The code is invalid or has expired. Request a new one.',
  'auth_error_username_taken':
      'This username is already taken, try a different one.',
  'auth_error_unexpected': 'An unexpected error occurred. Please try again.',

  // === settings: change password ===
  'change_password_title': 'Change Password',
  'change_password_success': 'Your password was updated successfully.',
  'change_password_current_wrong': 'Your current password is incorrect.',
  'change_password_current_label': 'Current Password',
  'common_new_password': 'New Password',
  'change_password_same_as_current':
      'Your new password cannot be the same as your old one',
  'common_confirm_new_password': 'New Password (again)',
  'change_password_submit': 'Update Password',

  // === settings: change email ===
  'change_email_title': 'Change Email',
  'change_email_same_as_current':
      'Your new email cannot be the same as your current one.',
  'change_email_current_email': 'Current email: {email}',
  'change_email_body':
      'We\'ll send a confirmation link to your new address. For the '
      'change to take effect, you need to click the links sent to both '
      'your current and your new email address. Your account keeps '
      'using the current email until both are confirmed.',
  'change_email_new_label': 'New Email',
  'change_email_send_link': 'Send Confirmation Link',
  'change_email_sent_headline': 'Confirmation link sent',
  'change_email_sent_body':
      'We sent a confirmation link to {email}. A confirmation link was '
      'also sent to your current email; you need to click both for the '
      'change to take effect.',

  // === settings: main screen ===
  'settings_title': 'Settings',
  'settings_section_general': 'General',
  'settings_language': 'Language',
  'settings_language_dialog_title': 'Choose Language',
  'settings_section_data': 'Data',
  'settings_export_dialog_title': 'Where would you like to save your data?',
  'settings_tv_time_import_title': 'Import TV Time Data',
  'settings_tv_time_import_subtitle':
      'Import your watchlist, watched items, and watched episodes from a '
      'TV Time GDPR ZIP',
  'settings_export_title': 'Export My Data',
  'settings_export_subtitle':
      'Save your watch status, favorites, ratings, and full episode '
      'history to a single JSON file',
  'settings_export_success': 'Your data was exported successfully.',
  'settings_export_error': 'An error occurred while exporting: {error}',
  'settings_import_title': 'Import My Data',
  'settings_import_subtitle':
      'Restore a WatchChronos .json file you exported previously',
  'settings_section_connection': 'Connection',
  'settings_connection_title': 'TMDB / Supabase Details',
  'settings_connection_subtitle': 'View or update your API keys',
  'settings_section_account': 'Account',
  'settings_change_email_subtitle':
      'A confirmation link is sent to both your old and new email',
  'settings_sign_out': 'Sign Out',
  'settings_sign_out_confirm': 'Are you sure you want to sign out?',

  // === settings: watchchronos import ===
  'watchchronos_import_intro':
      'Select the WatchChronos .json file you previously created with '
      '"Export My Data"; your watch status, favorites, ratings, notes, '
      'and full episode history will be restored to this account.',
  'watchchronos_import_notes':
      'Good to know:\n'
      '• This import ONLY reads WatchChronos\' own export file (there\'s '
      'a separate option for a TV Time ZIP).\n'
      '• Since every record already carries its own TMDB id, there is no '
      'ambiguous matching or manual selection step; every record in the '
      'file is restored exactly as-is.\n'
      '• If the same content already exists in your account, it is '
      'overwritten (the existing status/rating/notes are replaced with '
      'the ones in the file); re-importing the same file is safe and '
      'won\'t create duplicates.',
  'watchchronos_import_pick_button':
      'Choose and Import WatchChronos JSON File',
  'watchchronos_import_error_file_read':
      'Could not read the file, please try again.',
  'watchchronos_import_status_reading': 'Reading file...',
  'watchchronos_import_status_starting': 'Restore starting...',
  'watchchronos_import_error_generic':
      'An error occurred while restoring: {error}',
  'watchchronos_import_total_found': 'Found {count} records in total',
  'watchchronos_import_restored_entries': 'Restored entries: {count}',
  'watchchronos_import_restored_episode_logs':
      'Restored episode watch records: {count}',
  'watchchronos_import_failed_entries': 'Could not be restored ({count}):',
  'watchchronos_import_error_unreadable':
      'Could not read the file; it may not be a WatchChronos export '
      '(.json) file.\nError: {error}',
  'watchchronos_import_error_bad_format':
      'The file is not in the expected WatchChronos export format.',
  'watchchronos_import_error_missing_entries':
      'The "entries" field was not found in the file; this is not a '
      'WatchChronos export file.',
  'watchchronos_import_error_parse_failed':
      'Could not parse the file; its content may be corrupted.\n'
      'Error: {error}',
  'watchchronos_import_progress_restoring': 'Restoring: TMDB #{tmdbId}',

  // === settings: tv time import progress ===
  'tv_time_progress_matching_show': 'Matching show: {name}',
  'tv_time_progress_matching_movie': 'Matching movie: {name}',
  'tv_time_import_intro':
      'Select the data ZIP file you downloaded from TV Time at '
      'gdpr.tvtime.com; let\'s import your watchlist, the shows/movies '
      'you\'ve watched, and the episodes you\'ve watched into WatchChronos.',
  'tv_time_import_notes':
      'Good to know:\n'
      '• TV Time didn\'t have a star/numeric rating system (only a '
      'like/reaction), so ratings are not imported.\n'
      '• Watch status, favorites, watchlist, archive status, the season/'
      'episode you left off at, and episode history are imported. Rewatch '
      'count is added as a note (WatchChronos has no separate field for '
      'it).\n'
      '• The TV Time export doesn\'t include an episode-by-episode history '
      'for every show; some shows only have a total watched-episode '
      'count. For these shows, the first N episodes (in TMDB order) are '
      'marked as watched (an approximate import).\n'
      '• Shows/movies are matched on TMDB using their title, original '
      'title, release year, and (if needed) season/episode count '
      'together. If several strong candidates come up, no automatic pick '
      'is made; you\'ll be asked to choose at the end of the import.',
  'tv_time_import_pick_button': 'Choose and Import TV Time ZIP File',
  'tv_time_import_error_file_read':
      'Could not read the file, please try again.',
  'tv_time_import_status_parsing': 'Reading ZIP file...',
  'tv_time_import_status_starting': 'Import starting...',
  'tv_time_import_error_generic':
      'An error occurred during import: {error}',
  'tv_time_import_done_with_pending':
      'Import complete, a few records need your input',
  'tv_time_import_done': 'Import complete',
  'tv_time_import_found_stats':
      'Found on TV Time: {shows} shows ({followed} candidates for '
      'processing), {movies} movies',
  'tv_time_import_matched_shows': 'Matched shows: {count}',
  'tv_time_import_matched_movies': 'Matched movies: {count}',
  'tv_time_import_exact_shows':
      'Shows imported with full episode history: {count}',
  'tv_time_import_approx_shows':
      'Shows imported approximately by total count: {count}',
  'tv_time_import_choose_candidate':
      'Multiple strong candidates were found, pick the right one:',
  'tv_time_import_type_show': 'show',
  'tv_time_import_type_movie': 'movie',
  'tv_time_import_subtitle_with_year': '({year}) • {type}',
  'tv_time_import_unmatched_shows': 'Unmatched shows ({count}):',
  'tv_time_import_unmatched_movies': 'Unmatched movies ({count}):',
  'tv_time_import_resolve_first': 'Resolve the items above first',
  'tv_time_import_auto_pick': 'Auto-pick (most likely)',
  'tv_time_import_skip': 'None / skip',
  'tv_time_import_release_date_unknown': 'Release date unknown',
  'month_1': 'January',
  'month_2': 'February',
  'month_3': 'March',
  'month_4': 'April',
  'month_5': 'May',
  'month_6': 'June',
  'month_7': 'July',
  'month_8': 'August',
  'month_9': 'September',
  'month_10': 'October',
  'month_11': 'November',
  'month_12': 'December',

  // === navigation ===
  'nav_library': 'Library',
  'nav_discover': 'Discover',
  'nav_profile': 'Profile',

  // === library ===
  'library_tab_shows': 'Shows',
  'library_tab_movies': 'Movies',
  'library_tab_completed': 'Completed',
  'library_tab_favorites': 'Favorites',
  'library_no_shows': "You haven't added any shows yet. Search from Discover.",
  'library_no_ongoing_shows':
      'You have no ongoing shows. Completed shows are in the Completed tab.',
  'library_section_watching': 'Watching',
  'library_section_upcoming': 'Coming Up',
  'library_section_not_started': 'Not Started Yet',
  'library_no_movies': "You haven't added any movies yet. Search from Discover.",
  'library_no_completed': "You haven't completed anything yet.",
  'library_completed_shows_title': 'Completed Shows',
  'library_completed_movies_title': 'Completed Movies',
  'library_no_favorites': "You haven't added any favorites yet.",
  'library_favorite_shows_title': 'Favorite Shows',
  'library_favorite_movies_title': 'Favorite Movies',
  'common_something_went_wrong': 'Something went wrong.',
  'common_load_failed_retry': 'Failed to load. Try again.',

  // === tv show lifecycle badges ===
  'tv_lifecycle_returning_series': 'Ongoing',
  'tv_lifecycle_in_production': 'In Production',
  'tv_lifecycle_planned': 'Planned',
  'tv_lifecycle_pilot': 'In Pilot',
  'tv_lifecycle_ended': 'Ended',
  'tv_lifecycle_canceled': 'Canceled',

  // === watch entry card ===
  'watch_entry_card_upcoming_badge': 'Coming Up',
  'watch_entry_card_all_episodes_watched': 'All episodes watched',
  'watch_entry_card_mark_watched_tooltip': 'Mark episode as watched',
  'watch_entry_card_mark_watched_failed':
      'Could not mark the episode as watched.',

  // === discover ===
  'discover_search_hint': 'Search for a movie or show...',
  'discover_trending_shows': 'Trending Shows',
  'discover_trending_movies': 'Trending Movies',
  'discover_search_failed': 'Search failed.',
  'discover_no_results': 'No results found',

  // === api errors ===
  'api_error_network': 'Check your internet connection.',
  'api_error_timeout': 'No response from the server, please try again.',
  'api_error_not_found': 'Content not found.',
  'api_error_server': 'A server error occurred.',
  'api_error_unknown': 'An unexpected error occurred.',
  'api_error_cancelled': 'Request cancelled.',

  // === discover: trending grid ===
  'discover_no_content': 'No content to display.',
  'common_loading_ellipsis': 'Loading…',
  'common_minutes_short': '{count} min',
  'common_one_season': '1 season',
  'common_n_seasons': '{count} seasons',

  // === common media type labels ===
  'common_media_type_movie': 'Movie',
  'common_media_type_show': 'Show',

  // === episode tracking ===
  'episode_tracking_title': 'Episode Tracking',
  'episode_tracking_init_error': 'Could not load episode information.',
  'episode_tracking_season_load_error': 'Could not load the season.',
  'episode_tracking_action_failed': 'The action failed.',
  'episode_tracking_season_complete_error': 'Could not complete the season.',
  'episode_tracking_season_reset_error': 'Could not reset the season.',
  'episode_tracking_season_switched': 'Switched to season {season}.',
  'episode_tracking_tv_only':
      'Episode tracking is only available for shows.',
  'common_go_back': 'Go Back',
  'episode_tracking_complete_season': 'Complete season',
  'episode_tracking_reset_season': 'Mark season as unwatched',
  'episode_tile_default_title': 'Episode {number}',
  'season_selector_label': 'Season {number}',

  // === watch entry errors ===
  'watch_entry_error_episode_logs_tv_only':
      'Episode tracking is only available for shows.',
  'watch_entry_error_already_exists': 'This record already exists.',
  'watch_entry_error_value_out_of_range':
      'The entered value is outside the allowed range.',

  // === media detail screen ===
  'media_detail_rating_warning_movie':
      'You need to mark the movie as watched before you can rate it.',
  'media_detail_rating_warning_tv':
      'You need to mark at least 1 episode as watched before you can rate it.',
  'media_detail_error_add_failed': 'Could not add to library.',
  'media_detail_error_status_update_failed': 'Could not update the status.',
  'media_detail_error_remove_failed': 'Could not remove from library.',
  'media_detail_error_favorite_failed': 'Could not update favorite status.',
  'media_detail_error_rating_failed': 'Could not save the rating.',
  'media_detail_error_no_session': 'No session found. Please log in again.',
  'media_detail_load_failed': 'Could not load the content.',
  'media_detail_favorite': 'Favorite',
  'media_detail_your_rating': 'Your Rating',
  'media_detail_disabled_hint_movie':
      'Mark as watched first to be able to rate it.',
  'media_detail_disabled_hint_tv':
      'Mark at least 1 episode as watched to be able to rate it.',
  'media_detail_add_to_library': 'Add to Library',
  'media_detail_re_add_to_library': 'Add Back to Library',
  'media_detail_view_watched_episodes': 'View Watched Episodes',
  'media_detail_watched': 'Watched',
  'media_detail_mark_watched': 'Mark as watched',
  'media_detail_remove_from_library': 'Remove from Library',
  'media_detail_manage_episodes': 'Manage Episodes',
  'media_detail_mark_completed': 'Mark as completed',
  'media_detail_watch_trailer': 'Watch Trailer',
  'media_detail_more_info': 'More Info',
  'media_detail_cast': 'Cast',
  'media_detail_error_trailer_open_failed': 'Could not open the trailer.',
  'media_detail_error_tmdb_open_failed': 'Could not open the TMDB page.',

  // === rating input ===
  'rating_input_remove_rating': 'Remove Rating',
  'rating_input_not_rated_yet': "You haven't rated this yet",
  'rating_input_stars_out_of_5': '{count} / 5',

  // === profile screen ===
  'profile_error_photo_read_failed': 'Could not read the photo.',
  'profile_error_photo_upload_failed': 'Could not upload the photo.',
  'profile_edit_username_title': 'Change Username',
  'profile_error_username_update_failed': 'Could not update the username.',
  'profile_load_failed': 'Could not load the profile.',
  'profile_unnamed_user': 'Unnamed User',
  'profile_your_stats': 'Your Stats',
  'profile_stats_load_failed': 'Could not load the stats.',
  'profile_stat_completed_shows': 'Completed Shows',
  'profile_stat_completed_movies': 'Completed Movies',
  'profile_stat_planned': 'Planned',
  'profile_stat_episodes_watched': 'Episodes Watched',
  'profile_stat_average_rating': 'Average Rating',

  // === tv time zip parse errors ===
  'tv_time_parse_error_empty_file':
      'The selected file appears to be empty (0 bytes). No ZIP data could '
      'be read from the file picker; please try selecting the file '
      'again.',
  'tv_time_parse_error_empty_zip':
      'The ZIP was opened but no files were found inside it (the selected '
      'file was {bytes} bytes). This usually means the file got corrupted '
      'during download, or the selected file isn\'t a real TV Time ZIP.',
  'tv_time_parse_error_missing_files':
      'The expected file(s) were not found in the ZIP: {missing}.\n'
      'Some of the {count} files found in the ZIP: {sample}',
  'tv_time_parse_error_no_records':
      'The required CSV files were found in the ZIP, but no records could '
      'be read from them. The file format may be different than expected '
      '(e.g. the column headers may have changed).',
};
