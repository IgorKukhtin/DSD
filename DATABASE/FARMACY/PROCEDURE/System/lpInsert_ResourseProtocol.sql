-- Function: lpInsert_ResourseProtocol()

DROP FUNCTION IF EXISTS lpInsert_ResourseProtocol (TDateTime, INTERVAL, INTERVAL, INTERVAL, TVarChar, TBlob, Integer);

CREATE OR REPLACE FUNCTION lpInsert_ResourseProtocol (
    IN inOperDate              TDateTime, -- во сколько началась выполняться
    IN inTime2                 INTERVAL,  -- сколько выполнялась до точки1
    IN inTime3                 INTERVAL,  -- сколько выполнялась до точки2
    IN inTime4                 INTERVAL,  -- сколько выполнялась до точки3
    IN inProcName              TVarChar,  -- какую проц. тестим
    IN inProtocolData          TBlob,     -- параметры проц.
    IN inUserId                Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbParentId Integer;
BEGIN

    CREATE TEMP TABLE _tmp_pg_stat_activity ON COMMIT DROP AS SELECT * FROM pg_stat_activity;

    -- Master
    INSERT INTO ResourseProtocol (UserId, OperDate
                                , Value1, Value2, Value3, Value4, Value5
                                , Time1, Time2, Time3, Time4, Time5
                                , ProcName, ProtocolData
                                 )
        VALUES (inUserId
                -- во сколько началась выполняться
              , inOperDate
                -- Value1 - сколько всего активных процессов
              , (SELECT COUNT (*) FROM _tmp_pg_stat_activity WHERE state = 'active')
                -- Value2 - сколько всего процессов
              , (SELECT COUNT (*) FROM _tmp_pg_stat_activity)
                -- Value3 - сколько процессов группы1 - без сайта
              , (SELECT COUNT (*) FROM _tmp_pg_stat_activity WHERE state = 'active' AND client_addr <> '172.17.2.6')
                -- Value4 - сколько процессов группы2 - сайт
              , (SELECT COUNT (*) FROM _tmp_pg_stat_activity WHERE state = 'active' AND client_addr  = '172.17.2.6')
                -- сколько процессов группы3
              , NULL
                -- сколько всего выполнялась проц
              , (CLOCK_TIMESTAMP() - inOperDate) :: INTERVAL
                -- сколько выполнялась до точки1
              , inTime2
                -- сколько выполнялась до точки2
              , inTime3
                -- сколько выполнялась до точки3
              , inTime4
                -- во сколько закончилась
              , CLOCK_TIMESTAMP()
                -- какую проц. тестим
              , inProcName
                -- параметры проц.
              , inProtocolData
               )
        RETURNING Id INTO vbParentId;


    -- Item
    INSERT INTO ResourseItemProtocol (ParentId
                                    , pid
                                    , query_start
                                    , datname
                                    , usename
                                    , client_addr
                                    , state
                                    , wait_event_type
                                    , wait_event
                                    , query
                                     )
       SELECT vbParentId
            , tmp.pid
            , tmp.query_start
            , tmp.datname
            , tmp.usename
            , tmp.client_addr
            , tmp.state
            , tmp.wait_event_type
            , tmp.wait_event
            , tmp.query
       FROM _tmp_pg_stat_activity AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-- тест
-- SELECT * FROM lpInsert_ResourseProtocol (CLOCK_TIMESTAMP(), NULL, NULL, NULL, 'ProcName', 'ProtocolData', 3)
-- SELECT * FROM ResourseItemProtocol WHERE ParentId IN (SELECT MAX(Id) FROM ResourseProtocol) AND state = 'active' ORDER BY query_start DESC
-- SELECT * FROM ResourseProtocol where OperDate > CURRENT_DATE ORDER BY Time1 DESC LIMIT 1000 -- SELECT * FROM ResourseProtocol where ProcName ilike '%gpSelect_Movement%' AND OperDate >= CURRENT_DATE ORDER BY Time1 DESC LIMIT 400
