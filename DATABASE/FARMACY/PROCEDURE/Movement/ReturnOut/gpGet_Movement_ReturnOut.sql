-- Function: gpGet_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnOut (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnOut(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , InvNumberPartner TVarChar
             , OperDate TDateTime
             , OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , IncomeMovementId Integer 
             , IncomeOperDate TDateTime, IncomeInvNumber TVarChar
             , ReturnTypeId Integer
             , ReturnTypeName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , LegalAddressId Integer, LegalAddressName TVarChar 
             , ActualAddressId Integer, ActualAddressName TVarChar )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnOut());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_ReturnOut_seq') AS TVarChar) AS InvNumber
             , ''::TVarChar                                     AS InvNumberPartner
             , CURRENT_DATE::TDateTime                          AS OperDate
             , NULL::TDateTime                                  AS OperDatePartner
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST (False as Boolean)                          AS PriceWithVAT
             , 0                                                AS FromId
             , CAST ('' AS TVarChar)                            AS FromName
             , 0                                                AS ToId
             , CAST ('' AS TVarChar)                            AS ToName
             , 0                                                AS NDSKindId
             , CAST ('' AS TVarChar)                            AS NDSKindName
             , 0                                                AS IncomeMovementId
             , CURRENT_DATE::TDateTime                          AS IncomeOperDate
             , ''::TVarChar                                     AS IncomeInvNumber
             , 0                                                AS ReturnTypeId
             , CAST ('' AS TVarChar)                            AS ReturnTypeName
             , 0                                                AS JuridicalId
             , CAST('' as TVarChar)                             AS JuridicalName
             , 0                                                AS LegalAddressId
             , CAST('' as TVarChar)                             AS LegalAddressName
             , 0                                                AS ActualAddressId
             , CAST('' as TVarChar)                             AS ActualAddressName
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement_ReturnOut_View.Id
           , Movement_ReturnOut_View.InvNumber
           , Movement_ReturnOut_View.InvNumberPartner
           , Movement_ReturnOut_View.OperDate
           , Movement_ReturnOut_View.OperDatePartner
           , Movement_ReturnOut_View.StatusCode
           , Movement_ReturnOut_View.StatusName
           , Movement_ReturnOut_View.PriceWithVAT
           , Movement_ReturnOut_View.FromId
           , Movement_ReturnOut_View.FromName
           , Movement_ReturnOut_View.ToId
           , Movement_ReturnOut_View.ToName
           , Movement_ReturnOut_View.NDSKindId
           , Movement_ReturnOut_View.NDSKindName
           , Movement_ReturnOut_View.MovementIncomeId
           , Movement_ReturnOut_View.IncomeOperDate
           , Movement_ReturnOut_View.IncomeInvNumber
           , Movement_ReturnOut_View.ReturnTypeId
           , Movement_ReturnOut_View.ReturnTypeName
           , Movement_ReturnOut_View.JuridicalId
           , Movement_ReturnOut_View.JuridicalName
           , Movement_ReturnOut_View.LegalAddressId
           , Movement_ReturnOut_View.LegalAddressName
           , Movement_ReturnOut_View.ActualAddressId
           , Movement_ReturnOut_View.ActualAddressName

       FROM Movement_ReturnOut_View       
      WHERE Movement_ReturnOut_View.Id = inMovementId;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnOut (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 28.05.18                                                                     * 
 03.07.14                                                        *
*/

-- тест
-- select * from gpGet_Movement_ReturnOut(inMovementId := 7753659 ,  inSession := '3');