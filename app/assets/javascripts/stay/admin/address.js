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

  $('#country-select').change(function() {
    var countryId = $(this).val();

    if (countryId) {
      $.ajax({
        url: '/stay/admin/countries/' + countryId + '/states',
        type: 'GET',
        dataType: 'json',
        cache: true,
        success: function(data) {
          $('#statesContainer tbody').empty();
          if (data.length > 0) {
            data.forEach(function(state) {
              const row = `
                <tr>
                  <td>${state.name}</td>
                  <td>${state.abbr}</td>
                  <td class="text-end d-flex justify-content-end">
                    <a href="/stay/admin/countries/${state.country_id}/states/${state.id}/edit" class="btn d-inline-flex btn-sm btn-neutral mx-1">
                      <i class="bi bi-pencil"></i> Edit
                    </a>
                    <button type="button" class="btn btn-sm btn-neutral mx-1 text-danger-hover" onclick="event.preventDefault(); document.getElementById('delete-form-${state.id}').submit();">
                      <i class="bi bi-trash"></i> Destroy
                    </button>
                    <form id="delete-form-${state.id}" action="/stay/admin/countries/${state.country_id}/states/${state.id}" method="post" style="display: none;">
                      <input type="hidden" name="_method" value="delete">
                      <input type="hidden" name="authenticity_token" value="${$('meta[name="csrf-token"]').attr('content')}">
                    </form>
                  </td>
                </tr>
              `;
              $('#statesContainer tbody').append(row);
            });
          } else {
            $('#statesContainer tbody').append('<tr><td colspan="3">No states available for this country.</td></tr>');
          }
          // Optionally update state count
          $('#state-count').text(data.length);
        },
        error: function(xhr, status, error) {
          $('#statesContainer tbody').empty().append('<tr><td colspan="3">Error fetching states. Please try again.</td></tr>');
        }
      });
    } else {
      $('#statesContainer tbody').empty().append('<tr><td colspan="3">Select a country to see states.</td></tr>');
    }
  });

  $('#country-select').on('change', function() {
    var selectedCountryId = $(this).val(); // Get the selected country ID
    if (selectedCountryId) {
      $('#add-new-state').attr('href', '/stay/admin/countries/' + selectedCountryId + '/states/new');
    } else {
      $('#add-new-state').attr('href', '#');
    }
  });


  $('#state-select').change(function() {
    var stateId = $(this).val();

    if (stateId) {
      $.ajax({
        url: '/stay/admin/states/' + stateId + '/cities',
        type: 'GET',
        dataType: 'json',
        cache: true,
        success: function(data) {
          $('#citiesContainer tbody').empty();
          if (data.length > 0) {
            data.forEach(function(city) {
              const row = `
                <tr>
                  <td>${city.name}</td>
                  <td class="text-end d-flex justify-content-end">
                    <a href="/stay/admin/states/${city.state_id}/cities/${city.id}/edit" class="btn d-inline-flex btn-sm btn-neutral mx-1">
                      <i class="bi bi-pencil"></i> Edit
                    </a>
                    <button type="button" class="btn btn-sm btn-neutral mx-1 text-danger-hover" onclick="event.preventDefault(); document.getElementById('delete-form-${city.id}').submit();">
                      <i class="bi bi-trash"></i> Destroy
                    </button>
                    <form id="delete-form-${city.id}" action="/stay/admin/states/${city.state_id}/cities/${city.id}" method="post" style="display: none;">
                      <input type="hidden" name="_method" value="delete">
                      <input type="hidden" name="authenticity_token" value="${$('meta[name="csrf-token"]').attr('content')}">
                    </form>
                  </td>
                </tr>
              `;
              $('#citiesContainer tbody').append(row);
            });
          } else {
            $('#citiesContainer tbody').append('<tr><td colspan="3">No Cities available for this state.</td></tr>');
          }
        },
        error: function(xhr, status, error) {
          $('#citiesContainer tbody').empty().append('<tr><td colspan="3">Error fetching states. Please try again.</td></tr>');
        }
      });
      } else {
        $('#citiesContainer tbody').empty().append('<tr><td colspan="3">Select a State to see states.</td></tr>');
      }
  });

  $('#state-select').on('change', function() {
    var selectedStateId = $(this).val();

    if (selectedStateId) {
        $('#add-new-city').attr('href', '/stay/admin/states/' + selectedStateId + '/cities/new');
    } else {
        $('#add-new-city').attr('href', '#');
    }
  });
});

