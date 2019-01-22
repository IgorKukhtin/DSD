-- Function: gpGet_Movement_ReturnIn_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnIn_TotalSumm(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalCount TFloat
             , TotalSumm  TFloat
              )
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0::TFloat                                     AS TotalCount
          , 0::TFloat                                     AS TotalSumm
          ;
    ELSE
        RETURN QUERY
        SELECT
            MovementFloat_TotalCount.ValueData AS TotalCount
          , MovementFloat_TotalSumm.ValueData  AS TotalSumm
        FROM Movement AS Movement_ReturnIn
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        WHERE Movement_ReturnIn.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.19         * 
*/
