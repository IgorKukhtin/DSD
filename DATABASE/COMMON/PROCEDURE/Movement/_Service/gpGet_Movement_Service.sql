-- Function: gpGet_Movement_Service()

DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Service(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat 
             , JuridicalId Integer, JuridicalName TVarChar
             , MainJuridicalId Integer, MainJuridicalName TVarChar
             , BusinessId Integer, BusinessName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Service());

     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_Service_seq') AS TVarChar) AS InvNumber
           , CAST (CURRENT_DATE AS TDateTime) AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName
           
           , 0                                AS Amount

           , 0                                AS JuridicalId
           , CAST ('' as TVarChar)            AS JuridicalName
           , 0                                AS MainJuridicalId
           , CAST ('' as TVarChar)            AS MainJuridicalName
           , 0                                AS BusinessId
           , CAST ('' as TVarChar)            AS BusinessName
           , 0                                AS PaidKindId
           , CAST ('' as TVarChar)            AS PaidKindName
           , 0                                AS InfoMoneyId
           , CAST ('' as TVarChar)            AS InfoMoneyName
           , 0                                AS UnitId
           , CAST ('' as TVarChar)            AS UnitName

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;

     ELSE

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
                      
           , MovementFloat_Amount.ValueData   AS Amount

           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ValueData       AS JuridicalName
           , Object_MainJuridical.Id          AS MainJuridicalId
           , Object_MainJuridical.ValueData   AS MainJuridicalName

           , Object_Business.Id               AS BusinessId
           , Object_Business.ValueData        AS BusinessName

           , Object_PaidKind.Id               AS PaidKindId
           , Object_PaidKind.ValueData        AS PaidKindName
   
           , Object_InfoMoney.Id              AS InfoMoneyId
           , Object_InfoMoney.ValueData       AS InfoMoneyName
           , Object_Unit.Id                   AS UnitId
           , Object_Unit.ValueData            AS UnitName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId =  Movement.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_MainJuridical
                                         ON MovementLinkObject_MainJuridical.MovementId = Movement.Id
                                        AND MovementLinkObject_MainJuridical.DescId = zc_MovementLinkObject_JuridicalBasic()
            LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = MovementLinkObject_MainJuridical.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Business
                                         ON MovementLinkObject_Business.MovementId = Movement.Id
                                        AND MovementLinkObject_Business.DescId = zc_MovementLinkObject_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = MovementLinkObject_Business.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                         ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                        AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MovementLinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Service();
   END IF;  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Service (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.11.13                         * -- Default on Get
 11.08.13         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_Service (inMovementId:= 1, inSession:= '2')
