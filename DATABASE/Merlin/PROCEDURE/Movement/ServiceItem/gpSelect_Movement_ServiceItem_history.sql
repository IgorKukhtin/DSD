-- Function: gpSelect_Movement_ServiceItem_history()

DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemChoice (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItem_history (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ServiceItem_history(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsAll             Boolean ,
    IN inUnitId            Integer , 
    IN inInfoMoneyId       Integer , 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, DescId Integer, InvNumber Integer
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime 
             --
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             
             , DateStart TDateTime--, DateEnd TDateTime
             , Amount TFloat, Price TFloat, Area TFloat
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
       WITH tmpMovement AS (SELECT Movement.*
                                 , MovementItem.ObjectId           AS UnitId
                                 , MovementItem.Amount
                                 , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                 , MovementItem.Id AS MovementItemId
                                 , ROW_NUMBER() OVER (ORDER BY Movement.OperDate ASC) AS Ord
                           FROM Movement
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                                      AND MovementItem.ObjectId   = inUnitId

                               INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                                AND (MILinkObject_InfoMoney.ObjectId = inInfoMoneyId OR inInfoMoneyId = 0)

                           WHERE Movement.DescId = zc_Movement_ServiceItem()
                           --AND (Movement.OperDate BETWEEN inStartDate AND inEndDate OR inIsAll = TRUE)
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                           )

       SELECT
             Movement.Id
           , Movement.DescId
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
            --
           , Object_Unit.Id                AS UnitId
           , Object_Unit.ObjectCode        AS UnitCode
           , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName
           , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
           
           , Object_InfoMoney.Id         AS InfoMoneyId
           , Object_InfoMoney.ObjectCode AS InfoMoneyCode
           , Object_InfoMoney.ValueData  AS InfoMoneyName

           , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

           , COALESCE (tmpStartDate.OperDate + INTERVAL '1 DAY', zc_DateStart()) :: TDateTime AS DateStart
           , Movement.Amount                       :: TFloat    AS Amount
           , COALESCE (MIFloat_Price.ValueData, 0) :: TFloat AS Price
           , COALESCE (MIFloat_Area.ValueData, 0)  :: TFloat AS Area        
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId  

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = Movement.InfoMoneyId   
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = Movement.MovementItemId
                                            AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                   ON ObjectString_Unit_GroupNameFull.ObjectId = Movement.UnitId
                                  AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull() 

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price() 

            LEFT JOIN MovementItemFloat AS MIFloat_Area
                                        ON MIFloat_Area.MovementItemId = Movement.MovementItemId
                                       AND MIFloat_Area.DescId = zc_MIFloat_Area() 

            LEFT JOIN tmpMovement AS tmpStartDate ON tmpStartDate.Ord+1 = Movement.Ord
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
-- SELECT * FROM gpSelect_Movement_ServiceItem_history (inStartDate:= '01.01.2021', inEndDate:= '01.02.2023', inIsAll:= TRUE, inUnitId := 52753 , inInfoMoneyId := 76878 , inSession:= zfCalc_UserAdmin())
