-- 

DROP FUNCTION IF EXISTS gpExecSql (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpExecSql (TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpExecSql (
    IN inSqlText TBlob    , -- ����� SQL
    IN inSession TVarChar   -- ������ ������������
) 
RETURNS void
AS $BODY$
BEGIN
      PERFORM lfExecSql (inSqlText:= inSqlText);
END; $BODY$
  LANGUAGE plpgsql;

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
