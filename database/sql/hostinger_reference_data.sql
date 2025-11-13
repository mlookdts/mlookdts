SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

-- Permissions
INSERT INTO `permissions` (`name`, `slug`, `category`, `description`, `created_at`, `updated_at`) VALUES
  ('Create Documents', 'document.create', 'document', NULL, NOW(), NOW()),
  ('View All Documents', 'document.view.all', 'document', NULL, NOW(), NOW()),
  ('Edit Any Document', 'document.edit.any', 'document', NULL, NOW(), NOW()),
  ('Delete Any Document', 'document.delete.any', 'document', NULL, NOW(), NOW()),
  ('Archive Documents', 'document.archive', 'document', NULL, NOW(), NOW()),
  ('Approve Documents', 'document.approve', 'document', NULL, NOW(), NOW()),
  ('Manage Tags', 'tag.manage', 'admin', NULL, NOW(), NOW()),
  ('Create Templates', 'template.create', 'admin', NULL, NOW(), NOW()),
  ('Edit Any Template', 'template.edit.any', 'admin', NULL, NOW(), NOW()),
  ('Delete Any Template', 'template.delete.any', 'admin', NULL, NOW(), NOW()),
  ('Manage Users', 'user.manage', 'admin', NULL, NOW(), NOW()),
  ('View Audit Logs', 'audit.view', 'admin', NULL, NOW(), NOW()),
  ('Manage Settings', 'settings.manage', 'admin', NULL, NOW(), NOW()),
  ('Manage Permissions', 'permission.manage', 'system', NULL, NOW(), NOW())
ON DUPLICATE KEY UPDATE `updated_at` = VALUES(`updated_at`);

-- Departments (Colleges)
INSERT INTO `departments` (`name`, `code`, `type`, `description`, `head_user_id`, `created_at`, `updated_at`) VALUES
  ('College of Graduate Studies', 'CGS', 'college', 'College of Graduate Studies - Led by Dean', NULL, NOW(), NOW()),
  ('College of Law', 'CLAW', 'college', 'College of Law - Led by Dean', NULL, NOW(), NOW()),
  ('College of Engineering', 'COE', 'college', 'College of Engineering - Led by Dean', NULL, NOW(), NOW()),
  ('College of Information Technology', 'CIT', 'college', 'College of Information Technology - Led by Dean', NULL, NOW(), NOW()),
  ('College of Arts and Sciences', 'CAS', 'college', 'College of Arts and Sciences - Led by Dean', NULL, NOW(), NOW()),
  ('College of Management', 'COM', 'college', 'College of Management - Led by Dean', NULL, NOW(), NOW()),
  ('Institute of Criminal Justice Education', 'ICJE', 'college', 'Institute of Criminal Justice Education - Led by Dean', NULL, NOW(), NOW()),
  ('College of Technology', 'COT', 'college', 'College of Technology - Led by Dean', NULL, NOW(), NOW()),
  ('College of Education', 'CE', 'college', 'College of Education - Led by Dean', NULL, NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `type` = VALUES(`type`), `updated_at` = VALUES(`updated_at`);

-- Departments (Administrative)
INSERT INTO `departments` (`name`, `code`, `type`, `description`, `head_user_id`, `created_at`, `updated_at`) VALUES
  ('Registrar Office', 'REG', 'department', 'Handles student records, enrollment, and academic documents - Led by Registrar', NULL, NOW(), NOW()),
  ('Office of the Campus Director', 'OCD', 'department', 'Campus Director''s Office - Led by Campus Director', NULL, NOW(), NOW()),
  ('Human Resource Office', 'HRO', 'department', 'Human Resource Management Office - Led by Department Head', NULL, NOW(), NOW()),
  ('Accounting Office', 'ACCT', 'department', 'Accounting and Finance Office - Led by Department Head', NULL, NOW(), NOW()),
  ('Student Affairs Office', 'SAO', 'department', 'Student Affairs and Services - Led by Department Head', NULL, NOW(), NOW()),
  ('Library', 'LIB', 'department', 'University Library - Led by Department Head', NULL, NOW(), NOW()),
  ('Information Technology Services', 'ITS', 'department', 'IT Support and Services Office - Led by Department Head', NULL, NOW(), NOW()),
  ('Physical Plant and Facilities', 'PPF', 'department', 'Facilities and Maintenance Office - Led by Department Head', NULL, NOW(), NOW()),
  ('Security Office', 'SEC', 'department', 'Campus Security Office - Led by Department Head', NULL, NOW(), NOW()),
  ('Guidance and Counseling', 'GC', 'department', 'Guidance and Counseling Services - Led by Department Head', NULL, NOW(), NOW()),
  ('Supply and Property Office', 'SPO', 'department', 'Supply and Property Management - Led by Department Head', NULL, NOW(), NOW()),
  ('Research and Development Office', 'RDO', 'department', 'Research and Development Office - Led by Department Head', NULL, NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `type` = VALUES(`type`), `updated_at` = VALUES(`updated_at`);

-- Programs (link to colleges by code)
INSERT INTO `programs` (`name`, `code`, `description`, `college_id`, `head_user_id`, `created_at`, `updated_at`) VALUES
  ('Doctor of Philosophy in Technology Education Management', 'CGS-PHD-TEM', 'PhD in Technology Education Management', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Doctor of Philosophy in Development Administration', 'CGS-PHD-DA', 'PhD in Development Administration', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Doctor of Philosophy in Science Education', 'CGS-PHD-SE', 'PhD in Science Education', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Doctor of Philosophy in Mathematics Education', 'CGS-PHD-ME', 'PhD in Mathematics Education', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Master of Arts in Technology Education', 'CGS-MA-TE', 'MA in Technology Education', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Master of Arts in Development Administration', 'CGS-MA-DA', 'MA in Development Administration', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Master of Arts in Science Education', 'CGS-MA-SE', 'MA in Science Education', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Master of Arts in Mathematics Education', 'CGS-MA-ME', 'MA in Mathematics Education', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Master in Management Engineering', 'CGS-ME', 'Master in Management Engineering', (SELECT id FROM departments WHERE code='CGS'), NULL, NOW(), NOW()),
  ('Juris Doctor (JD)', 'CLAW-JD', 'Juris Doctor Program', (SELECT id FROM departments WHERE code='CLAW'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Electrical Engineering (BSEE)', 'COE-BSEE', 'Electrical Engineering Program', (SELECT id FROM departments WHERE code='COE'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Mechanical Engineering (BSME)', 'COE-BSME', 'Mechanical Engineering Program', (SELECT id FROM departments WHERE code='COE'), NULL, NOW(), NOW()),
  ('Master in Information Technology (MIT)', 'CIT-MIT', 'Master in Information Technology', (SELECT id FROM departments WHERE code='CIT'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Information Technology (BSInfo-Tech)', 'CIT-BSInfoTech', 'Bachelor of Science in Information Technology', (SELECT id FROM departments WHERE code='CIT'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Psychology (BSP)', 'CAS-BSP', 'Psychology Program', (SELECT id FROM departments WHERE code='CAS'), NULL, NOW(), NOW()),
  ('Bachelor of Arts in Political Science (BAPoS)', 'CAS-BAPoS', 'Political Science Program', (SELECT id FROM departments WHERE code='CAS'), NULL, NOW(), NOW()),
  ('Bachelor of Arts in English Language (BAEL)', 'CAS-BAEL', 'English Language Program', (SELECT id FROM departments WHERE code='CAS'), NULL, NOW(), NOW()),
  ('Batsilyer ng Sining sa Filipino (BSF)', 'CAS-BSF', 'Filipino Program', (SELECT id FROM departments WHERE code='CAS'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Hospitality Management (BSHM)', 'COM-BSHM', 'Hospitality Management Program', (SELECT id FROM departments WHERE code='COM'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Business Administration (BSBA)', 'COM-BSBA', 'Business Administration Program', (SELECT id FROM departments WHERE code='COM'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Office Administration (BSOA)', 'COM-BSOA', 'Office Administration Program', (SELECT id FROM departments WHERE code='COM'), NULL, NOW(), NOW()),
  ('Bachelor of Public Administration (BPA)', 'COM-BPA', 'Public Administration Program', (SELECT id FROM departments WHERE code='COM'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Criminology (BSCrim)', 'ICJE-BSCrim', 'Criminology Program', (SELECT id FROM departments WHERE code='ICJE'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Industrial Technology (BSIT)', 'COT-BSIT', 'Industrial Technology Program', (SELECT id FROM departments WHERE code='COT'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Electro-mechanical Technology (BSEMT)', 'COT-BSEMT', 'Electro-mechanical Technology Program', (SELECT id FROM departments WHERE code='COT'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Food Technology (BSFT)', 'COT-BSFT', 'Food Technology Program', (SELECT id FROM departments WHERE code='COT'), NULL, NOW(), NOW()),
  ('Bachelor of Science in Textile and Fashion Technology (BSTFT)', 'COT-BSTFT', 'Textile and Fashion Technology Program', (SELECT id FROM departments WHERE code='COT'), NULL, NOW(), NOW()),
  ('Bachelor of Technical-Vocational Teacher Education (BTVTEd)', 'CE-BTVTEd', 'Technical-Vocational Teacher Education Program', (SELECT id FROM departments WHERE code='CE'), NULL, NOW(), NOW()),
  ('Bachelor of Technology and Livelihood Education (BTLEd)', 'CE-BTLEd', 'Technology and Livelihood Education Program', (SELECT id FROM departments WHERE code='CE'), NULL, NOW(), NOW()),
  ('Bachelor of Secondary Education (BSEd)', 'CE-BSEd', 'Secondary Education Program', (SELECT id FROM departments WHERE code='CE'), NULL, NOW(), NOW()),
  ('Bachelor of Elementary Education (BEEd)', 'CE-BEEd', 'Elementary Education Program', (SELECT id FROM departments WHERE code='CE'), NULL, NOW(), NOW()),
  ('Bachelor of Early Childhood Education (BECEd)', 'CE-BECEd', 'Early Childhood Education Program', (SELECT id FROM departments WHERE code='CE'), NULL, NOW(), NOW()),
  ('Bachelor of Physical Education (BPEd)', 'CE-BPEd', 'Physical Education Program', (SELECT id FROM departments WHERE code='CE'), NULL, NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `college_id` = VALUES(`college_id`), `updated_at` = VALUES(`updated_at`);

-- Document Types
INSERT INTO `document_types` (
  `name`, `code`, `description`, `allowed_roles`, `allowed_receive`, `is_active`, `auto_assign_enabled`, `routing_logic`, `default_receiver_role`, `default_receiver_department_id`, `default_receiver_user_id`, `created_at`, `updated_at`
) VALUES
  ('Memorandum', 'MEMO', 'Internal communication and announcements',
    '["admin","registrar","dean","department_head","faculty","staff"]',
    '["admin","registrar","dean","department_head","faculty","staff"]',
    1, 1, 'role', 'registrar', NULL, NULL, NOW(), NOW()),
  ('Letter', 'LTR', 'Official correspondence',
    '["admin","registrar","dean","department_head","faculty","staff"]',
    '["admin","registrar","dean","department_head"]',
    1, 1, 'role', 'registrar', NULL, NULL, NOW(), NOW()),
  ('Request', 'REQ', 'Formal requests and applications',
    '["admin","registrar","dean","department_head","faculty","staff","student"]',
    '["admin","registrar","dean","department_head"]',
    1, 1, 'role', 'registrar', NULL, NULL, NOW(), NOW()),
  ('Report', 'RPT', 'Reports and documentation',
    '["admin","registrar","dean","department_head","faculty","staff"]',
    '["admin","registrar","dean","department_head"]',
    1, 0, NULL, NULL, NULL, NULL, NOW(), NOW()),
  ('Circular', 'CIR', 'Circulars and announcements',
    '["admin","registrar"]',
    '["admin","registrar","dean","department_head","faculty","staff"]',
    1, 0, NULL, NULL, NULL, NULL, NOW(), NOW()),
  ('Resolution', 'RES', 'Official resolutions',
    '["admin","registrar","dean"]',
    '["admin","registrar","dean","department_head"]',
    1, 0, NULL, NULL, NULL, NULL, NOW(), NOW()),
  ('Certificate', 'CERT', 'Certificates and certifications',
    '["admin","registrar","dean","department_head"]',
    '["admin","registrar","dean","department_head"]',
    1, 1, 'role', 'registrar', NULL, NULL, NOW(), NOW()),
  ('Endorsement', 'END', 'Endorsements and recommendations',
    '["admin","registrar","dean","department_head","faculty"]',
    '["admin","registrar","dean","department_head"]',
    1, 0, NULL, NULL, NULL, NULL, NOW(), NOW()),
  ('Notice', 'NOT', 'Notices and advisories',
    '["admin","registrar","dean","department_head"]',
    '["admin","registrar","dean","department_head","faculty","staff"]',
    1, 0, NULL, NULL, NULL, NULL, NOW(), NOW()),
  ('Student Request', 'SREQ', 'Student requests and applications',
    '["admin","student"]',
    '["admin","registrar"]',
    1, 1, 'role', 'registrar', NULL, NULL, NOW(), NOW()),
  ('Department Memo', 'DMEMO', 'Department-specific memorandum',
    '["admin","dean","department_head"]',
    '["admin","registrar","dean","department_head"]',
    1, 1, 'department', NULL, (SELECT id FROM departments WHERE code='REG'), NULL, NOW(), NOW()),
  ('Specific Assignment Test', 'SATEST', 'Test document type with specific user assignment',
    '["admin","registrar","dean","department_head","faculty","staff"]',
    '["admin","registrar","dean","department_head"]',
    1, 0, NULL, NULL, NULL, NULL, NOW(), NOW()),
  ('Other', 'OTH', 'Other document types',
    '["admin","registrar","dean","department_head","faculty","staff"]',
    '["admin","registrar","dean","department_head"]',
    1, 0, NULL, NULL, NULL, NULL, NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`), `allowed_roles` = VALUES(`allowed_roles`), `allowed_receive` = VALUES(`allowed_receive`), `is_active` = VALUES(`is_active`), `auto_assign_enabled` = VALUES(`auto_assign_enabled`), `routing_logic` = VALUES(`routing_logic`), `default_receiver_role` = VALUES(`default_receiver_role`), `default_receiver_department_id` = VALUES(`default_receiver_department_id`), `updated_at` = VALUES(`updated_at`);

-- Tags (slugs provided explicitly; created_by kept NULL to avoid FK issues)
INSERT INTO `tags` (`name`, `slug`, `description`, `is_active`, `usage_count`, `created_by`, `created_at`, `updated_at`) VALUES
  ('Urgent', 'urgent', 'Documents requiring immediate attention', 1, 0, NULL, NOW(), NOW()),
  ('Important', 'important', 'Important documents that need priority', 1, 0, NULL, NOW(), NOW()),
  ('Confidential', 'confidential', 'Confidential documents requiring special handling', 1, 0, NULL, NOW(), NOW()),
  ('Draft', 'draft', 'Draft documents in progress', 1, 0, NULL, NOW(), NOW()),
  ('Approved', 'approved', 'Documents that have been approved', 1, 0, NULL, NOW(), NOW()),
  ('Pending Review', 'pending-review', 'Documents awaiting review', 1, 0, NULL, NOW(), NOW()),
  ('Rejected', 'rejected', 'Documents that have been rejected', 1, 0, NULL, NOW(), NOW()),
  ('Completed', 'completed', 'Completed documents', 1, 0, NULL, NOW(), NOW()),
  ('Archived', 'archived', 'Archived documents', 1, 0, NULL, NOW(), NOW()),
  ('Student Related', 'student-related', 'Documents related to students', 1, 0, NULL, NOW(), NOW()),
  ('Faculty Related', 'faculty-related', 'Documents related to faculty', 1, 0, NULL, NOW(), NOW()),
  ('Administrative', 'administrative', 'Administrative documents', 1, 0, NULL, NOW(), NOW()),
  ('Academic', 'academic', 'Academic documents', 1, 0, NULL, NOW(), NOW()),
  ('Financial', 'financial', 'Financial documents', 1, 0, NULL, NOW(), NOW()),
  ('HR Related', 'hr-related', 'Human resources related documents', 1, 0, NULL, NOW(), NOW())
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`), `is_active` = VALUES(`is_active`), `updated_at` = VALUES(`updated_at`);

SET FOREIGN_KEY_CHECKS=1;
