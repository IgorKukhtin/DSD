-- Function: gpUpdate_Status_Invoice()

DROP FUNCTION IF EXISTS gpUpdate_Status_Invoice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Invoice(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            -- �������� ���� ������������ �� ����� ���������
            PERFORM lpCheckRight (inSession, zc_Enum_Process_UnComplete_Invoice());
            --
            PERFORM gpUnComplete_Movement (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            -- �������� ���� ������������ �� ����� ���������
            PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice());
            --
            PERFORM gpComplete_Movement_Invoice (inMovementId, FALSE, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            -- �������� ���� ������������ �� ����� ���������
            PERFORM lpCheckRight (inSession, zc_Enum_Process_SetErased_Invoice());
            --
            PERFORM gpSetErased_Movement (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.16         *

*/

-- ����
-- SELECT * FROM gpUpdate_Status_Invoice (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
