-- Function: gpGet_Movement_EmployeeSchedule_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_EmployeeSchedule_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_EmployeeSchedule_TotalSumm(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalSumm  TFloat
              )
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_EmployeeSchedule());

    RETURN QUERY
    SELECT
        0::TFloat                                     AS TotalSumm;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_EmployeeSchedule_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������ �.�.
 10.12.18         *
*/
