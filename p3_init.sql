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
