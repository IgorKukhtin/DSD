-- Function: gpSelect_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS gpSelect_Movement_SendOnPrice (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendOnPrice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsPartnerDate Boolean ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, TotalCount TFloat, TotalCountPartner TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SendOnPrice());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
       SELECT
             Movement_SendOnPrice.Id                    
           , Movement_SendOnPrice.InvNumber
           , Movement_SendOnPrice.OperDate
           , Movement_SendOnPrice.StatusCode
           , Movement_SendOnPrice.StatusName

           , Movement_SendOnPrice.OperDatePartner

           , Movement_SendOnPrice.PriceWithVAT

           , Movement_SendOnPrice.TotalCount
           , Movement_SendOnPrice.TotalCountPartner

           , Movement_SendOnPrice.TotalSummVAT
           , Movement_SendOnPrice.TotalSummMVAT
           , Movement_SendOnPrice.TotalSummPVAT

           , Movement_SendOnPrice.FromId
           , Movement_SendOnPrice.FromName
           , Movement_SendOnPrice.ToId
           , Movement_SendOnPrice.ToName

       FROM Movement_SendOnPrice_View AS Movement_SendOnPrice

                        JOIN tmpStatus ON Movement_SendOnPrice.StatusId = tmpStatus.StatusId

     WHERE  (Movement_SendOnPrice.OperDate BETWEEN inStartDate AND inEndDate AND inIsPartnerDate = FALSE)
         OR (Movement_SendOnPrice.OperDatePartner BETWEEN inStartDate AND inEndDate AND inIsPartnerDate = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.04.15                         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SendOnPrice (inStartDate:= '01.01.2013', inEndDate:= '01.02.2014', inIsPartnerDate:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())