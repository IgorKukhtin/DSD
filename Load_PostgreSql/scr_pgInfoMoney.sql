update dba._pgInfoMoney set ObjectCode=ObjectCode+100 where ObjectCode >= 80401;

insert into dba._pgInfoMoney (ObjectCode, Name1, Name2, Name3) 
select '80401', 'Собственный капиталл', 'прибыль текущего периода', 'прибыль текущего периода';

commit;
