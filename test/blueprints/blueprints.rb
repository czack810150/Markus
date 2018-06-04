require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.section_name {Faker::Name.name}

Sham.user_name {Faker::Internet.user_name}
Sham.admin_user_name {|i| "machinist_admin#{i}"}
Sham.student_user_name {|i| "machinist_student#{i}"}
Sham.ta_user_name {|i| "machinist_ta#{i}"}
Sham.first_name {Faker::Name.first_name}
Sham.last_name {Faker::Name.last_name}
Sham.api_key {|i| "API_KEY_N_#{i}"}

Sham.filename { "#{Faker::Lorem.words(1)[0]}.java"}
Sham.group_name {|i| "machinist_group#{i}"}
Sham.grouping_name {|i| "machinist_grouping#{i}"}

Sham.short_identifier {|i| "machinist_A#{i}"}
Sham.description {Faker::Lorem.sentence(2)}
Sham.message {Faker::Lorem.sentence(2)}
Sham.due_date {rand(50).days.from_now}

Sham.notes_message {Faker::Lorem.paragraphs}

Sham.overall_comment {Faker::Lorem.sentence(3)}

Sham.name {|i| "machinist_flexible_criterion_#{i}"}
Sham.name {|i| "machinist_rubric_criterion_#{i}"}

Sham.date {rand(50).days.from_now}
Sham.name {Faker::Name.name}

Sham.filename {|i| "file#{i}"}
Sham.filetype {|i| ['test', 'lib', 'parse'][i % 3] }
Sham.path {|i| "path#{i}"}

Sham.annotation_category_name {|i| "Machinist Annotation Category #{i}"}

Admin.blueprint do
  user_name {Sham.admin_user_name}
  first_name {Sham.first_name}
  last_name {Sham.last_name}
  api_key
end

AnnotationCategory.blueprint do
  assignment {Assignment.make}
  annotation_category_name {Sham.name}
end

AnnotationText.blueprint do
  annotation_category {AnnotationCategory.make}
  content {'content'}
  user {Admin.make}
end

Assignment.blueprint do
  short_identifier
  description
  message
  due_date
  group_min {2}
  group_max {4}
  student_form_groups {true}
  invalid_override {false}
  group_name_autogenerated {true}
  repository_folder {"repo/#{short_identifier}"}
  submission_rule {NoLateSubmissionRule.make}
  allow_web_submits {true}
  vcs_submit { false }
  has_peer_review { false }
  display_grader_names_to_students {false}
  section_due_dates_type(false)
  enable_test {true}
  enable_student_tests {true}
  tokens_per_period {10}
  token_period {24}
  token_start_date {1.days.from_now}
  non_regenerating_tokens {false}
  unlimited_tokens {false}
  assign_graders_to_criteria {false}
  assignment_stat
end

AssignmentFile.blueprint do
  assignment
  filename
end

AssignmentStat.blueprint do
end

CriterionTaAssociation.blueprint do
  criterion
  ta
end

ExtraMark.blueprint do
  extra_mark {2}
  result
  unit{'percentage'}
end

FlexibleCriterion.blueprint do
  assignment {Assignment.make}
  name
  description
  position {1} # override if many for the same assignment
  max_mark {10}
  assigned_groups_count {0}
  ta_visible {true}
  peer_visible {false}
end

Grade.blueprint do
  grade_entry_item {GradeEntryItem.make}
  grade_entry_student {GradeEntryStudent.make}
  grade {0}
end

GracePeriodDeduction.blueprint do
  membership  {StudentMembership.make}
  deduction {20}
end

GracePeriodSubmissionRule.blueprint do
  assignment_id {0}
  type {'GracePeriodSubmissionRule'}
end

GradeEntryForm.blueprint do
  short_identifier
  description
  message
  date
  is_hidden {false}
end

GradeEntryItem.blueprint do
  grade_entry_form
  name
  out_of {10}
end

GradeEntryStudent.blueprint do
  grade_entry_form {GradeEntryForm.make}
  user {Student.make}
  released_to_student {false}
end

Group.blueprint do
  group_name {Sham.group_name}
  repo_name {group_name}
end

Grouping.blueprint do
  grouping_queue { nil }
  group {Group.make}
  assignment {Assignment.make}
  criteria_coverage_count {0}
end

ImageAnnotation.blueprint do
  x1 {0}
  x2 {10}
  y1 {0}
  y2 {10}
  is_remark {false}
  submission_file
  annotation_text
  annotation_text_id {annotation_text.id}
  submission_file_id {submission_file.id}
  annotation_number {rand(1000)+1}
  creator {Admin.make}
  result { Result.make }
end

Mark.blueprint do
  result {Result.make}
  markable {RubricCriterion.make(assignment: result.submission.grouping.assignment)}
  mark {1}
end

Mark.blueprint(:rubric) do
  result {Result.make}
  markable {RubricCriterion.make(assignment: result.submission.grouping.assignment)}
end

Mark.blueprint(:flexible) do
  result {Result.make}
  markable {FlexibleCriterion.make(assignment: result.submission.grouping.assignment)}
end

Note.blueprint do
  noteable_type  {'Grouping'}
  noteable_id {Grouping.make.id}
  user {Admin.make}
  notes_message { Faker::Lorem.paragraphs[0] }
end

NoLateSubmissionRule.blueprint do
  assignment_id {0}
end

Result.blueprint do
  submission {Submission.make}
  marking_state {Result::MARKING_STATES[:incomplete]}
  total_mark {0}
end

RubricCriterion.blueprint do
  assignment {Assignment.make}
  name {Sham.name}
  position {1}  # override if many for the same assignment
  max_mark {4}
  assigned_groups_count {0}
  level_0_name {'Horrible'}
  level_1_name {'Poor'}
  level_2_name {'Satisfactory'}
  level_3_name {'Good'}
  level_4_name {'Excellent'}
  ta_visible {true}
  peer_visible {false}
end

Section.blueprint do
  name {Sham.section_name}
end

SectionDueDate.blueprint do
  section {Section.make}
  assignment {Assignment.make}
  due_date
end

Student.blueprint do
  user_name {Sham.student_user_name}
  first_name {Sham.first_name}
  last_name {Sham.last_name}
  section
  grace_credits {5}
end

Student.blueprint(:hidden) do
  hidden { true }
end

StudentMembership.blueprint do
  user {Student.make}
  grouping
  membership_status {StudentMembership::STATUSES[:pending]}
end

Submission.blueprint do
  grouping {Grouping.make}
  submission_version {1}
  submission_version_used {true}
  revision_identifier {1}
  revision_timestamp {1.days.ago}
end

SubmissionFile.blueprint do
  submission {Submission.make}
  filename {Sham.name}
  path {Sham.filename}
end

PenaltyDecayPeriodSubmissionRule.blueprint do
  assignment_id {0}
  type {'PenaltyDecayPeriodSubmissionRule'}
end

PenaltyPeriodSubmissionRule.blueprint do
  assignment_id {0}
  type {'PenaltyPeriodSubmissionRule'}
end

Period.blueprint do
  submission_rule_id {0}
  hours {rand(24)}
end

Ta.blueprint do
  user_name {Sham.ta_user_name}
  first_name {Sham.first_name}
  last_name {Sham.last_name}
  api_key
end

TaMembership.blueprint do
  user {Ta.make}
  grouping
  membership_status {'pending'}
end

TestScript.blueprint do
  assignment {Assignment.make}
  seq_num {0}
  file_name {Sham.filename}
  description {Sham.description}
  run_by_instructors {true}
  run_by_students {false}
  halts_testing {false}
  display_description {'do_not_display'}
  display_run_status {'do_not_display'}
  display_marks_earned {'do_not_display'}
  display_input {'do_not_display'}
  display_expected_output {'do_not_display'}
  display_actual_output {'do_not_display'}
end

TestSupportFile.blueprint do
  file_name {Sham.filename}
  assignment {Assignment.make}
  description {Sham.description}
end

TestScriptResult.blueprint do
  test_script {TestScript.make}
  marks_earned {1}
  marks_total {1}
end

TestFile.blueprint do
  filename {Sham.filename}
  filetype {Sham.filetype}
end

TestResult.blueprint do
  test_script_result {TestScriptResult.make}
  name {Sham.filename}
  completion_status {'pass'}
  marks_earned {1}
  marks_total {1}
  input {Sham.message}
  actual_output {Sham.message}
  expected_output {Sham.message}
end

TextAnnotation.blueprint do
  line_start { 0 }
  line_end { 1 }
  column_start { 2 }
  column_end { 3 }
  submission_file
  is_remark { false }
  annotation_text
      AnnotationText.make(
          annotation_category: AnnotationCategory.make(
              assignment: submission_file.submission.grouping.assignment))
  annotation_number { rand(1000) + 1 }
  creator { Admin.make }
  result { Result.make }
end
