-- Function: gpGet_Movement_LossDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_LossDebt (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_LossDebt (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_LossDebt(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , BusinessId Integer, BusinessName TVarChar
             , AccountId Integer, AccountName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , isList Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_LossDebt());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_LossDebt_seq') as Integer) AS InvNumber
--           , CAST (CURRENT_DATE as TDateTime) AS OperDate
           , inOperDate AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName

           , Object_JuridicalBasis.Id        AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName
           , Object_Business.Id              AS BusinesId
           , Object_Business.ValueData       AS BusinessName

           , 0             AS AccountId
           , ''::TVarChar  AS AccountName
          
           , 0             AS PaidKindId
           , ''::TVarChar  AS PaidKindName
           , False         AS isList
          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = 9399
               LEFT JOIN Object AS Object_Business ON Object_Business.Id = 0
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

           , View_Account.AccountId
           , View_Account.AccountName_all    AS AccountName

           , Object_PaidKind.Id              AS PaidKindId
           , Object_PaidKind.ValueData       AS PaidKindName
           , COALESCE (MovementBoolean_List.ValueData, False) :: Boolean AS isList
             
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_List
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JuridicalBasis
                                         ON MovementLinkObject_JuridicalBasis.MovementId = Movement.Id
                                        AND MovementLinkObject_JuridicalBasis.DescId = zc_MovementLinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = MovementLinkObject_JuridicalBasis.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Business
                                         ON MovementLinkObject_Business.MovementId = Movement.Id
                                        AND MovementLinkObject_Business.DescId = zc_MovementLinkObject_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = MovementLinkObject_Business.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Account
                                         ON MovementLinkObject_Account.MovementId = Movement.Id
                                        AND MovementLinkObject_Account.DescId = zc_MovementLinkObject_Account()
            LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = MovementLinkObject_Account.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId            
            
       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_LossDebt();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_LossDebt (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.03.14         * add PaidKind  
 24.03.14                                        * add Object_Account_View
 06.03.14         * add Account
 25.01.14                                        * add inOperDate
 14.01.14                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_LossDebt (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
