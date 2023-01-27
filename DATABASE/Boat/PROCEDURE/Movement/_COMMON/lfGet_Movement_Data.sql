-- Function: lfGet_Movement_Data (Integer) - ������������ ���

DROP FUNCTION IF EXISTS lfGet_Movement_Data (Integer);

CREATE OR REPLACE FUNCTION lfGet_Movement_Data (IN inMovementId Integer)
RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN COALESCE ((SELECT zfCalc_InvNumber_isErased (MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate, Movement.StatusId)
                       FROM Movement
                            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
                       WHERE Movement.Id = inMovementId
                      ), '');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.10.13                                        *                            
*/

-- ����
-- SELECT * FROM lfGet_Movement_Data (680)
