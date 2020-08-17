-- Function: gpGet_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PaidTypeId Integer, PaidTypeName TVarChar
             , TotalCount TFloat, TotalSumm TFloat, TotalSummPayAdd TFloat
             , UnitId Integer, UnitName TVarChar
             , CashRegisterId Integer, CashRegisterName TVarChar
             , FiscalCheckNumber TVarChar
             , IdCheck Integer, InvNumberCheck TVarChar, OperDateCheck TDateTime
             , PaidTypeCheckId Integer, PaidTypeCheckName TVarChar, TotalSummCheck TFloat, TotalSummPayAddCheck TFloat

)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpReturnInRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
    vbUserId := inSession;
    -- ���������� ������������� ()
    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
    THEN
      vbUnitId := COALESCE ((SELECT tmp.UnitId FROM gpGet_UserUnit(inSession) AS tmp), 0);
    ELSE
      vbUnitId := 0;
    END IF;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
--          , CAST (NEXTVAL ('movement_sale_seq') AS TVarChar) AS InvNumber
          , CAST ('' AS TVarChar) AS InvNumber
          , CURRENT_DATE::TDateTime                          AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name              	             AS StatusName
          , 0::Integer                                       AS PaidTypeId
          , ''::TVarChar                                     AS PaidTypeName
          , 0::TFloat                                        AS TotalCount
          , 0::TFloat                                        AS TotalSumm
          , 0::TFloat                                        AS TotalSummPayAdd
          , Object_Unit.Id                                   AS UnitId
          , Object_Unit.ValueData                            AS UnitName

          , 0::Integer                                       AS CashRegisterId
          , ''::TVarChar                                     AS CashRegisterName

          , ''::TVarChar                                     AS FiscalCheckNumber

          , 0::Integer                                       AS IdCheck
          , ''::TVarChar                                     AS InvNumberCheck
          , Null::TDateTime                                  AS OperDateCheck
          , 0::Integer                                       AS PaidTypeCheckId
          , ''::TVarChar                                     AS PaidTypeCheckName
          , 0::TFloat                                        AS TotalSummCheck
          , 0::TFloat                                        AS TotalSummPayAddCheck

        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId
        ;              
    ELSE

     RETURN QUERY
      SELECT Movement_ReturnIn.Id
           , Movement_ReturnIn.InvNumber
           , Movement_ReturnIn.OperDate                 AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementLinkObject_PaidType.ObjectId       AS PaidTypeId
           , Object_PaidType.ValueData                  AS PaidTypeName
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementFloat_TotalSummPayAdd.ValueData    AS TotalSummPayAdd 
           , MovementLinkObject_Unit.ObjectId           AS UnitId
           , Object_Unit.ValueData                      AS UnitName

           , MovementLinkObject_CashRegister.ObjectId   AS CashRegisterId
           , Object_CashRegister.ValueData              AS CashRegisterName

           , MovementString_FiscalCheckNumber.ValueData AS FiscalCheckNumber

           , MovementCheck.Id                           AS IdCheck
           , MovementCheck.InvNumber                    AS InvNumberCheck
           , MovementCheck.OperDate                     AS OperDateCheck
           , MovementLinkObject_PaidTypeCheck.ObjectId  AS PaidTypeCheckId
           , Object_PaidTypeCheck.ValueData             AS PaidTypeCheckName
           , MovementFloat_TotalSummCheck.ValueData     AS TotalSummCheck
           , MovementFloat_TotalSummPayAddCheck.ValueData AS TotalSummPayAddCheck 

      FROM Movement AS Movement_ReturnIn
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ReturnIn.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                    ON MovementFloat_TotalSummPayAdd.MovementId =  Movement_ReturnIn.Id
                                   AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()

	        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                         ON MovementLinkObject_PaidType.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
            LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                     ON MovementString_FiscalCheckNumber.MovementId = Movement_ReturnIn.Id
                                    AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()

            LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                    ON MovementFloat_MovementId.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
            LEFT JOIN Movement AS MovementCheck ON MovementCheck.ID = MovementFloat_MovementId.ValueData::Integer

	        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidTypeCheck
                                         ON MovementLinkObject_PaidTypeCheck.MovementId = MovementCheck.Id
                                        AND MovementLinkObject_PaidTypeCheck.DescId = zc_MovementLinkObject_PaidType()
            LEFT JOIN Object AS Object_PaidTypeCheck ON Object_PaidTypeCheck.Id = MovementLinkObject_PaidTypeCheck.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCheck
                                    ON MovementFloat_TotalSummCheck.MovementId =  MovementCheck.Id
                                   AND MovementFloat_TotalSummCheck.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAddCheck
                                    ON MovementFloat_TotalSummPayAddCheck.MovementId =  MovementCheck.Id
                                   AND MovementFloat_TotalSummPayAddCheck.DescId = zc_MovementFloat_TotalSummPayAdd()

       WHERE Movement_ReturnIn.Id = inMovementId
         AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
      ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.01.19         *
*/

-- ����
-- 
SELECT * FROM gpGet_Movement_ReturnIn (inMovementId:= 19806544, inSession:= '3')