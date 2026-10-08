# ZATO Chess V21 — Release Notes

## Social Notification Center
- Added persistent D1 notifications for friend requests, friend acceptance/rejection, game invitations, and invitation outcomes.
- Added `/api/notifications` and `/api/notifications/read`.
- Social button now shows a combined unread badge.
- Social modal displays recent notifications.
- Sent game invitations now show `pending`, `accepted`, `declined`, or `expired`.
- Pending sent invitations are automatically expired when their 10-minute window ends.

## Continuation
Read `ZATO_PROJECT_CONTEXT.md` first in the next chat. V21 uses polling for live refresh; true push/WebSocket social notifications remain the next infrastructure step.
