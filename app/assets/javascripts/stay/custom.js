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

function updateCount(change, maxGuests, button) {
  const counterDiv = button.closest('td').querySelector('.counter');
  const countSpan = counterDiv.querySelector('.number-of-guests-count');
  const countInput = counterDiv.querySelector('.number-of-guests-input');
  const maxGuestMessage = button.closest('td').querySelector('.max-guest-message');

  let currentCount = parseInt(countSpan.textContent);

  // Calculate new count
  const newCount = currentCount + change;

  // Check limits
  if (newCount < 1) {
      return; // Prevent going below 1 guest
  } else if (newCount > maxGuests) {
      maxGuestMessage.style.display = 'block'; // Show message
      return; // Prevent going above max guests
  } else {
      maxGuestMessage.style.display = 'none'; // Hide message if within limits
  }

  // Update displayed count and hidden input
  countSpan.textContent = newCount;
  countInput.value = newCount;
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
