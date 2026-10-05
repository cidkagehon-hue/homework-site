const views       = document.querySelectorAll('.view');
const previewArea = document.querySelector('#preview-area');
const frame       = document.querySelector('#preview-frame');
const openLink    = document.querySelector('#open-link');

function showView(id) {
  views.forEach(v => { v.hidden = (v.id !== id); });
  window.scrollTo(0, 0);
}

function openPreview(src) {
  frame.src = src;
  openLink.href = src;
  previewArea.hidden = false;
}

function closePreview() {
  previewArea.hidden = true;
  frame.src = 'about:blank';
}

// One listener for the whole page (event delegation)
document.addEventListener('click', (e) => {
  // Week, day, and back buttons all carry data-target="id-of-the-page-to-show"
  const nav = e.target.closest('[data-target]:not(.empty)');
  if (nav) { showView(nav.dataset.target); return; }

  const box = e.target.closest('.box');
  if (box) {
    e.preventDefault();            // don't leave the page
    openPreview(box.dataset.src);  // show homework in the frame
    return;
  }

  if (e.target.id === 'close-btn') closePreview();
});

document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closePreview();
});