-- Function: gpUpdate_Status_SaleExternal()

DROP FUNCTION IF EXISTS gpUpdate_Status_SaleExternal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_SaleExternal(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            --
            PERFORM gpUnComplete_Movement_SaleExternal (inMovementId, inSession);

         WHEN zc_Enum_StatusCode_Complete() THEN
            --
            PERFORM gpComplete_Movement_SaleExternal (inMovementId, inSession);

         WHEN zc_Enum_StatusCode_Erased() THEN

            --
            PERFORM gpSetErased_Movement_SaleExternal (inMovementId, inSession);

         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.20         *

*/

-- ����
-- SELECT * FROM gpUpdate_Status_SaleExternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
