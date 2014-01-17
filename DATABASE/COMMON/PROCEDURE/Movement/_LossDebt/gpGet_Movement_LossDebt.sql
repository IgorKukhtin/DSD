-- Function: gpGet_Movement_LossDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_LossDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_LossDebt(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , BusinessId Integer, BusinessName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_LossDebt());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_LossDebt_seq') as Integer) AS InvNumber
           , CAST (CURRENT_DATE as TDateTime) AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName

           , Object_JuridicalBasis.Id        AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName
           , Object_Business.Id              AS BusinesId
           , Object_Business.ValueData       AS BusinessName

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = 9399
               LEFT JOIN Object AS Object_Business ON Object_Business.Id = 8370
       ;
     ELSE
     RETURN QUERY 
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , Object_JuridicalBasis.Id        AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName
           , Object_Business.Id              AS BusinesId
           , Object_Business.ValueData       AS BusinessName
  
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JuridicalBasis
                                         ON MovementLinkObject_JuridicalBasis.MovementId = Movement.Id
                                        AND MovementLinkObject_JuridicalBasis.DescId = zc_MovementLinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = MovementLinkObject_JuridicalBasis.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Business
                                         ON MovementLinkObject_Business.MovementId = Movement.Id
                                        AND MovementLinkObject_Business.DescId = zc_MovementLinkObject_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = MovementLinkObject_Business.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_LossDebt();

     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_LossDebt (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 14.01.14                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_LossDebt (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
