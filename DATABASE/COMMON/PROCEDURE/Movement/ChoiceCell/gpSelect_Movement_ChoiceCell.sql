-- Function: gpSelect_Movement_ChoiceCell()

DROP FUNCTION IF EXISTS gpSelect_Movement_ChoiceCell (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ChoiceCell(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsErased           Boolean   ,
    IN inJuridicalBasisId   Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )
 
        -- Результат
        SELECT
             Movement.Id                               AS Id
           , Movement.InvNumber                        AS InvNumber
           , Movement.OperDate                         AS OperDate
           , Object_Status.ObjectCode                  AS StatusCode
           , Object_Status.ValueData                   AS StatusName
           
        FROM tmpStatus
             INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                AND Movement.DescId = zc_Movement_ChoiceCell()
                                AND Movement.StatusId = tmpStatus.StatusId 
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ChoiceCell (inStartDate:= '01.01.2017', inEndDate:= CURRENT_DATE, inIsErased:= TRUE, inJuridicalBasisId:= 0, inMemberId:= 0, inSession:= zfCalc_UserAdmin())