-- Function: gpGet_Movement_PUSH_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_PUSH_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PUSH_TotalSumm(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Message TBlob
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
            0::Integer                                      AS Id
          , Null::TBlob                                     AS Message;
    ELSE
        RETURN QUERY
        SELECT
               Movement.Id                                  AS Id
             , MovementBlob_Message.ValueData               AS Message
        FROM Movement
        
             LEFT JOIN MovementBlob AS MovementBlob_Message
                                    ON MovementBlob_Message.MovementId = Movement.Id
                                   AND MovementBlob_Message.DescId = zc_MovementBlob_Message()
            
        WHERE Movement.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_PUSH_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������ �.�.
 10.03.19         *
*/
