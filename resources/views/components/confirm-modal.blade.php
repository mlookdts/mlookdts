<script>
window.showConfirmModal = function(title, message, callback, options) {
    const opts = options || {};
    const modal = document.getElementById('deleteModal');
    const titleEl = document.getElementById('deleteModalTitle');
    const msgEl = document.getElementById('deleteModalMessage');
    const confirmBtn = modal.querySelector('button[onclick="confirmDelete()"]');
    const iconBg = modal.querySelector('.rounded-full');
    const icon = iconBg ? iconBg.querySelector('svg') : null;
    
    if (!modal || !titleEl || !msgEl || !confirmBtn) {
        console.error('Confirm modal elements not found');
        return;
    }
    
    titleEl.textContent = title || 'Confirm';
    msgEl.textContent = message || 'Are you sure you want to proceed?';
    confirmBtn.textContent = opts.confirmText || 'Confirm';
    
    // Apply custom classes for button
    if (opts.confirmClass) {
        confirmBtn.className = 'flex-1 min-h-[44px] ' + opts.confirmClass;
    } else {
        confirmBtn.className = 'flex-1 btn-danger min-h-[44px]';
    }
    
    // Apply custom classes for title
    if (opts.titleClass) {
        titleEl.className = 'text-lg sm:text-xl font-semibold ' + opts.titleClass;
    } else {
        titleEl.className = 'text-lg sm:text-xl font-semibold text-red-600 dark:text-red-400';
    }
    
    // Apply custom classes for icon background
    if (iconBg && opts.iconBgClass) {
        iconBg.className = 'mx-auto flex h-10 w-10 sm:h-12 sm:w-12 flex-shrink-0 items-center justify-center rounded-full ' + opts.iconBgClass;
    } else if (iconBg) {
        iconBg.className = 'mx-auto flex h-10 w-10 sm:h-12 sm:w-12 flex-shrink-0 items-center justify-center rounded-full bg-red-100 dark:bg-red-900/30';
    }
    
    // Apply custom classes for icon
    if (icon && opts.iconClass) {
        icon.className = 'w-5 h-5 sm:w-6 sm:h-6 ' + opts.iconClass;
    } else if (icon) {
        icon.className = 'w-5 h-5 sm:w-6 sm:h-6 text-red-600 dark:text-red-400';
    }
    
    // Set the callback on window so confirmDelete can access it
    window.deleteCallback = callback;
    
    modal.classList.remove('hidden');
    modal.classList.add('flex');
    document.body.style.overflow = 'hidden';
};

window.closeConfirmModal = window.closeDeleteModal;
window.confirmConfirm = window.confirmDelete;
</script>
