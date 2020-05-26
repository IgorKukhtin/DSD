-- Function: gpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS gpGet_Movement_PUSH_Message (TBlob, TVarChar, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpGet_Movement_PUSH_Message(
    IN inMessage               TBlob      , -- ���������
    IN inFunction              TVarChar   , -- �������
    IN inForm                  TVarChar   , -- �����
    IN inMovementID            Integer    , -- Movement PUSH
    IN inUnitID                Integer    , -- �������������
    IN inUserId                Integer      -- ���������
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
       PERFORM lpLog_Run_Schedule_Function('gpGet_Movement_PUSH_Message', True, text_var1::TVarChar, inUserId);
    END;
  ELSEif COALESCE(inFunction, '') <> ''
  THEN
    BEGIN
       FOR vbRec IN EXECUTE 'SELECT * FROM '||inFunction||'('||COALESCE(inMovementID, 0)::TVarChar||', '||inUnitID::TVarChar||', '||inUserId::TVarChar||')'
       LOOP
         RETURN QUERY
         SELECT vbRec.Message, vbRec.FormName, vbRec.Button, vbRec.Params, vbRec.TypeParams, vbRec.ValueParams, False AS isFormOpen;
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
           ''::TVarChar,
           False;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 19.02.20         *
*/

-- SELECT * FROM Log_Run_Schedule_Function
-- SELECT * FROM gpGet_Movement_PUSH_Message( '', 'gpSelect_SendVIP_PUSH_Cash', '', 18971753 , 183292 , 3);
