-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_Cash_Last (Integer, Integer, TVarChar);
 
CREATE OR REPLACE FUNCTION gpGet_Movement_Cash_Last(
    IN inUnitId            Integer  , -- �����
    IN inInfoMoneyId       Integer  , -- ������
   OUT outMovementId       Integer  , -- ���� ���������  
   OUT outMI_Id            Integer  ,
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     
     
       SELECT tmp.Id, MI_Id
      INTO outMovementId, outMI_Id
       FROM (SELECT Movement.Id
                  , MovementItem.Id AS MI_Id
                  , ROW_NUMBER() OVER(ORDER BY Movement.OperDate DESC, Movement.Id Asc) AS Ord
             FROM Movement
                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId = zc_MI_Master()
      
                  INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                   AND MILinkObject_Unit.ObjectId = inUnitId
      
                  INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                    ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                   AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
      
             WHERE Movement.DescId = zc_Movement_Cash()
                AND Movement.StatusId = zc_Enum_Status_Complete()
             ) AS tmp
       WHERE tmp.Ord = 1; 
       
       --���� �� ����� ������
       IF COALESCE (outMovementId,0) = 0
       THEN   
           RAISE EXCEPTION '������.�������� ������ �� ������.';
       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.04.22         *
*/

-- ����
--select * from gpGet_Movement_Cash_Last( inUnitId := 52640 , inInfoMoneyId := 76878  , inSession := '5');