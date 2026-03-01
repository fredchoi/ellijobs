// ellijobs.com - Brand Landing Page

document.addEventListener('DOMContentLoaded', function () {
  // Dynamic year in footer
  const yearEl = document.getElementById('year');
  if (yearEl) {
    yearEl.textContent = new Date().getFullYear();
  }
});
