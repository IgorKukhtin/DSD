-- Function: gpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS gpGet_Movement_PUSH_Message (TBlob, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION gpGet_Movement_PUSH_Message(
    IN inMessage               TBlob      , -- Сообщение
    IN inFunction              TVarChar   , -- Функция
    IN inUnitID                Integer    , -- Подразделение
    IN inUserId                Integer      -- Сотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar)
AS
$BODY$
   DECLARE text_var1   Text;
   DECLARE vbQueryText Text;
   DECLARE vbRec Record;
BEGIN

  if COALESCE(inFunction, '') <> ''
  THEN
    BEGIN
       FOR vbRec IN EXECUTE 'SELECT * FROM '||inFunction||'('||inUnitID::TVarChar||', '||inUserId::TVarChar||')'
       LOOP
         RETURN QUERY
         SELECT vbRec.Message, vbRec.FormName, vbRec.Button, vbRec.Params, vbRec.TypeParams, vbRec.ValueParams;
       END LOOP;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpGet_Movement_PUSH_Message', True, text_var1::TVarChar, inUserId);
    END;

  ELSE
    RETURN QUERY
    SELECT  inMessage,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 19.02.20         *
*/

-- SELECT * FROM Log_Run_Schedule_Function
-- SELECT * FROM gpGet_Movement_PUSH_Message( 'dddd', 'gpSelect_TechnicalRediscount_PUSH', 183292 , 3);
