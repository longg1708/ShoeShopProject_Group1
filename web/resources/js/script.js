/**
 * Custom JavaScript for the Shoe Shop web application
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize Bootstrap tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Auto-dismiss alerts after 5 seconds
    const alertList = document.querySelectorAll('.alert');
    alertList.forEach(function(alert) {
        setTimeout(function() {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
    
    // Quantity input validation
    const quantityInputs = document.querySelectorAll('input[type="number"][name="quantity"]');
    quantityInputs.forEach(function(input) {
        input.addEventListener('change', function() {
            const min = parseInt(this.getAttribute('min') || 1);
            const max = parseInt(this.getAttribute('max') || 100);
            const value = parseInt(this.value) || 0;
            
            if (value < min) {
                this.value = min;
            } else if (value > max) {
                this.value = max;
            }
        });
    });
    
    // Product card hover effect
    const productCards = document.querySelectorAll('.product-card');
    productCards.forEach(function(card) {
        card.addEventListener('mouseenter', function() {
            this.classList.add('shadow');
        });
        
        card.addEventListener('mouseleave', function() {
            this.classList.remove('shadow');
        });
    });
    
    // Carousel auto-play if it exists
    const carousel = document.querySelector('#featuredCarousel');
    if (carousel) {
        const carouselInstance = new bootstrap.Carousel(carousel, {
            interval: 5000,
            wrap: true
        });
    }
    
    // Add to cart confirmation
    const addToCartForms = document.querySelectorAll('form[action*="/cart"]');
    addToCartForms.forEach(function(form) {
        form.addEventListener('submit', function(e) {
            if (this.elements['action'].value === 'add') {
                // Don't actually prevent submission - this is just for demonstration
                // In a real app, you might want to use AJAX to add to cart
                console.log('Product added to cart!');
            }
        });
    });
    
    // Form validation for checkout
    const checkoutForm = document.getElementById('checkoutForm');
    if (checkoutForm) {
        checkoutForm.addEventListener('submit', function(e) {
            // Form validation is handled in the checkout.jsp file
        });
    }
    
    // Highlight active page in navigation
    const currentLocation = window.location.pathname;
    const navLinks = document.querySelectorAll('.navbar-nav .nav-link');
    
    navLinks.forEach(function(link) {
        const linkPath = link.getAttribute('href');
        if (linkPath && currentLocation.includes(linkPath) && linkPath !== '/') {
            link.classList.add('active');
        }
    });
});

/**
 * Formats a currency value
 * @param {number} amount - The amount to format
 * @returns {string} Formatted currency string
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount);
}

/**
 * Updates the cart quantity
 * @param {number} productId - The product ID
 * @param {number} newQuantity - The new quantity value
 */
function updateCartQuantity(productId, newQuantity) {
    // This would be implemented with AJAX in a real application
    console.log(`Updating product ${productId} to quantity ${newQuantity}`);
    
    if (newQuantity <= 0) {
        if (confirm('Remove item from cart?')) {
            // Submit the remove form
            const removeForm = document.querySelector(`form[action*="/cart"] input[name="productId"][value="${productId}"]`)
                .closest('form');
            removeForm.elements['action'].value = 'remove';
            removeForm.submit();
        }
    }
}
