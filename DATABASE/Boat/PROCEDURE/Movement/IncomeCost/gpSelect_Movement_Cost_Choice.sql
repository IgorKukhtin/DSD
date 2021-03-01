-- Function: gpSelect_Movement_Cost_Choice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cost_Choice (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar);
CREATE OR REPLACE FUNCTION gpSelect_Movement_Cost_Choice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean   ,
    IN inInfoMoneyId   Integer   ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar , DescId Integer, DescName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , AmountCost TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )


     , tmpInvoice AS (SELECT Movement.Id AS MovementId
                             , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
                             --, zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
                             , ('№ ' || Movement.InvNumber || ' от ' || Movement.OperDate  :: Date :: TVarChar || ' ('|| MovementDesc.ItemName||')' ) :: TVarChar AS InvNumber_Full
                             , Movement.OperDate
                             , Movement.StatusId                             AS StatusId
                             , MovementString_Comment.ValueData              AS Comment
                             , MovementDesc.Id                               AS DescId
                             , MovementDesc.ItemName                         AS DescName
                             , 0                                             AS InfoMoneyId
                        FROM tmpStatus
                            INNER JOIN Movement ON Movement.DescId = zc_Movement_Invoice()
                                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                               AND Movement.StatusId = tmpStatus.StatusId
                            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
      
                            LEFT JOIN MovementString AS MovementString_Comment
                                                     ON MovementString_Comment.MovementId =  Movement.Id
                                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
                       )

     , tmpList AS  (SELECT tr1.MovementId, tr1.InvNumber, tr1.OperDate, tr1.Comment 
                         , tr1.StatusId, tr1.InvNumber_Full, tr1.DescId, tr1.DescName, tr1.InfoMoneyId
                    FROM tmpInvoice AS tr1
                    )


        -- РЕЗУЛЬТАТ                         
        SELECT tmpList.MovementId
             , tmpList.InvNumber
             , tmpList.InvNumber_Full
             , tmpList.OperDate 
             , Object_Status.ObjectCode         AS StatusCode
             , Object_Status.ValueData          AS StatusName
             , tmpList.Comment
             , tmpList.DescId
             , tmpList.DescName
               
             , Object_InfoMoney_View.InfoMoneyCode
             , Object_InfoMoney_View.InfoMoneyName
             , Object_InfoMoney_View.InfoMoneyName_all

             , MovementFloat_AmountCost.ValueData       AS AmountCost

        FROM tmpList
            LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                    ON MovementFloat_AmountCost.MovementId = tmpList.MovementId
                                   AND MovementFloat_AmountCost.DescId     = zc_MovementFloat_AmountCost()

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpList.StatusId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpList.InfoMoneyId
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.03.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cost_Choice (inStartDate:= '01.09.2015'::TDateTime, inEndDate:= '01.09.2015'::TDateTime, inIsErased:= FALSE, inInfoMoneyId :=0, inSession:= zfCalc_UserAdmin())
