$(document).ready(function() {
  $('#country_select').on('change', function() {
    var countryId = $(this).val();
    var stateSelect = $('#state_select');
    stateSelect.empty();

    if (countryId) {
      $.ajax({
        url: '/stay/admin/countries/' + countryId + '/states',
        method: 'GET',
        dataType: 'json',
        success: function(states) {
          stateSelect.append('<option value="">Select State</option>');
          $.each(states, function(index, state) {
            stateSelect.append('<option value="' + state.id + '">' + state.name + '</option>');
          });
        },
        error: function() {
          alert('Error fetching states.');
        }
      });
    } else {
      stateSelect.append('<option value="">Select State</option>');
    }
  });

  // Fetch cities when a state is selected
  $('#state_select').on('change', function() {
    var stateId = $(this).val();
    var citySelect = $('#city_select');
    citySelect.empty(); 

    if (stateId) {
      $.ajax({
        url: '/stay/admin/states/' + stateId + '/cities',
        method: 'GET',
        dataType: 'json',
        success: function(cities) {
          citySelect.append('<option value="">Select City</option>');
          $.each(cities, function(index, city) {
            citySelect.append('<option value="' + city.id + '">' + city.name + '</option>');
          });
        },
        error: function() {
          alert('Error fetching cities.');
        }
      });
    } else {
      citySelect.append('<option value="">Select City</option>');
    }
  });
});

