-- Function: gpSelect_Movement_ServiceItemAddChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemAddChoice (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ServiceItemAddChoice(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime 
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             , DateStart TDateTime, DateEnd TDateTime  
             , NumYearStart Integer            --год старт
             , NumYearEnd  Integer            --год енд
             , MonthNameStart  TVarChar
             , MonthNameEnd TVarChar
             , Amount TFloat 
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusCode
           , Movement.StatusName
           , Movement.InsertName
           , Movement.InsertDate
           , Movement.UpdateName
           , Movement.UpdateDate
           
           , Movement.UnitId
           , Movement.UnitCode
           , Movement.UnitName
           , Movement.UnitGroupNameFull
           
           , Movement.InfoMoneyId
           , Movement.InfoMoneyCode
           , Movement.InfoMoneyName
 
           , Movement.CommentInfoMoneyId
           , Movement.CommentInfoMoneyCode
           , Movement.CommentInfoMoneyName
 
           , Movement.DateStart            :: TDateTime
           , Movement.DateEnd              :: TDateTime   
           , EXTRACT (Year FROM Movement.DateStart)  ::Integer  AS NumYearStart            --год старт
           , EXTRACT (Year FROM Movement.DateEnd)    ::Integer  AS NumYearEnd              --год енд
           , zfCalc_MonthName (Movement.DateStart)   ::TVarChar AS MonthNameStart
           , zfCalc_MonthName (Movement.DateEnd)     ::TVarChar AS MonthNameEnd   
                
           , Movement.Amount               :: TFloat   
           , Movement.Comment
       FROM Movement_ServiceItemAdd_View AS Movement
            INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
       WHERE Movement.OperDate Between inStartDate AND inEndDate
         AND (Movement.isErased = False OR inIsErased = TRUE)
         
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.22         *
 */

-- тест
-- SELECT * FROM gpSelect_Movement_ServiceItemAddChoice (inStartDate:= '30.01.2015', inEndDate:= '01.01.2023', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
