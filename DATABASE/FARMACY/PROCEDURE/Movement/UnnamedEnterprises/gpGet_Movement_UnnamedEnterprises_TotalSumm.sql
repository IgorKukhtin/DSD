-- Function: gpGet_Movement_UnnamedEnterprises_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_UnnamedEnterprises_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_UnnamedEnterprises_TotalSumm(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalSumm  TFloat
              )
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_UnnamedEnterprises());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0::TFloat                                     AS TotalSumm;
    ELSE
        RETURN QUERY
        SELECT
            COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat  AS TotalSumm
        FROM Movement
        
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            
        WHERE Movement.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_UnnamedEnterprises_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������ �.�.
 30.09.18         *
*/
