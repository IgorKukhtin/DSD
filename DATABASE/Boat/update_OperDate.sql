update Movement set OperDate =  DATE_TRUNC ('day', OperDate)  + INTERVAL '1 DAY'
 where OperDate <> DATE_TRUNC ('day', OperDate)
and EXTRACT (timezone_hour from OperDate)= 1;

update Object_PartionGoods set OperDate =  DATE_TRUNC ('day', OperDate)   + INTERVAL '1 DAY'
 where OperDate <> DATE_TRUNC ('day', OperDate)
and EXTRACT (timezone_hour from OperDate)= 1;


update MovementItemContainer set OperDate =  DATE_TRUNC ('day', OperDate)   + INTERVAL '1 DAY'
 where OperDate <> DATE_TRUNC ('day', OperDate)
and EXTRACT (timezone_hour from OperDate)= 1;


update ObjectHistory set StartDate =  DATE_TRUNC ('day', StartDate)   + INTERVAL '1 DAY'
 where StartDate <> DATE_TRUNC ('day', StartDate)
and EXTRACT (timezone_hour from StartDate)= 1;
update ObjectHistory set EndDate =  DATE_TRUNC ('day', EndDate)   + INTERVAL '1 DAY'
 where EndDate <> DATE_TRUNC ('day', EndDate)
and EXTRACT (timezone_hour from EndDate)= 1;


update MovementItemProtocol set OperDate =  DATE_TRUNC ('day', OperDate)   + INTERVAL '1 DAY'
 where OperDate <> DATE_TRUNC ('day', OperDate)
and EXTRACT (timezone_hour from OperDate)= 1;

update MovementProtocol set OperDate =  DATE_TRUNC ('day', OperDate)   + INTERVAL '1 DAY'
 where OperDate <> DATE_TRUNC ('day', OperDate)
and EXTRACT (timezone_hour from OperDate)= 1;



update MovementDate set ValueData =  DATE_TRUNC ('day', ValueData)   + INTERVAL '1 DAY'
 where ValueData <> DATE_TRUNC ('day', ValueData)
and EXTRACT (timezone_hour from ValueData)= 1;


update MovementItemDate set ValueData =  DATE_TRUNC ('day', ValueData)   + INTERVAL '1 DAY'
 where ValueData <> DATE_TRUNC ('day', ValueData)
and EXTRACT (timezone_hour from ValueData)= 1;


update ObjectDate set ValueData =  DATE_TRUNC ('day', ValueData)   + INTERVAL '1 DAY'
 where ValueData <> DATE_TRUNC ('day', ValueData)
and EXTRACT (timezone_hour from ValueData)= 1;

update ObjectHistoryDate set ValueData =  DATE_TRUNC ('day', ValueData)   + INTERVAL '1 DAY'
 where ValueData <> DATE_TRUNC ('day', ValueData)
and EXTRACT (timezone_hour from ValueData)= 1;



update LoginProtocol set OperDate =  DATE_TRUNC ('day', OperDate)   + INTERVAL '1 DAY'
 where OperDate <> DATE_TRUNC ('day', OperDate)
and EXTRACT (timezone_hour from OperDate)= 1;


update ObjectProtocol set OperDate =  DATE_TRUNC ('day', OperDate)   + INTERVAL '1 DAY'
 where OperDate <> DATE_TRUNC ('day', OperDate)
and EXTRACT (timezone_hour from OperDate)= 1;

update UserProtocol set OperDate =  DATE_TRUNC ('day', OperDate)   + INTERVAL '1 DAY'
 where OperDate <> DATE_TRUNC ('day', OperDate)
and EXTRACT (timezone_hour from OperDate)= 1;
