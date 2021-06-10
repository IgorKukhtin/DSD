-- Function: gpGet_Movement_RepriceSite_TotalSum()

DROP FUNCTION IF EXISTS gpGet_Movement_RepriceSite_TotalSum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_RepriceSite_TotalSum(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalSumm TFloat)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_RepriceSite());

    SELECT
        Movement_RepriceSite.TotalSum
    FROM
        Movement_RepriceSite_View AS Movement_RepriceSite
    WHERE Movement_RepriceSite.Id =  inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_RepriceSite_TotalSum (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
10.06.21                                                       *  
*/
