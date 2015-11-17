-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , TotalSummPrimeCost TFloat
             , UnitId Integer
             , UnitName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , PaidKindId Integer
             , PaidKindName TVarChar
             , Comment TVarChar)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_sale_seq') AS TVarChar) AS InvNumber
          , inOperDate				                         AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name              		         AS StatusName
          , 0::TFloat                                        AS TotalCount
          , 0::TFloat                                        AS TotalSumm
          , 0::TFloat                                        AS TotalSummPrimeCost
          , NULL::Integer                                    AS UnitId
          , NULL::TVarChar                                   AS UnitName
          , NULL::Integer                                    AS JuridicalId
          , NULL::TVarChar                                   AS JuridicalName
          , NULL::Integer                                    AS PaidKindId
          , NULL::TVarChar                                   AS PaidKindName
          , NULL::TVarChar                                   AS Comment
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
    ELSE
        RETURN QUERY
        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.StatusCode
          , Movement_Sale.StatusName
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummPrimeCost
          , Movement_Sale.UnitId
          , Movement_Sale.UnitName
          , Movement_Sale.JuridicalId
          , Movement_Sale.JuridicalName
          , Movement_Sale.PaidKindId
          , Movement_Sale.PaidKindName
          , Movement_Sale.Comment
        FROM
            Movement_Sale_View AS Movement_Sale
        WHERE Movement_Sale.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 13.10.15                                                                        *
*/
