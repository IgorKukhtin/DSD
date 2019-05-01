-- 

DROP FUNCTION IF EXISTS gpExecSql (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpExecSql (TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpExecSql (
    IN inSqlText TBlob    , -- ����� SQL
    IN inSession TVarChar   -- ������ ������������
) 
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN

      -- ����� ��������� ����� ������ ���������� ����.
      vbOperDate_Begin1:= CLOCK_TIMESTAMP();


      -- ����������
      PERFORM lfExecSql (inSqlText:= inSqlText);


     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT inSession :: Integer
               -- �� ������� ��������
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- ������� ����� ����������� ����
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- ������� ����� ����������� ���� �� lpSelectMinPrice_List
             , NULL AS Time2
               -- ������� ����� ����������� ���� lpSelectMinPrice_List
             , NULL AS Time3
               -- ������� ����� ����������� ���� ����� lpSelectMinPrice_List
             , NULL AS Time4
               -- �� ������� �����������
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpExecSql'
               -- ProtocolData
             , inSqlText
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 13.07.17                                                       *
*/

/*
  DO $$
  BEGIN
        PERFORM gpExecSql(inSqlText:= 'DO $BODY$ BEGIN '
    '  PERFORM lfGetParams(inStoredProcName:=' || quote_literal('lfGetParams') || ', inSession:= zfCalc_UserAdmin()); '
    '  PERFORM lfGetParams(inStoredProcName:=' || quote_literal('gpGetMobile_Object_Const') || ', inSession:= zfCalc_UserAdmin()); '
    'END; $BODY$', inSession:= zfCalc_UserAdmin());
  END; $$;
*/
-- ����
-- SELECT * FROM gpExecSql (inSqlText:= 'TRUNCATE TABLE ResourseProtocol', inSession:= zfCalc_UserAdmin())
-- SELECT * FROM ResourseProtocol WHERE OperDate >= CURRENT_DATE - INTERVAL '0 DAY' ORDER BY 3 DESC
