    -- 0.0. 
    -- update ObjectHistory set StartDate = StartDate + Interval '1 HOUR', EndDate = EndDate + '1 HOUR';

    -- 0.1. - ObjectDate +++
    select * from ObjectDate 
    WHERE ObjectDate.ValueData + Interval '1 HOUR' = date_trunc('day', ObjectDate.ValueData + Interval '1 HOUR');
    -- 0.2.
    UPDATE ObjectDate set ValueData = ValueData + Interval '1 HOUR'
    WHERE ObjectDate.ValueData + Interval '1 HOUR' = date_trunc('day', ObjectDate.ValueData + Interval '1 HOUR');

    -- 1.1. Movement +++
    select DISTINCT MovementDesc.*
    -- SELECT OperDate, OperDate + Interval '1 HOUR'
    FROM Movement, MovementDesc
    WHERE Movement.OperDate >= '31.12.2016 23:00'
      and Movement.DescId = MovementDesc.Id
      -- and DescId in (zc_Movement_Income(), zc_Movement_OrderInternal(), zc_Movement_OrderExternal())
      and OperDate + Interval '1 HOUR' = date_trunc('day', OperDate + Interval '1 HOUR')
    -- order by OperDate
    -- 1.2.
    UPDATE Movement set  OperDate = OperDate + Interval '1 HOUR'
    -- WHERE Movement.OperDate >= '31.12.2016 23:00'
    WHERE Movement.OperDate between '01.01.2016' and '31.12.2016 23:00'
      -- and DescId in (zc_Movement_Income(), zc_Movement_OrderInternal(), zc_Movement_OrderExternal())
      AND OperDate + Interval '1 HOUR' = date_trunc('day', OperDate + Interval '1 HOUR')


    -- 2.1. - MovementDate +++
    select DISTINCT MovementDateDesc.*
    -- select *
    FROM Movement, MovementDate join MovementDateDesc on MovementDateDesc.Id = MovementDate.DescId
    WHERE Movement.Id = MovementDate.MovementId
      and Movement.OperDate >= '31.12.2016 23:00'
      -- and Movement.DescId in (zc_Movement_Income(), zc_Movement_OrderInternal(), zc_Movement_OrderExternal())
      and MovementDate.ValueData + Interval '1 HOUR' = date_trunc('day', MovementDate.ValueData + Interval '1 HOUR');
    -- 2.2.
    UPDATE MovementDate set ValueData = ValueData + Interval '1 HOUR'
    WHERE MovementDate.ValueData >= '31.12.2016 23:00'
    -- WHERE MovementDate.ValueData between '01.01.2016' and '31.12.2016 23:00'
      and MovementDate.ValueData + Interval '1 HOUR' = date_trunc('day', MovementDate.ValueData + Interval '1 HOUR');

    -- 3. - MovementItemContainer +++
    UPDATE MovementItemContainer set  OperDate = OperDate + Interval '1 HOUR'
    -- WHERE OperDate >= '31.12.2016 23:00'
    WHERE OperDate between '01.01.2016' and '31.12.2016 23:00'
      -- and MovementDescId = zc_Movement_Income()
      AND OperDate + Interval '1 HOUR' = date_trunc('day', OperDate + Interval '1 HOUR')


    -- 4.1. - MovementItemDate +++
    select DISTINCT MovementItemDateDesc.*
    -- select ValueData , ValueData + Interval '1 HOUR', MovementItemDateDesc.*
    FROM MovementItemDate, MovementItemDateDesc
    WHERE MovementItemDate.ValueData >= '31.12.2016 23:00'
      and MovementItemDateDesc.Id = MovementItemDate.DescId
      AND ValueData + Interval '1 HOUR' = date_trunc('day', ValueData + Interval '1 HOUR')
    -- order by ValueData;
    -- 4.2.
    update MovementItemDate set ValueData = ValueData + Interval '1 HOUR'
    WHERE MovementItemDate.ValueData >= '31.12.2016 23:00'
      AND ValueData + Interval '1 HOUR' = date_trunc('day', ValueData + Interval '1 HOUR')

