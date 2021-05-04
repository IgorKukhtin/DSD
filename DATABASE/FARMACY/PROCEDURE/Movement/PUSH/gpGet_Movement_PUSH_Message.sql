-- Function: gpInsertUpdate_Movement_PUSH()

--DROP FUNCTION IF EXISTS gpGet_Movement_PUSH_Message (TBlob, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS gpGet_Movement_PUSH_Message (TBlob, TVarChar, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION gpGet_Movement_PUSH_Message(
    IN inMessage               TBlob      , -- Сообщение
    IN inFunction              TVarChar   , -- Функция
    IN inForm                  TVarChar   , -- Форма
    IN inUnitID                Integer    , -- Подразделение
    IN inUserId                Integer      -- Сотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar
             , isFormOpen boolean)
AS
$BODY$
   DECLARE text_var1   Text;
   DECLARE vbQueryText Text;
   DECLARE vbRec Record;
BEGIN

  if COALESCE(inFunction, '') <> '' AND  COALESCE(inForm, '') <> ''
  THEN
    BEGIN
       FOR vbRec IN EXECUTE 'SELECT Count(*) AS CountRecord FROM '||inFunction||'('''||inUserId::TVarChar||''')'
       LOOP
         IF vbRec.CountRecord > 0
         THEN
            RETURN QUERY
            SELECT ''::TBlob,
                   inForm,
                   ''::TVarChar,
                   ''::TVarChar,
                   ''::TVarChar,
                   ''::TVarChar,
                   True;
         END IF;
       END LOOP;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpGet_Movement_PUSH_Message  run '::inFunction, True, text_var1::TVarChar, inUserId);
    END;
  ELSEif COALESCE(inFunction, '') <> ''
  THEN
    BEGIN
       FOR vbRec IN EXECUTE 'SELECT * FROM '||inFunction||'('||inUnitID::TVarChar||', '||inUserId::TVarChar||')'
       LOOP
         RETURN QUERY
         SELECT vbRec.Message, vbRec.FormName, vbRec.Button, vbRec.Params, vbRec.TypeParams, vbRec.ValueParams, False AS isFormOpen;
       END LOOP;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpGet_Movement_PUSH_Message run '::inFunction, True, text_var1::TVarChar, inUserId);
    END;

  ELSE
    RETURN QUERY
    SELECT  inMessage,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           False;
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
-- SELECT * FROM gpGet_Movement_PUSH_Message( 'dddd'::TBlob, 'gpSelect_MovementItem_OrderInternal_WillNotOrder', 'TReport_WillNotOrderForm', 183292 , 3);