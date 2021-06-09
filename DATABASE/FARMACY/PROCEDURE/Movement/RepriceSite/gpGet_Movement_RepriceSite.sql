-- Function: gpGet_Movement_RepriceSite()

DROP FUNCTION IF EXISTS gpGet_Movement_RepriceSite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_RepriceSite(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , TotalSumm TFloat
             , GUID TVarChar
             )
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_RepriceSite());

    RETURN QUERY

    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)    ::TFloat AS TotalSumm
      
      , MovementString_GUID.ValueData                         AS GUID

    FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT OUTER JOIN MovementString AS MovementString_GUID
                                       ON MovementString_GUID.MovementId = Movement.Id
                                      AND MovementString_GUID.DescId = zc_MovementString_Comment()
   
    WHERE Movement.Id = inMovementId
      AND Movement.DescId = zc_Movement_RepriceSite();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_RepriceSite (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
10.06.21                                                       *  
*/

-- test
-- select * from gpGet_Movement_RepriceSite(inMovementId := 3852856 ,  inSession := '3');