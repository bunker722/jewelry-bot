-- ============================================================
-- Миграция: физическое местонахождение камня
-- Использует УЖЕ существующие таблицы/поля:
--   stones.location_id            (FK -> locations.id)      — уже есть
--   operations.location_from/_to  (FK -> locations.id)      — уже есть
--   locations.type/counterparty_id/is_active                — уже есть
--   operations.operation_type = 'location_change'            — уже есть в enum
--
-- Реально не хватает только:
--   1) значения 'courier' в enum counterparty_type
--   2) значения 'staff' в enum location_type
--   3) колонки locations.user_id — для "у владельца" / "у Алины" (сотрудники
--      бота, не counterparty), по аналогии с locations.counterparty_id
--
-- ВАЖНО: ALTER TYPE ... ADD VALUE должен закоммититься до того, как новое
-- значение используется в других командах. Выполните ШАГ 1 отдельным
-- запуском (Run), затем ШАГ 2 — тоже отдельным запуском.
-- ============================================================

-- ШАГ 1 — выполнить и запустить отдельно -----------------------
alter type counterparty_type add value if not exists 'courier';
alter type location_type     add value if not exists 'staff';


-- ШАГ 2 — выполнить вторым запуском после того, как ШАГ 1 закоммитился ---
alter table locations
    add column if not exists user_id uuid references users(id);
