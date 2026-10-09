# V57 Production Checklist

## Database
- [ ] Apply `db/migrations/V57.sql` to each D1 environment.
- [ ] Confirm `tournament_share_audit_daily` exists and both indexes are present.
- [ ] Confirm scheduled Worker execution is enabled.
- [ ] Verify raw audit retention is approximately 90 days and daily aggregation is populated.

## Public share cache
- [ ] Verify HTML, tournament JSON, replay JSON and OG SVG return `ETag`.
- [ ] Verify `x-zato-cache: origin-miss` on origin 200 responses.
- [ ] Verify `x-zato-cache: conditional-hit` on matching `If-None-Match` 304 responses.
- [ ] Verify 304 requests do not increment `views_count` or daily views.
- [ ] Verify CDN/browser behavior independently; `x-zato-cache` describes Worker conditional/origin handling, not external CDN hit status.

## Owner diagnostics
- [ ] Open tournament owner modal and load Share Health.
- [ ] Confirm 30-day audit aggregation is visible.
- [ ] Confirm recent audit events remain visible.
- [ ] Confirm no visitor-identifying data is exposed.

## Limitations
- Full TypeScript/Vite build is blocked by the inherited parser error at `worker/index.ts(442,1397)` and missing installed dependencies in this environment.
- No real Cloudflare deployment, D1, CDN, or browser validation was performed here.
