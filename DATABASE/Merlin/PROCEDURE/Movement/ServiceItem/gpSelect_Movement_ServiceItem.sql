-- Function: gpSelect_Movement_ServiceItem()

DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItem (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItem (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ServiceItem(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsDate_InsUpd     Boolean ,
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, DescId Integer, InvNumber Integer
             , OperDate TDateTime
             , StatusId Integer, StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             --, isAdd Boolean
             --
             , MovementItemId Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, UnitName_Full TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar

             , Amount TFloat, Price TFloat, Area TFloat
             , DateStart TDateTime, DateStart_month TDateTime, DateEnd TDateTime, DateEnd_month TDateTime
             , Month_diff Integer

             , Amount_before TFloat, Price_before TFloat, Area_before TFloat
             , DateStart_before TDateTime, DateStart_before_month TDateTime, DateEnd_before TDateTime, DateEnd_before_month TDateTime

             , Amount_after TFloat, Price_after TFloat, Area_after TFloat
             , DateStart_after TDateTime, DateStart_after_month TDateTime, DateEnd_after TDateTime, DateEnd_after_month TDateTime
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
           -- ВСЕ документы
         , tmpMovement AS (SELECT Movement.*
                           FROM tmpStatus
                                JOIN Movement ON Movement.DescId IN (zc_Movement_ServiceItem())        --, zc_Movement_ServiceItemAdd()
                                           --AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                             AND Movement.StatusId = tmpStatus.StatusId
                          )
           -- ВСЕ элементы
         , tmpMI AS (SELECT Movement.Id                                   AS MovementId
                          , Movement.Descid                               AS MovementDescId
                          , Movement.StatusId                             AS StatusId
                          , Movement.InvNumber                            AS InvNumber
                          , Movement.OperDate                             AS DateEnd
                          , MovementItem.Id                               AS MovementItemId
                          , MovementItem.ObjectId                         AS UnitId
                          , MILinkObject_InfoMoney.ObjectId               AS InfoMoneyId
                          , MovementItem.Amount                           AS Amount
                     FROM tmpMovement AS Movement
                          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
-- where MovementItem.ObjectId = 52809
                    )
  , tmpMI_before AS (SELECT tmpMI.UnitId
                          , tmpMI.InfoMoneyId
                          , tmpMI.DateEnd
                            --
                          , tmpMI_f.MovementId
                          , tmpMI_f.DateEnd AS DateEnd_find
                          , tmpMI_f.MovementItemId
                          , tmpMI_f.Amount
                            -- № п/п
                          , ROW_NUMBER() OVER (PARTITION BY tmpMI.UnitId, tmpMI.InfoMoneyId, tmpMI.DateEnd ORDER BY COALESCE (tmpMI_f.DateEnd, zc_DateEnd()) DESC) AS Ord
                     FROM tmpMI
                          -- поиск "предыдущих"
                          LEFT JOIN tmpMI AS tmpMI_f ON tmpMI_f.UnitId       = tmpMI.UnitId
                                                    AND tmpMI_f.InfoMoneyId  = tmpMI.InfoMoneyId
                                                    AND tmpMI_f.DateEnd      < tmpMI.DateEnd
                                                    AND tmpMI_f.StatusId     = zc_Enum_Status_Complete()
                    )
   , tmpMI_after AS (SELECT tmpMI.UnitId
                          , tmpMI.InfoMoneyId
                          , tmpMI_f.MovementId
                          , tmpMI.DateEnd
                            --
                          , tmpMI_f.DateEnd AS DateEnd_find
                          , tmpMI_f.MovementItemId
                          , tmpMI_f.Amount
                            -- № п/п
                          , ROW_NUMBER() OVER (PARTITION BY tmpMI.UnitId, tmpMI.InfoMoneyId, tmpMI.DateEnd ORDER BY COALESCE (tmpMI_f.DateEnd, zc_DateEnd()) ASC) AS Ord
                     FROM tmpMI
                          LEFT JOIN tmpMI AS tmpMI_f ON tmpMI_f.UnitId       = tmpMI.UnitId
                                                    AND tmpMI_f.InfoMoneyId  = tmpMI.InfoMoneyId
                                                    AND tmpMI_f.DateEnd      > tmpMI.DateEnd
                                                    AND tmpMI_f.StatusId     = zc_Enum_Status_Complete()
                    )
       -- 
       SELECT
             tmpMI.MovementId                           AS Id
           , tmpMI.MovementDescId                       AS DescId
           , zfConvert_StringToNumber (tmpMI.InvNumber) AS InvNumber
           , tmpMI.DateEnd                              AS OperDate
           , Object_Status.Id                           AS StatusId
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , Object_Insert.ValueData                    AS InsertName
           , MovementDate_Insert.ValueData              AS InsertDate
           , Object_Update.ValueData                    AS UpdateName
           , MovementDate_Update.ValueData              AS UpdateDate

             --
           , tmpMI.MovementItemId                      AS MovementItemId
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName
           , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
           , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull

           , Object_InfoMoney.Id                       AS Object_InfoMoneyId
           , Object_InfoMoney.ObjectCode               AS Object_InfoMoneyCode
           , Object_InfoMoney.ValueData                AS Object_InfoMoneyName

           , Object_CommentInfoMoney.Id                AS Object_CommentInfoMoneyId
           , Object_CommentInfoMoney.ObjectCode        AS Object_CommentInfoMoneyCode
           , Object_CommentInfoMoney.ValueData         AS Object_CommentInfoMoneyName

           , tmpMI.Amount                 :: TFloat    AS Amount
           , MIFloat_Price.ValueData      :: TFloat    AS Price
           , MIFloat_Area.ValueData       :: TFloat    AS Area

           , COALESCE (tmpMI_before.DateEnd_find + INTERVAL '1 DAY', NULL) :: TDateTime AS DateStart
           , COALESCE (zfCalc_Month_start (tmpMI_before.DateEnd_find + INTERVAL '1 DAY'), NULL) :: TDateTime AS DateStart_month
           , tmpMI.DateEnd                :: TDateTime AS DateEnd
           , zfCalc_Month_end (tmpMI.DateEnd) :: TDateTime AS DateEnd_month

           , zfCalc_Month_diff (tmpMI_before.DateEnd_find + INTERVAL '1 DAY', tmpMI.DateEnd) :: Integer AS Month_diff

           , tmpMI_before.Amount            :: TFloat    AS Amount_before
           , MIFloat_Price_before.ValueData :: TFloat    AS Price_before
           , MIFloat_Area_before.ValueData  :: TFloat    AS Area_before

           , CASE WHEN tmpMI_before.DateEnd_find IS NULL THEN NULL ELSE COALESCE (tmpMI_before_before.DateEnd_find + INTERVAL '1 DAY', NULL) END :: TDateTime AS DateStart_before
           , CASE WHEN tmpMI_before.DateEnd_find IS NULL THEN NULL ELSE COALESCE (zfCalc_Month_start (tmpMI_before_before.DateEnd_find + INTERVAL '1 DAY'), NULL) END :: TDateTime AS DateStart_before_month
           , tmpMI_before.DateEnd_find      :: TDateTime AS DateEnd_before
           , zfCalc_Month_end (tmpMI_before.DateEnd_find) :: TDateTime AS DateEnd_before_month

           , tmpMI_after.Amount             :: TFloat    AS Amount_after
           , MIFloat_Price_after.ValueData  :: TFloat    AS Price_after
           , MIFloat_Area_after.ValueData   :: TFloat    AS Area_after

           , CASE WHEN tmpMI_after.DateEnd_find IS NULL THEN NULL ELSE zfCalc_Month_start (tmpMI.DateEnd + INTERVAL '1 DAY') END :: TDateTime AS DateStart_after
           , CASE WHEN tmpMI_after.DateEnd_find IS NULL THEN NULL ELSE tmpMI.DateEnd + INTERVAL '1 DAY' END :: TDateTime AS DateStart_after_month
           , tmpMI_after.DateEnd_find       :: TDateTime AS DateEnd_after
           , zfCalc_Month_end (tmpMI_after.DateEnd_find) :: TDateTime AS DateEnd_after_month

       FROM tmpMI
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMI.StatusId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = tmpMI.MovementId
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = tmpMI.MovementId
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = tmpMI.MovementId
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = tmpMI.MovementId
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = tmpMI.MovementItemId
                                            AND MILinkObject_CommentInfoMoney.DescId = zc_MILinkObject_CommentInfoMoney()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_Area
                                        ON MIFloat_Area.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Area.DescId = zc_MIFloat_Area()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                   ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                  AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

            LEFT JOIN tmpMI_before ON tmpMI_before.UnitId      = tmpMI.UnitId
                                  AND tmpMI_before.InfoMoneyId = tmpMI.InfoMoneyId
                                  AND tmpMI_before.DateEnd     = tmpMI.DateEnd
                                  AND tmpMI_before.Ord         = 1
            LEFT JOIN tmpMI_before AS tmpMI_before_before
                                   ON tmpMI_before_before.UnitId      = tmpMI.UnitId
                                  AND tmpMI_before_before.InfoMoneyId = tmpMI.InfoMoneyId
                                  AND tmpMI_before_before.DateEnd     = tmpMI.DateEnd
                                  AND tmpMI_before_before.Ord         = 2
            LEFT JOIN tmpMI_after ON tmpMI_after.UnitId      = tmpMI.UnitId
                                 AND tmpMI_after.InfoMoneyId = tmpMI.InfoMoneyId
                                 AND tmpMI_after.DateEnd     = tmpMI.DateEnd
                                 AND tmpMI_after.Ord         = 1

            LEFT JOIN MovementItemFloat AS MIFloat_Price_before
                                        ON MIFloat_Price_before.MovementItemId = tmpMI_before.MovementItemId
                                       AND MIFloat_Price_before.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_Area_before
                                        ON MIFloat_Area_before.MovementItemId = tmpMI_before.MovementItemId
                                       AND MIFloat_Area_before.DescId = zc_MIFloat_Area()

            LEFT JOIN MovementItemFloat AS MIFloat_Price_after
                                        ON MIFloat_Price_after.MovementItemId = tmpMI_after.MovementItemId
                                       AND MIFloat_Price_after.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_Area_after
                                        ON MIFloat_Area_after.MovementItemId = tmpMI_after.MovementItemId
                                       AND MIFloat_Area_after.DescId = zc_MIFloat_Area()

     --WHERE COALESCE (tmpMI_before.DateEnd_find + INTERVAL '1 DAY', tmpMI.DateEnd) BETWEEN inStartDate AND inEndDate
       WHERE (inIsDate_InsUpd = FALSE AND tmpMI.DateEnd BETWEEN inStartDate AND inEndDate)
          OR (inIsDate_InsUpd = TRUE AND (MovementDate_Insert.ValueData BETWEEN inStartDate AND inEndDate OR MovementDate_Update.ValueData BETWEEN inStartDate AND inEndDate) )
       -- WHERE tmpMI.MovementId = 291971
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.22         *
 */

-- тест
-- SELECT DateStart, DateEnd, * FROM gpSelect_Movement_ServiceItem (inStartDate:= '01.01.2021', inEndDate:= '01.01.2022', inIsDate_InsUpd:=FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
