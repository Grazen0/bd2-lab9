begin transaction;

alter table film
drop column if exists full_text;

alter table film
drop column if exists full_text_idx;

alter table film
add column full_text tsvector generated always as (
  to_tsvector ('english', title || ' ' || description)
) stored;

alter table film
add column full_text_idx tsvector generated always as (
  to_tsvector ('english', title || ' ' || description)
) stored;

-- insert into film ( title, description, release_year, language_id, rental_duration, rental_rate, "length", replacement_cost, rating, last_update, special_features, fulltext) select title, description, release_year, language_id, rental_duration, rental_rate, "length", replacement_cost, rating, last_update, special_features, fulltext from film cross join generate_series(1, 10000 - 1) as gs;

create index idx_full_text_gin on film using gin (full_text_idx);

explain analyze
select title, description from film where full_text @@ to_tsquery('english', 'Man & Woman');
explain analyze
select title, description from film where full_text_idx @@ to_tsquery('english', 'Man & Woman');

rollback;
