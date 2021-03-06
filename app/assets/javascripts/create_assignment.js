$(document).ready(function () {
  // Change repo folder to be same as short identifier
  $('#assignment_short_identifier').keyup(function () {
    $('#assignment_repository_folder').val($(this).val());
  });

  $('#assignment_due_date').change(function () {
    update_due_date($('#assignment_due_date').val());
  });

  $('#assignment_section_due_dates_type').change(function () {
    toggle_sections_due_date(this.checked);
  });
  toggle_sections_due_date(
    $('#assignment_section_due_dates_type').is(':checked'));

  $('.section_due_date_input').change(function () {
    if ($('#assignment_due_date').val() === '') {
      $('#assignment_due_date').val($(this).val());
    }
  });

  $('#persist_groups').change(function () {
    toggle_persist_groups(this.checked);
  });

  $('#is_group_assignment').change(function () {
    toggle_group_assignment(this.checked);
  });

  toggle_group_assignment($('#is_group_assignment').is(':checked'));

  $('#assignment_student_form_groups').change(function () {
    toggle_student_form_groups(this.checked);
  });

  $('#assignment_allow_remarks').change(function () {
    toggle_remark_requests(this.checked);
  });

  $('#submission_rule_fields input[type=radio]').change(
    change_submission_rule);

  change_submission_rule(); // Opens the correct rule

  // Min group size must be <= max group size
  // If the min value is larger than the max, make the max this new value
  $('#assignment_group_min').change(function () {
    if (!check_group_size()) {
      document.getElementById('assignment_group_max').value = this.value;
    }
  });

  // If the max value is smaller than the min, make the min this new value
  $('#assignment_group_max').change(function () {
    if (!check_group_size()) {
      document.getElementById('assignment_group_min').value = this.value;
    }
  });
});


function check_group_size() {
  var min = document.getElementById('assignment_group_min').value;
  var max = document.getElementById('assignment_group_max').value;

  return min <= max;
}

function toggle_persist_groups(persist_groups) {
  $('#persist_groups_assignment').prop('disabled', !persist_groups);
  $('#is_group_assignment').prop('disabled', persist_groups);
  $('#is_group_assignment_style').toggleClass('disable', persist_groups);
}

function toggle_group_assignment(is_group_assignment) {
  $('.group_properties').toggle(is_group_assignment);
  if (!is_group_assignment) {
    // Toggle the min/max fields depending on if students form their own groups
    var student_groups_field = document.getElementById('assignment_student_form_groups');
    if (student_groups_field) {
      var student_groups = student_groups_field.checked;
      toggle_student_form_groups(student_groups);

      $('#persist_groups').prop('disabled', is_group_assignment);
      $('#persist_groups_assignment_style').toggleClass('disable', is_group_assignment);
    }
  }
}

function toggle_student_form_groups(student_form_groups) {
  $('#assignment_group_min').prop('disabled', !student_form_groups);
  $('#assignment_group_max').prop('disabled', !student_form_groups);
  $('#group_limit_style').toggleClass('disable', !student_form_groups);
  $('#group_name_autogenerated_style').toggleClass('disable', student_form_groups);
  $('#assignment_group_name_autogenerated').prop('disabled', student_form_groups);

  if (student_form_groups) {
    $('#assignment_group_name_autogenerated').prop('checked', true);
  }
}

function toggle_remark_requests(bool) {
  $('#remark_properties').toggle(bool);
}

function update_due_date(new_due_date) {
  // Does nothing if {grace, penalty_decay, penalty}_periods already created
  create_grace_periods();
  create_penalty_decay_periods();
  create_penalty_periods();

  grace_periods.set_due_date(new_due_date);
  penalty_decay_periods.set_due_date(new_due_date);
  penalty_periods.set_due_date(new_due_date);

  grace_periods.refresh();
  penalty_decay_periods.refresh();
  penalty_periods.refresh();
}

function toggle_sections_due_date(section_due_dates_type) {
  $('#section_due_dates_information').toggle(section_due_dates_type);
}

function change_submission_rule() {
  $('#grace_periods, #penalty_periods, #penalty_decay_periods').hide();
  $('#grace_periods input, #penalty_periods input,' +
    '#penalty_decay_periods input').prop('disabled', 'disabled');
  if ($('#grace_period_submission_rule').is(':checked')) {
    $('#grace_periods').show();
    $('#grace_periods input').prop('disabled', '');
  }
  if ($('#penalty_decay_period_submission_rule').is(':checked')) {
    $('#penalty_decay_periods').show();
    $('#penalty_decay_periods input').prop('disabled', '');
  }
  if ($('#penalty_period_submission_rule').is(':checked')) {
    $('#penalty_periods').show();
    $('#penalty_periods input').prop('disabled', '');
  }
}

function toggle_field_student_tests(is_disabled) {
  $('#are_student_tests_enabled').attr('disabled', is_disabled);
}

function toggle_field_token_config(is_disabled) {
  $('#assignment_unlimited_tokens').attr('disabled', is_disabled);
  $('#assignment_token_start_date').attr('disabled', is_disabled);
  $('#assignment_non_regenerating_tokens').attr('disabled', is_disabled);
}

function toggle_field_token_limits(is_disabled) {
  $('#assignment_tokens_per_period').attr('disabled', is_disabled);
}

function toggle_field_token_regen(is_disabled) {
  $('#assignment_token_period').attr('disabled', is_disabled);
}

function toggle_tests(is_testing_framework_enabled) {
  $('#is_testing_framework_enabled').val(is_testing_framework_enabled);
  if (is_testing_framework_enabled) {
    toggle_field_student_tests(false);
    if ($('#are_student_tests_enabled').is(':checked')) {
      toggle_field_token_config(false);
      if (!$('#assignment_unlimited_tokens').is(':checked')) {
        toggle_field_token_limits(false);
        toggle_field_token_regen(false);
      }
    }
  } else {
    toggle_field_student_tests(true);
    toggle_field_token_config(true);
    toggle_field_token_limits(true);
    toggle_field_token_regen(true);
  }
}

function toggle_student_tests(are_student_tests_enabled) {

  $('#are_student_tests_enabled').val(are_student_tests_enabled);
  if (are_student_tests_enabled) {
    toggle_field_token_config(false);
    if (!$('#assignment_unlimited_tokens').is(':checked')) {
      toggle_field_token_limits(false);
      toggle_field_token_regen(false);
    }
  } else {
    toggle_field_token_config(true);
    toggle_field_token_limits(true);
    toggle_field_token_regen(true);
  }
}

function toggle_tests_tokens(is_unlimited) {
  $('#assignment_unlimited_tokens').val(is_unlimited);
  if (is_unlimited) {
    toggle_field_token_limits(true);
    toggle_field_token_regen(true);
  } else {
    toggle_field_token_limits(false);
    toggle_field_token_regen(false);
  }
}

function toggle_token_regeneration(does_not_regenerate) {
  $('#assignment_non_regenerating_tokens').val(does_not_regenerate);
  if (does_not_regenerate) {
    toggle_field_token_regen(true);
  } else {
    toggle_field_token_regen(false);
  }
}
