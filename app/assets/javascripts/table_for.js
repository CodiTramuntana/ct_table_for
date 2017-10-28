document.addEventListener('DOMContentLoaded', function() {
  const wrapper = document.querySelector(".table-for-wrapper");
  if (wrapper) {
    wrapper.addEventListener('click', function(event) {
      const tr = event.target.closest("tr");
      if (tr && tr.dataset.href) {
        window.location = tr.dataset.href
      }
    });
  }
});
