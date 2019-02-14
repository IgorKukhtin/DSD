-- Function: gpGet_Movement_GoodsSP_ID()

DROP FUNCTION IF EXISTS gpGet_Movement_GoodsSP_ID (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_GoodsSP_ID(
   OUT outMovementID   Integer,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_GoodsSP());
     vbUserId:= lpGetUserBySession (inSession);
     outMovementID := 0;

     SELECT MAX(Movement.Id)
     INTO outMovementID
     FROM Movement 

          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.DescId = zc_Movement_GoodsSP()
       AND CURRENT_DATE between  MovementDate_OperDateStart.ValueData AND MovementDate_OperDateEnd.ValueData 
       AND Movement.StatusId = zc_Enum_Status_Complete();
       
    IF COALESCE (outMovementID, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� "������ ���.�������" �� ������� ���� �������� !';
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 13.02.19                                                      * 
*/

-- ����
--SELECT * FROM gpGet_Movement_GoodsSP_ID (inSession:= '3')