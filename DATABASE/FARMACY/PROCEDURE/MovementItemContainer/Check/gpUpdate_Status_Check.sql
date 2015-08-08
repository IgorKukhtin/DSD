-- Function: gpUpdate_Status_Check()

DROP FUNCTION IF EXISTS gpUpdate_Status_Check (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Check(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
    DECLARE vbPaidType Integer;
    DECLARE vbCashRegisterId Integer;
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_Check (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            BEGIN
                SELECT       
                    CASE 
                      WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                        THEN 0
                      WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Card()
                        THEN 1
                    END as PaidType 
                  , Movement_Check.CashRegisterId
                INTO
                    vbPaidType,vbCashRegisterId                
                FROM Movement_Check_View AS Movement_Check 
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                             ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                            AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
                WHERE Movement_Check.Id =  inMovementId;
                PERFORM gpComplete_Movement_CheckAdmin (inMovementId, vbPaidType, vbCashRegisterId, inSession);
            END;   
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_Check (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.07.14                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_Income (ioId:= 0, inSession:= zfCalc_UserAdmin())