create extension if not exists pg_trgm;

drop table if exists articles;

create table articles (
    body text,
    body_indexed text
);

-- create an index
create index articles_search_idx on articles using gin (body_indexed gin_trgm_ops);

\echo ""
\echo "10^2 registros =============================================================="

insert into articles select md5(random()::text) from (select * from generate_series (1,100) as id) as T;
update articles set body_indexed = body;
-- non-indexed test
explain analyze select count(*) from articles where body ilike'%abcd%';
-- indexed test
explain analyze select count(*) from articles where body_indexed ilike'%abcd%';

delete from articles;

\echo ""
\echo "10^3 registros =============================================================="

insert into articles select md5(random()::text) from (select * from generate_series (1,1000) as id) as T;
update articles set body_indexed = body;
-- non-indexed test
explain analyze select count(*) from articles where body ilike'%abcd%';
-- indexed test
explain analyze select count(*) from articles where body_indexed ilike'%abcd%';

delete from articles;

\echo ""
\echo "10^4 registros =============================================================="

insert into articles select md5(random()::text) from (select * from generate_series (1,10000) as id) as T;
update articles set body_indexed = body;
-- non-indexed test
explain analyze select count(*) from articles where body ilike'%abcd%';
-- indexed test
explain analyze select count(*) from articles where body_indexed ilike'%abcd%';

delete from articles;

\echo ""
\echo "10^5 registros =============================================================="

insert into articles select md5(random()::text) from (select * from generate_series (1,100000) as id) as T;
update articles set body_indexed = body;
-- non-indexed test
explain analyze select count(*) from articles where body ilike'%abcd%';
-- indexed test
explain analyze select count(*) from articles where body_indexed ilike'%abcd%';

delete from articles;

\echo ""
\echo "10^6 registros =============================================================="

insert into articles select md5(random()::text) from (select * from generate_series (1,1000000) as id) as T;
update articles set body_indexed = body;
-- non-indexed test
explain analyze select count(*) from articles where body ilike'%abcd%';
-- indexed test
explain analyze select count(*) from articles where body_indexed ilike'%abcd%';

delete from articles;

\echo ""
\echo "10^7 registros =============================================================="

insert into articles select md5(random()::text) from (select * from generate_series (1,10000000) as id) as T;
update articles set body_indexed = body;
-- non-indexed test
explain analyze select count(*) from articles where body ilike'%abcd%';
-- indexed test
explain analyze select count(*) from articles where body_indexed ilike'%abcd%';
