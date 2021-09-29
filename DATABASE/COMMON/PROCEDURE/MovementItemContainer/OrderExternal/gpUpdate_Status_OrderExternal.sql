-- Function: gpUpdate_Status_OrderExternal()

DROP FUNCTION IF EXISTS gpUpdate_Status_OrderExternal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_OrderExternal(
    IN inMovementId          Integer   , -- ���� ������� <��������>
 INOUT ioStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
   OUT outStatusName         TVarChar  ,
   OUT outPrinted            Boolean   ,
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN
     --
     outPrinted := FALSE;
     --
     CASE ioStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_OrderExternal (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            SELECT tmp.outMessageText INTO outMessageText FROM gpComplete_Movement_OrderExternal (inMovementId, inSession) AS tmp;
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_OrderExternal (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', ioStatusCode;
     END CASE;
     
     -- ������� - ����� ������
     SELECT Object.ObjectCode, Object.ValueData INTO ioStatusCode, outStatusName
     FROM Movement JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_OrderExternal (ioId:= 0, inSession:= zfCalc_UserAdmin())
