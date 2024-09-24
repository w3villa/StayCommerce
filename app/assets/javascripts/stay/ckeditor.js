//= require stay/admin/ckeditor.min
document.addEventListener("DOMContentLoaded", function() {
  const editors = document.querySelectorAll('textarea.ckeditor');
  editors.forEach(editor => {
    ClassicEditor
      .create(editor)
      .catch(error => {
        console.error(error);
      });
  });
});