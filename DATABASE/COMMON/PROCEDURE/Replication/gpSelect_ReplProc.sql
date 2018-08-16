-- возвращает скрипт ПРОЦ.

DROP FUNCTION IF EXISTS gpSelect_ReplProc (Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ReplProc (BigInt, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplProc(
    IN inOID_last   BigInt  ,      --
    IN inOneProc    TVarChar,      --
    IN gConnectHost TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession    TVarChar       -- сессия пользователя
)
RETURNS TABLE (oid BigInt , ProName TVarChar)
AS
$BODY$
   DECLARE vbOID     BigInt;
   DECLARE vbProName TVarChar;
BEGIN


     vbOID:= zfConvert_StringToFloat (inOneProc) :: BigInt;
     IF vbOID > 0 THEN vbProName:= ''; ELSE vbProName:= LOWER (TRIM (inOneProc)); END IF;

     
     -- Результат
     RETURN QUERY
       SELECT p.oid     :: BigInt   AS oid
            , p.ProName :: TVarChar AS ProName
       FROM pg_proc AS p
            JOIN pg_namespace AS n ON n.oid = p.pronamespace
       WHERE n.nspname = 'public'
         AND p.oid > inOID_last
         AND (p.oid     = vbOID     OR vbOID     = 0)
         AND (p.ProName = vbProName OR vbProName = '')
         AND  probin <> '$libdir/tablefunc'
       ORDER BY p.oid DESC
      ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplProc  (inOID_last:= 0, inOneProc:= '', gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
