-- Function: lpInsert_ResourseProtocol()

DROP FUNCTION IF EXISTS lpInsert_ResourseProtocol (TDateTime, INTERVAL, INTERVAL, INTERVAL, TVarChar, TBlob, Integer);

CREATE OR REPLACE FUNCTION lpInsert_ResourseProtocol (
    IN inOperDate              TDateTime, -- �� ������� �������� �����������
    IN inTime2                 INTERVAL,  -- ������� ����������� �� �����1
    IN inTime3                 INTERVAL,  -- ������� ����������� �� �����2
    IN inTime4                 INTERVAL,  -- ������� ����������� �� �����3
    IN inProcName              TVarChar,  -- ����� ����. ������
    IN inProtocolData          TBlob,     -- ��������� ����.
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
                -- �� ������� �������� �����������
              , inOperDate
                -- Value1 - ������� ����� �������� ���������
              , (SELECT COUNT (*) FROM _tmp_pg_stat_activity WHERE state = 'active')
                -- Value2 - ������� ����� ���������
              , (SELECT COUNT (*) FROM _tmp_pg_stat_activity)
                -- Value3 - ������� ��������� ������1 - ��� �����
              , (SELECT COUNT (*) FROM _tmp_pg_stat_activity WHERE state = 'active' AND client_addr <> '172.17.2.6')
                -- Value4 - ������� ��������� ������2 - ����
              , (SELECT COUNT (*) FROM _tmp_pg_stat_activity WHERE state = 'active' AND client_addr  = '172.17.2.6')
                -- ������� ��������� ������3
              , NULL
                -- ������� ����� ����������� ����
              , (CLOCK_TIMESTAMP() - inOperDate) :: INTERVAL
                -- ������� ����������� �� �����1
              , inTime2
                -- ������� ����������� �� �����2
              , inTime3
                -- ������� ����������� �� �����3
              , inTime4
                -- �� ������� �����������
              , CLOCK_TIMESTAMP()
                -- ����� ����. ������
              , inProcName
                -- ��������� ����.
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

-- ����
-- SELECT * FROM lpInsert_ResourseProtocol (CLOCK_TIMESTAMP(), NULL, NULL, NULL, 'ProcName', 'ProtocolData', 3)
-- SELECT * FROM ResourseItemProtocol WHERE ParentId IN (SELECT MAX(Id) FROM ResourseProtocol) AND state = 'active' ORDER BY query_start DESC
-- SELECT * FROM ResourseProtocol where OperDate > CURRENT_DATE ORDER BY Time1 DESC LIMIT 1000 -- SELECT * FROM ResourseProtocol where ProcName ilike '%gpSelect_Movement%' AND OperDate >= CURRENT_DATE ORDER BY Time1 DESC LIMIT 400
