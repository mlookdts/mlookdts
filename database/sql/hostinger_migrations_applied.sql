SET NAMES utf8mb4;

-- Mark all Laravel migrations as already applied (so artisan migrate won't try to recreate tables)
INSERT INTO `migrations` (`migration`, `batch`) VALUES
  ('0001_01_01_000000_create_departments_table', 1),
  ('0001_01_01_000001_create_programs_table', 1),
  ('0001_01_01_000002_create_users_table', 1),
  ('0001_01_01_000003_create_cache_table', 1),
  ('0001_01_01_000004_create_jobs_table', 1),
  ('2025_10_31_132245_create_password_resets_table', 1),
  ('2025_10_31_211453_create_notifications_table', 1),
  ('2025_11_01_033854_create_document_types_table', 1),
  ('2025_11_01_033856_create_documents_table', 1),
  ('2025_11_01_033858_create_document_tracking_table', 1),
  ('2025_11_01_033859_create_document_actions_table', 1),
  ('2025_11_01_074114_create_document_comments_table', 1),
  ('2025_11_01_074750_create_document_attachments_table', 1),
  ('2025_11_05_124900_create_personal_access_tokens_table', 1),
  ('2025_11_05_154400_create_audit_logs_table', 1),
  ('2025_11_05_154500_add_database_indexes_for_optimization', 1),
  ('2025_11_05_create_document_receivers_table', 1),
  ('2025_11_05_create_routing_rules_table', 1),
  ('2025_11_06_132550_create_performance_metrics_table', 1),
  ('2025_11_08_032511_create_tags_table', 1),
  ('2025_11_08_043849_create_permissions_table', 1),
  ('2025_11_08_044305_create_data_retention_policies_table', 1),
  ('2025_11_08_075217_create_document_signatures_table', 1),
  ('2025_11_08_142025_create_document_tag_table', 1),
  ('2025_11_09_000000_create_email_verifications_table', 1),
  ('2025_11_10_create_document_views_table', 1)
ON DUPLICATE KEY UPDATE `batch` = VALUES(`batch`);
