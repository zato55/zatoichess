# ZATO Chess V50 — Public Share Analytics + OG Image + Read-only Replay Board

## Eklenenler
- Public tournament share view counter (`views_count`, `last_viewed_at`).
- Owner-only share statistics endpoint.
- Dynamic SVG Open Graph image endpoint.
- `og:image` + Twitter large-card metadata.
- Public replay deep-link now renders a read-only chessboard from stored FEN snapshots.
- Previous/next replay controls and PGN remain available.
- V50 migration, regression script, production checklist and continuation context.

## Güvenlik
- Share token yalnızca SHA-256 hash olarak saklanır.
- Public endpoints token doğrulaması yapar ve yalnızca tokenın bağlı olduğu turnuva/maç verisini döndürür.
- Oda kodları, session bilgileri ve özel hesap alanları public payload'a eklenmez.
- Share analytics yalnızca turnuva sahibine açıktır.
