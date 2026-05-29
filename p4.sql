begin transaction;

drop table if exists articles;

create table articles (
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

\copy articles from 'large_news.csv' delimiter ',' csv header;

alter table articles
add column full_text_gin tsvector generated always as (to_tsvector ('english', title || ' ' || content)) stored;

alter table articles
add column full_text_gist tsvector generated always as (to_tsvector ('english', title || ' ' || content)) stored;

create index idx_full_text_gin on articles using gin (full_text_gin);

create index idx_full_text_gist on articles using gist (full_text_gist);

explain analyze
select
  title, content
from
  articles
where
  full_text_gin @@ to_tsquery('english', 'Man & Woman');

explain analyze
select
  title, content
from
  articles
where
  full_text_gist @@ to_tsquery('english', 'Man & Woman');

explain analyze
with q as (
  select to_tsquery('english', 'Man & Woman') as query
)
select
  title, content, ts_rank(full_text_gin, q.query) as "rank"
from
  articles
cross join
  q
where
  full_text_gin @@ q.query
order by
  "rank" desc
limit
  10;

explain analyze
with q as (
  select to_tsquery('english', 'Man & Woman') as query
)
select
  title, content, ts_rank(full_text_gist, q.query) as "rank"
from
  articles
cross join
  q
where
  full_text_gist @@ q.query
order by
  "rank" desc
limit
  10;

rollback;
