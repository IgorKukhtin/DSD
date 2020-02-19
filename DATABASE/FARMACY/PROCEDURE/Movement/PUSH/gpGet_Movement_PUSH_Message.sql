-- Function: gpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS gpGet_Movement_PUSH_Message (TBlob, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION gpGet_Movement_PUSH_Message(
    IN inMessage               TBlob      , -- ���������
    IN inFunction              TVarChar   , -- �������
    IN inUnitID                Integer    , -- �������������
    IN inUserId                Integer      -- ���������
)
RETURNS TBlob AS
$BODY$
   DECLARE text_var1   Text;
   DECLARE vbQueryText Text;
   DECLARE vbRec Record;
BEGIN

  if COALESCE(inFunction, '') <> ''
  THEN
    BEGIN
       FOR vbRec IN EXECUTE 'select '||inFunction||'('||inUnitID::TVarChar||', '||inUserId::TVarChar||') AS Message'
       LOOP
           Return vbRec.Message;
       END LOOP;
       Return vbQueryText;
    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
       PERFORM lpLog_Run_Schedule_Function('gpGet_Movement_PUSH_Message', True, text_var1::TVarChar, inUserId);
       Return '';
    END;

  ELSE
    Return inMessage;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 19.02.20         *
*/

-- SELECT * FROM gpGet_Movement_PUSH_Message( 'dddd', 'gpSelect_MovementItem_PUSH_WagesSUN1', 183292 , 3);