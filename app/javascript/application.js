// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


  document.addEventListener('DOMContentLoaded', () => {
    const menuToggle = document.getElementById('main-menu');
    const menuClose = document.getElementById('main-menu-close');
    const mobileMenu = document.getElementById('mobile-menu');

    menuToggle.addEventListener('click', () => {
      mobileMenu.classList.remove('hidden');
    });

    menuClose.addEventListener('click', () => {
      mobileMenu.classList.add('hidden');
    });
  });
