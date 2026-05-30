drop table if exists articles_full;

create table articles_full (
  n int not null,
  id int primary key,
  title varchar not null,
  publication varchar not null,
  author varchar,
  date date not null,
  year varchar not null,
  month varchar not null,
  url varchar,
  content text not null
);

\copy articles_full from 'large_news.csv' delimiter ',' csv header;

drop table if exists articles;

create table articles as select * from articles_full;

alter table articles
add column full_text tsvector generated always as (to_tsvector ('english', title || ' ' || content)) stored;

alter table articles
add column full_text_gin tsvector generated always as (to_tsvector ('english', title || ' ' || content)) stored;

create index idx_full_text_gin on articles using gin (full_text_gin);

explain analyze
select title, content
from articles
where full_text @@ to_tsquery('english', 'Justice | House');

explain analyze
select title, content
from articles
where full_text_gin @@ to_tsquery('english', 'Justice | House');

explain analyze
with q as ( select to_tsquery('english', 'Justice | House') as query)
select title, content, ts_rank(full_text, q.query) as "rank"
from articles
cross join q
where full_text @@ q.query
order by "rank" desc
limit 10000;

explain analyze
with q as ( select to_tsquery('english', 'Justice | House') as query)
select title, content, ts_rank(full_text_gin, q.query) as "rank"
from articles
cross join q
where full_text_gin @@ q.query
order by "rank" desc
limit 10000;
