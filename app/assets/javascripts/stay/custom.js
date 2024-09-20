document.addEventListener('DOMContentLoaded', function() {
  // Admin-specific JS here
  console.log('Admin JS loaded');
  // You can initialize Select2 here as well
  $('select').select2();

  flatpickr("input[data-behavior='flatpickr']", {
    enableTime: false, // Only date picker, no time
    dateFormat: "Y-m-d", // Date format (e.g., 2024-09-16)
    monthSelectorType: "dropdown" // Enable month dropdown selector
  });
});

function toggleDropdown() {
  const content = document.getElementById('dropdownContent');
  content.classList.toggle('open');
  updateArrow();
}

function updateCount(type, change) {
  const countElement = document.getElementById(`${type}-count`);
  let count = parseInt(countElement.textContent);
  count = Math.max(0, count + change);
  if (type === 'adults') count = Math.max(1, count);
  countElement.textContent = count;
  updateTotalGuests();
}

function updateTotalGuests() {
  const adults = parseInt(document.getElementById('adults-count').textContent);
  const children = parseInt(document.getElementById('children-count').textContent);
  const total = adults + children;
  document.getElementById('guest-summary').textContent = `${total} guest${total !== 1 ? 's' : ''} ▼`;
}

function updateArrow() {
  const summary = document.getElementById('guest-summary');
  const isOpen = document.getElementById('dropdownContent').classList.contains('open');
  summary.textContent = summary.textContent.replace(/[▼▲]/, isOpen ? '▲' : '▼');
}