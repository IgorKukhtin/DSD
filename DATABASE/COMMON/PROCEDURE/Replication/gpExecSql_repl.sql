-- 

DROP FUNCTION IF EXISTS gpExecSql_repl (TBlob, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpExecSql_repl (
    IN inSqlText         TBlob,         -- текст SQL
    IN gConnectHost      TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession         TVarChar       -- сессия пользователя
) 
RETURNS VOID
AS $BODY$
BEGIN
      PERFORM lfExecSql (inSqlText:= inSqlText);
END; $BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.18                                        *
*/

-- тест
-- SELECT * FROM gpExecSql_repl ('select 1', '', zfCalc_UserAdmin())
