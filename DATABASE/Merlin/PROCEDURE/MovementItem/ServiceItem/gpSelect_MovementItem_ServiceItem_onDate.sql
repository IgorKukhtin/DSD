-- Function: gpSelect_MovementItem_ServiceItem_onDate()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItem_onDate (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ServiceItem_onDate(
    IN inOperDate         TDateTime      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar
             , Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             
             , DateStart TDateTime, DateEnd TDateTime
             , Amount TFloat, Price TFloat, Area TFloat
             
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_ServiceItem());
     vbUserId:= lpGetUserBySession (inSession);

     --
     inOperDate := CASE WHEN inOperDate IS NULL THEN CURRENT_DATE ELSE inOperDate END;
     
          -- Результат 
         RETURN QUERY 
          WITH 
          --данные за другие периоды для определения даты начала и предыдущих и след.значений
          tmpMI_All AS (SELECT tmp.*
                        FROM  (SELECT MovementItem.MovementId
                                    , Movement.OperDate
                                    , Movement.InvNumber
                                    , MovementItem.Id
                                    , MovementItem.ObjectId           AS UnitId
                                    , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                    , MovementItem.Amount
                                    , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_InfoMoney.ObjectId ORDER BY COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) asc) AS Ord
                               FROM Movement
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
    
                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                     ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
    
                                    INNER JOIN MovementItemDate AS MIDate_DateEnd
                                                               ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                              AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()
                                                              AND COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) > inOperDate
                               WHERE Movement.DescId = zc_Movement_ServiceItem()
                               AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                              ) AS tmp
                        WHERE tmp.ord IN (1,2)
                        ) 

         , tmpMI AS (SELECT MovementItem.UnitId
                          , MovementItem.InfoMoneyId
                          , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                          , COALESCE (tmp_before.DateEnd + interval '1 day', zc_DateStart()) AS DateStart
                          , MovementItem.DateEnd 
                          , MovementItem.Amount 
                          , COALESCE (MIFloat_Price.ValueData, 0)  AS Price
                          , COALESCE (MIFloat_Area.ValueData, 0)   AS Area 
                          , MovementItem.Id
                          , MovementItem.MovementId
                          , MovementItem.OperDate
                          , MovementItem.InvNumber
                     FROM tmpMI_All AS MovementItem
                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price() 

                        LEFT JOIN MovementItemFloat AS MIFloat_Area
                                                    ON MIFloat_Area.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Area.DescId = zc_MIFloat_Area()

                        LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                         ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_CommentInfoMoney.DescId = zc_MILinkObject_CommentInfoMoney()

                        LEFT JOIN (SELECT tmpMI_All.* FROM tmpMI_All WHERE tmpMI_All.ord = 2) AS tmp_before
                                                                                              ON tmp_before.UnitId = MovementItem.UnitId
                                                                                             AND tmp_before.InfoMoneyId = MovementItem.InfoMoneyId
                     WHERE MovementItem.Ord = 1
                     )
         

           SELECT tmpMI.MovementId
                , tmpMI.OperDate
                , tmpMI.InvNumber
                , tmpMI.Id                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
                
                , Object_InfoMoney.Id         AS Object_InfoMoneyId
                , Object_InfoMoney.ObjectCode AS Object_InfoMoneyCode
                , Object_InfoMoney.ValueData  AS Object_InfoMoneyName

                , Object_CommentInfoMoney.Id         AS Object_CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS Object_CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS Object_CommentInfoMoneyName

                , COALESCE (tmpMI.DateStart, zc_DateStart()) :: TDateTime AS DateStart
                , COALESCE (tmpMI.DateEnd, zc_DateEnd())     :: TDateTime AS DateEnd
                , tmpMI.Amount               :: TFloat    AS Amount
                , tmpMI.Price                :: TFloat    AS Price
                , tmpMI.Area                 :: TFloat    AS Area   

                , FALSE isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull() 
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ServiceItem_onDate (inOperDAte := '01.06.2022'::TDateTime, inSession:= zfCalc_UserAdmin()) order by 2