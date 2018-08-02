-- 

DROP FUNCTION IF EXISTS gpExecSql_repl (TBlob, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpExecSql_repl (
    IN inSqlText         TBlob,         -- ����� SQL
    IN gConnectHost      TVarChar,      -- �����������, ��� � � exe - ������������ ������ ������
    IN inSession         TVarChar       -- ������ ������������
) 
RETURNS VOID
AS $BODY$
BEGIN
      PERFORM lfExecSql (inSqlText:= inSqlText);
END; $BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.07.18                                        *
*/

-- ����
-- SELECT * FROM gpExecSql_repl ('select 1', '', zfCalc_UserAdmin())
