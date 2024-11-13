document.addEventListener('DOMContentLoaded', function() {
    const toasts = document.querySelectorAll('.flash');
    toasts.forEach(toast => {
      const closeIcon = toast.querySelector('.close');
      const progress = toast.querySelector('.progress');
      let timer1, timer2;

      toast.classList.add('active');
      progress.classList.add('active');

      timer1 = setTimeout(() => {
        toast.classList.remove('active');
      }, 5000);

      timer2 = setTimeout(() => {
        progress.classList.remove('active');
      }, 5300);

      closeIcon.addEventListener('click', () => {
        toast.classList.remove('active');
        setTimeout(() => {
          progress.classList.remove('active');
        }, 300);
        clearTimeout(timer1);
        clearTimeout(timer2);
      });
    });
  });