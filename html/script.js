let config = {
    position: 'top-right',
    offsetX: 20,
    offsetY: 20,
    spacing: 10,
    theme: 'dark',
    autoTheme: true,
    animationDuration: 300,
    animationType: 'slide',
    maxNotifications: 5
};

let notifications = [];
let container = null;
let themeListenerAdded = false;
let resourceName = 'plush-notifications';

// Initialize
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'init') {
        initialize(data.config);
    } else if (data.action === 'playSound') {
        playSound(data.sound, data.volume);
    } else if (data.action === 'showNotification') {
        showNotification(data.data);
    } else if (data.action === 'removeNotification') {
        removeNotification(data.id);
    } else if (data.action === 'clearNotifications') {
        clearNotifications();
    }
});

function initialize(initialConfig) {
    config = { ...config, ...initialConfig };
    container = document.getElementById('notification-container');
    
    if (!container) return;
    
    // Set position class
    container.className = config.position;
    
    // Apply theme
    applyTheme();
    
    // Auto theme detection - only add listener once to prevent stack overflow
    if (config.autoTheme && config.theme === 'auto' && !themeListenerAdded) {
        themeListenerAdded = true;
        const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
        mediaQuery.addEventListener('change', applyTheme);
    }
}

function applyTheme() {
    if (config.theme === 'dark' || (config.theme === 'auto' && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.body.classList.add('dark-theme');
    } else {
        document.body.classList.remove('dark-theme');
    }
}

function playSound(soundFile, volume) {
    if (!soundFile) return;
    try {
        const resName = typeof GetParentResourceName === 'function' ? GetParentResourceName() : resourceName;
        const audio = new Audio(`https://cfx-nui-${resName}/${soundFile}`);
        audio.volume = Math.min(1, Math.max(0, volume || 0.7));
        audio.play().catch(() => {});
    } catch (e) {}
}

function showNotification(data) {
    if (!container) {
        container = document.getElementById('notification-container');
        if (!container) return;
    }
    
    // Remove oldest if at max
    if (notifications.length >= config.maxNotifications) {
        const oldest = notifications.shift();
        removeNotification(oldest.id, true);
    }
    
    // Create notification element
    const notification = createNotificationElement(data);
    
    // Add to DOM
    container.appendChild(notification);
    notifications.push({ id: data.id, element: notification, data: data });
    
    // Trigger animation
    requestAnimationFrame(() => {
        notification.classList.add('show');
    });
    
    // Auto remove if duration > 0
    if (data.duration > 0) {
        const progressBar = notification.querySelector('.notification-progress');
        if (progressBar) {
            progressBar.style.transitionDuration = data.duration + 'ms';
            progressBar.style.width = '0%';
        }
        
        setTimeout(() => {
            removeNotification(data.id);
        }, data.duration);
    }
}

function createNotificationElement(data) {
    const notification = document.createElement('div');
    notification.className = `notification animation-${config.animationType}`;
    notification.id = `notification-${data.id}`;
    
    // Apply theme
    if (config.theme === 'dark' || (config.theme === 'auto' && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        notification.classList.add('dark');
    }
    
    // Set border color
    notification.style.borderLeftColor = data.color;
    notification.style.color = data.color;
    
    // Icon
    const icon = document.createElement('div');
    icon.className = 'notification-icon';
    icon.innerHTML = getIcon(data.icon);
    
    // Content
    const content = document.createElement('div');
    content.className = 'notification-content';
    
    if (data.title) {
        const title = document.createElement('div');
        title.className = 'notification-title';
        title.textContent = data.title;
        content.appendChild(title);
    }
    
    const message = document.createElement('div');
    message.className = 'notification-message';
    message.textContent = data.message;
    content.appendChild(message);
    
    // Progress bar
    const progress = document.createElement('div');
    progress.className = 'notification-progress';
    progress.style.width = '100%';
    progress.style.backgroundColor = data.color;
    
    // Assemble
    notification.appendChild(icon);
    notification.appendChild(content);
    notification.appendChild(progress);
    
    return notification;
}

function getIcon(iconName) {
    // Default icons (you can extend this)
    const defaultIcons = {
        'check-circle': '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>',
        'x-circle': '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>',
        'info': '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>',
        'alert-triangle': '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>',
        'bell': '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" /></svg>',
        'star': '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z" /></svg>'
    };
    
    return defaultIcons[iconName] || defaultIcons['info'];
}

function removeNotification(id, immediate = false) {
    const notificationIndex = notifications.findIndex(n => n.id === id);
    if (notificationIndex === -1) return;
    
    const notification = notifications[notificationIndex].element;
    
    if (immediate) {
        notification.remove();
        notifications.splice(notificationIndex, 1);
    } else {
        notification.classList.remove('show');
        notification.classList.add('hide');
        
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
            const idx = notifications.findIndex(n => n.id === id);
            if (idx !== -1) notifications.splice(idx, 1);
            
            // Notify parent (wrap in try-catch to prevent stack overflow)
            try {
                fetch(`https://${resourceName}/notificationRemoved`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ id: id })
                });
            } catch (err) {}
        }, config.animationDuration);
    }
}

function clearNotifications() {
    // Remove all notification elements from DOM
    const toRemove = [...notifications];
    notifications = [];
    toRemove.forEach(notif => {
        if (notif.element && notif.element.parentNode) {
            notif.element.remove();
        }
    });
}

// Set resource name once at load (FiveM injects GetParentResourceName)
(function() {
    if (typeof window.GetParentResourceName === 'function') {
        resourceName = window.GetParentResourceName();
    }
})();
