set role hbench;
set search_path=:schema_name,public;
:EXPLAIN_ANALYZE
--begin q06
-- $ID$
-- TPC-H/TPC-R Forecasting Revenue Change Query (Q6)
-- Functional Query Definition
-- Approved February 1998


select
	sum(l_extendedprice * l_discount) as revenue
from
	lineitem
where
	l_shipdate >= date '1997-01-01'
	and l_shipdate < date '1997-01-01' + interval '1' year
	and l_discount between 0.09 - 0.01 and 0.09 + 0.01
	and l_quantity < 25;
--end q06
