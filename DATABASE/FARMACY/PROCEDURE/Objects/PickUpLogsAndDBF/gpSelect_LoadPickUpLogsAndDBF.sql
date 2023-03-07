-- Function: gpSelect_LoadPickUpLogsAndDBF(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_LoadPickUpLogsAndDBF(TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_LoadPickUpLogsAndDBF(
     IN inCashSessionId TVarChar,   -- Сессия кассового места
    OUT outSend         Boolean,
    OUT outHost         TVarChar,
    OUT outPort         Integer,
    OUT outUsername     TVarChar,
    OUT outPassword     TVarChar,
    OUT outFileList     TBlob,
    OUT outisGetArchive Boolean,
    OUT vbisGetArchive  Boolean,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS RECORD 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    IF EXISTS(SELECT Object_PickUpLogsAndDBF.Id
              FROM Object AS Object_PickUpLogsAndDBF
                                                       
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Loaded
                                           ON ObjectBoolean_Loaded.ObjectId = Object_PickUpLogsAndDBF.Id
                                          AND ObjectBoolean_Loaded.DescId = zc_ObjectBoolean_PickUpLogsAndDBF_Loaded()
                                       
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_GetArchive
                                           ON ObjectBoolean_GetArchive.ObjectId = Object_PickUpLogsAndDBF.Id
                                          AND ObjectBoolean_GetArchive.DescId = zc_ObjectBoolean_PickUpLogsAndDBF_GetArchive()
                                       
              WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
                AND Object_PickUpLogsAndDBF.isErased = False
                AND COALESCE (ObjectBoolean_Loaded.ValueData, False) = FALSE
                AND Object_PickUpLogsAndDBF.ValueData = inCashSessionId)
    THEN
      outSend := True;

      outHost := 'ftp.neboley.dp.ua';
      outPort := 12021;
      outUsername := 'logdbf';
      outPassword := '63CxUbbUGfYh';
      outFileList := 'FarmacyCash.log;FarmacyCash_RRO.log;FarmacyCashServise.log;default.log;FarmacyCashServise_Status.log;'||
                     'FarmacyCash_DiscontLog.xml;FarmacyCash_log.xml;'||
                     'FarmacyCashBody.dbf;FarmacyCashDiff.dbf;FarmacyCashHead.dbf;'||
                     'FarmacyCashServise_SQLite.log;FarmacyCashSQLite.db';
                     
      SELECT COALESCE(ObjectBoolean_GetArchive.ValueData, False)
      INTO outisGetArchive 
      FROM Object AS Object_PickUpLogsAndDBF
                                                         
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Loaded
                                   ON ObjectBoolean_Loaded.ObjectId = Object_PickUpLogsAndDBF.Id
                                  AND ObjectBoolean_Loaded.DescId = zc_ObjectBoolean_PickUpLogsAndDBF_Loaded()
                                         
           LEFT JOIN ObjectBoolean AS ObjectBoolean_GetArchive
                                   ON ObjectBoolean_GetArchive.ObjectId = Object_PickUpLogsAndDBF.Id
                                  AND ObjectBoolean_GetArchive.DescId = zc_ObjectBoolean_PickUpLogsAndDBF_GetArchive()
                                         
      WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
        AND Object_PickUpLogsAndDBF.isErased = False
        AND COALESCE (ObjectBoolean_Loaded.ValueData, False) = FALSE
        AND Object_PickUpLogsAndDBF.ValueData = inCashSessionId;    
        
      IF outisGetArchive IS NULL THEN outisGetArchive := False; END IF;  
      vbisGetArchive := outisGetArchive;                 

    ELSE
      outSend := False;
    END IF;
      
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.01.22                                                       *              

*/

-- тест
-- 
SELECT * FROM gpSelect_LoadPickUpLogsAndDBF('{1386D2F6-82B1-4225-AF51-838AA6827F9C}', '3')