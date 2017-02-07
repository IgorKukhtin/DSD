DROP FUNCTION IF EXISTS gpGet_Movement_TotalSummLoss (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TotalSummLoss(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalSumm TVarChar)
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());

     RETURN QUERY 
       SELECT
            ('�����: '||trim (to_char (COALESCE (MovementFloat_TotalCount.ValueData, 0) , '999 999 999 999 999D99')))::TVarChar  AS TotalSumm
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TotalSummLoss (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 24.07.14                                                          *
 */

-- ����
-- SELECT * FROM gpGet_Movement_TotalSummInventory (inMovementId:= 1, inSession:= '2')
