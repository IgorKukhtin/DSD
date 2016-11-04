-- Function: gpComplete_Movement_IncomeAdmin()

DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Check(
    IN inMovementId        Integer              , -- ���� ���������
   OUT outStatusCode       Integer              ,
   OUT outMessageText      Text                 ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbPaidType Integer;
  DECLARE vbCashRegisterId  Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
      
    -- ����������
    SELECT CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                    THEN 0
                WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Card()
                    THEN 1
           END as PaidType 
         , Movement_Check.CashRegisterId

           INTO vbPaidType, vbCashRegisterId
    FROM Movement_Check_View AS Movement_Check 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                      ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                     AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
    WHERE Movement_Check.Id = inMovementId;

    -- ����������� ��������
    outMessageText:= gpComplete_Movement_CheckAdmin (inMovementId, vbPaidType, vbCashRegisterId, inSession);

    outStatusCode := (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 30.10.16         *
*/

-- ����
