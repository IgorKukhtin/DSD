-- Function: gpErasedMoneyFrom1C()

DROP FUNCTION IF EXISTS gpErasedMoneyFrom1C (TDateTime, TDateTime, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpErasedMoneyFrom1C(
    IN inStartDate           TDateTime  , -- ��������� ���� ��������
    IN inEndDate             TDateTime  , -- �������� ���� ��������
    IN inBranchId            Integer    , -- ������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_LoadMoneyFrom1C());
     vbUserId := lpGetUserBySession (inSession);



     -- �������� ���� ���������� �� ������ �� ������� 
     PERFORM gpSetErased_Movement (Movement.Id, inSession)
     FROM (SELECT Movement.Id
           FROM Movement  
                JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                JOIN ObjectLink AS zc_ObjectLink_Cash_Branch 
                                ON zc_ObjectLink_Cash_Branch.ObjectId = MovementItem.ObjectId
                               AND zc_ObjectLink_Cash_Branch.ChildObjectId = inBranchId
                               AND zc_ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                JOIN MovementBoolean AS MovementBoolean_isLoad 
                                     ON MovementBoolean_isLoad.MovementId = Movement.Id
                                    AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                    AND MovementBoolean_isLoad.ValueData = TRUE
           WHERE Movement.DescId = zc_Movement_Cash()
             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
             AND Movement.StatusId = zc_Enum_Status_Complete()
           GROUP BY Movement.Id
          ) AS Movement;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.01.15                                        *
*/

-- ����
-- SELECT * FROM gpErasedMoneyFrom1C ('01.07.2014'::TDateTime, '31.07.2014'::TDateTime, inBranchId:= 8379, inSession:= '5')
