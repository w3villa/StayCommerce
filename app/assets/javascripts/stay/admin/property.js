$(document).ready(function() {
  var ruleIndex = parseInt($('#additional_rules').data('initial-index'));

  $('#add_rule_button').on('click', function() {
    ruleIndex++;
    var newRuleHtml = `
      <div class="row mb-3 additional_rule" data-index="${ruleIndex}">
        <div class="col-md-9">
          <input type="text" name="property[additional_rules_attributes][${ruleIndex}][name]" class="form-control" placeholder="Rule Name" />
        </div>
        <div class="col-md-3">
          <input type="hidden" name="property[additional_rules_attributes][${ruleIndex}][_destroy]" class="rule-destroy-field" value="false" />
          <i class="bi bi-trash remove-rule" style="cursor: pointer;"></i>
        </div>
      </div>`;
    $('#additional_rules').append(newRuleHtml);
  });

  $(document).on('click', '.remove-rule', function() {
    var ruleRow = $(this).closest('.additional_rule');
    ruleRow.find('.rule-destroy-field').val('true');
    ruleRow.hide();
  });
});
