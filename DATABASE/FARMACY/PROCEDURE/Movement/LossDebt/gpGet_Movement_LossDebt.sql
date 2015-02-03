-- Function: gpGet_Movement_LossDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_LossDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_LossDebt(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
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
           , CAST (CURRENT_DATE as TDateTime) AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName
           , 0                                AS JuridicalBasisId
           , ''::TVarChar                     AS JuridicalBasisName
           
          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;
     ELSE
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusCode
           , Movement.StatusName
           , Movement.JuridicalBasisId
           , Movement.JuridicalBasisName

       FROM Movement_LossDebt_View AS Movement
      WHERE Movement.Id =  inMovementId;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_LossDebt (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.01.15                         *   
*/

-- тест
-- SELECT * FROM gpGet_Movement_LossDebt (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
