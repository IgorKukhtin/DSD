-- Function: gpGet_Movement_Reprice_TotalSum()

DROP FUNCTION IF EXISTS gpGet_Movement_Reprice_TotalSum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Reprice_TotalSum(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalSumm TFloat)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Reprice());

    SELECT
        Movement_Reprice.TotalSum
    FROM
        Movement_Reprice_View AS Movement_Reprice
    WHERE Movement_Reprice.Id =  inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Reprice_TotalSum (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
27.11.15                                                                        *
*/
