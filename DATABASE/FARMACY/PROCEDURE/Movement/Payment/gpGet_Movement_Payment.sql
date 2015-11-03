-- Function: gpGet_Movement_Payment()

DROP FUNCTION IF EXISTS gpGet_Movement_Payment (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Payment (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Payment (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Payment(
    IN inMovementId        Integer  , -- ���� ���������
    IN inDateStart         TDateTime, -- ������ ������� ��� �����
    IN inDateEnd           TDateTime, -- ����� ������� ��� �����
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , JuridicalId Integer
             , JuridicalName TVarChar
             , DateStart TDateTime
             , DateEnd TDateTime)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Payment());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        inDateStart := CURRENT_DATE;
        inDateEnd := CURRENT_DATE;
        RETURN QUERY
        SELECT
            0                                                   AS Id
          , CAST (NEXTVAL ('movement_Payment_seq') AS TVarChar) AS InvNumber
          , CURRENT_DATE::TDateTime	                            AS OperDate
          , Object_Status.Code               	                AS StatusCode
          , Object_Status.Name              		            AS StatusName
          , 0::TFloat                                           AS TotalCount
          , 0::TFloat                                           AS TotalSumm
          , NULL::Integer                                       AS JuridicalId
          , NULL::TVarChar                                      AS JuridicalName
          , inDateStart                                         AS DateStart
          , inDateEnd                                           AS DateEnd 
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete())   AS Object_Status;
    ELSE
        RETURN QUERY
        SELECT
            Movement_Payment.Id
          , Movement_Payment.InvNumber
          , Movement_Payment.OperDate
          , Movement_Payment.StatusCode
          , Movement_Payment.StatusName
          , Movement_Payment.TotalCount
          , Movement_Payment.TotalSumm
          , Movement_Payment.JuridicalId
          , Movement_Payment.JuridicalName
          , inDateStart AS DateStart
          , inDateEnd AS DateEnd
        FROM
            Movement_Payment_View AS Movement_Payment
        WHERE Movement_Payment.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Payment (Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 29.10.15                                                                        *
*/
