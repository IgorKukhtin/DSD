-- Function: gpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS gpGet_Movement_PUSH_Message (TBlob, TVarChar, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpGet_Movement_PUSH_Message(
    IN inMessage               TBlob      , -- Сообщение
    IN inFunction              TVarChar   , -- Функция
    IN inForm                  TVarChar   , -- Форма
    IN inMovementID            Integer    , -- Movement PUSH
    IN inUnitID                Integer    , -- Подразделение
    IN inUserId                Integer      -- Сотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar
             , isFormOpen boolean
             , isFormLoad boolean)
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
                   True,
                   EXISTS(SELECT Object.Id FROM Object WHERE Object.ValueData = inForm AND Object.DescId = zc_Object_Form());
         END IF;
       END LOOP;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpGet_Movement_PUSH_Message', True, text_var1::TVarChar, inUserId);
    END;
  ELSEif COALESCE(inFunction, '') <> ''
  THEN
    BEGIN
       FOR vbRec IN EXECUTE 'SELECT * FROM '||inFunction||'('||COALESCE(inMovementID, 0)::TVarChar||', '||inUnitID::TVarChar||', '||inUserId::TVarChar||')'
       LOOP
         RETURN QUERY
         SELECT vbRec.Message, vbRec.FormName, vbRec.Button, vbRec.Params, vbRec.TypeParams, vbRec.ValueParams, 
                COALESCE(vbRec.Message, '') = '' AND COALESCE(vbRec.FormName, '') <> '' AS isFormOpen,
                EXISTS(SELECT Object.Id FROM Object WHERE Object.ValueData = vbRec.FormName AND Object.DescId = zc_Object_Form());
       END LOOP;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpGet_Movement_PUSH_Message', True, text_var1::TVarChar, inUserId);
    END;

  ELSE
    RETURN QUERY
    SELECT inMessage,
           inForm::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           ''::TVarChar,
           COALESCE(inMessage, '') = '' AND COALESCE(inForm, '') <> '' AS isFormOpen,
           EXISTS(SELECT Object.Id FROM Object WHERE Object.ValueData = inForm AND Object.DescId = zc_Object_Form());
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
-- 
SELECT * FROM gpGet_Movement_PUSH_Message( '', '', 'TCheckHelsiSignPUSHForm', 18971753 , 183292 , 3);