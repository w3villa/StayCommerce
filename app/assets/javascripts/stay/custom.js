document.addEventListener('DOMContentLoaded', function() {
  flatpickr("input[data-behavior='flatpickr']", {
    enableTime: false, // Only date picker, no time
    dateFormat: "Y-m-d", // Date format (e.g., 2024-09-16)
  });
});

document.addEventListener('DOMContentLoaded', function() {
  // Admin-specific JS here
  console.log('Admin JS loaded');
  // You can initialize Select2 here as well
  $('select').select2();
});

