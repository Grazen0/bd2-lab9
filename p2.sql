alter table film drop column if exists full_text;
alter table film drop column if exists full_text_idx;

alter table film add column full_text text
    generated always as (title || ' ' || description) stored;

alter table film add column full_text_idx tsvector
    generated always as (to_tsvector('english', title || ' ' || description)) stored;

create index full_text_gin on film using gin (full_text_idx);
