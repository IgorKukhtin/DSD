DROP FUNCTION IF EXISTS lfExecSql (TVarChar);
DROP FUNCTION IF EXISTS lfExecSql (TBlob);

CREATE OR REPLACE FUNCTION lfExecSql (
    IN inSqlText TBlob     -- ����� SQL
) 
RETURNS void
AS $BODY$
BEGIN
      EXECUTE inSqlText;
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
        PERFORM lfExecSql(inSqlText:= 'DO $BODY$ BEGIN '
    '  PERFORM lfGetParams(inStoredProcName:=' || quote_literal('lfGetParams') || ', inSession:= ' || quote_literal('5') || '); '
    '  PERFORM lfGetParams(inStoredProcName:=' || quote_literal('gpGetMobile_Object_Const') || ', inSession:= ' || quote_literal('5') || '); '
    'END; $BODY$');
  END; $$;
*/