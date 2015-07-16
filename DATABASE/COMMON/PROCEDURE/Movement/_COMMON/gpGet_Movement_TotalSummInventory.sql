DROP FUNCTION IF EXISTS gpGet_Movement_TotalSummInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TotalSummInventory(
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
            ('�����: '||trim (to_char (COALESCE (MovementFloat_TotalSumm.ValueData, 0) , '999 999 999 999 999D99')))::TVarChar  AS TotalSumm
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TotalSummInventory (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 15.07.14                                                          *
 */

-- ����
-- SELECT * FROM gpGet_Movement_TotalSummInventory (inMovementId:= 1, inSession:= '2')
