self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', event => event.waitUntil(self.clients.claim()));
self.addEventListener('push', event => {
  const data = event.data ? (() => { try { return event.data.json(); } catch { return {}; } })() : {};
  const title = data.title || 'ZATO Chess';
  const options = { body: data.body || 'Yeni bir bildirimin var.', icon: '/favicon.svg', badge: '/favicon.svg', data: data.url || '/?social=1', tag: data.tag || 'zato-social', renotify: true };
  event.waitUntil(self.registration.showNotification(title, options));
});
self.addEventListener('notificationclick', event => {
  event.notification.close();
  const target = event.notification.data || '/?social=1';
  event.waitUntil((async () => {
    const list = await clients.matchAll({ type: 'window', includeUncontrolled: true });
    for (const client of list) { if ('focus' in client) { await client.focus(); if ('navigate' in client) await client.navigate(target); return; } }
    if (clients.openWindow) await clients.openWindow(target);
  })());
});
