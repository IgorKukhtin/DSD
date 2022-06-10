-- Function: gpSelect_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItemAdd (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ServiceItemAdd(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             
             , DateStart TDateTime, DateEnd TDateTime
             , Amount TFloat, Price TFloat, Area TFloat
             
             --, Amount_before TFloat, Price_before TFloat, Area_before TFloat
             --, Amount_after TFloat, Price_after TFloat, Area_after TFloat 
             
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_ServiceItemAdd());
     vbUserId:= lpGetUserBySession (inSession);

     IF inShowAll = TRUE
     THEN
        -- Показываем ВСЕ
        RETURN QUERY 
          WITH tmpMI AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId                  AS UnitId   
                              , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                              , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                              , MovementItem.Amount 
                              , COALESCE (MIFloat_Price.ValueData, 0)  AS Price
                              , COALESCE (MIFloat_Area.ValueData, 0)   AS Area
                              , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                              , MovementItem.isErased
                          FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                               JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = tmpIsErased.isErased

                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price() 

                               LEFT JOIN MovementItemFloat AS MIFloat_Area
                                                           ON MIFloat_Area.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Area.DescId = zc_MIFloat_Area()
   
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()  

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                   
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                          )

             , tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                           FROM Object AS Object_Unit
                           WHERE Object_Unit.DescId = zc_Object_Unit()
                             AND Object_Unit.isErased = FALSE
                           )

           -- результат
           SELECT 0                             AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
                
                , 0              AS Object_InfoMoneyId
                , 0              AS Object_InfoMoneyCode
                , '' ::TVarChar  AS Object_InfoMoneyName

                , 0              AS Object_CommentInfoMoneyId
                , 0              AS Object_CommentInfoMoneyCode
                , '' ::TVarChar  AS Object_CommentInfoMoneyName

                , NULL                       :: TDateTime AS DateStart
                , NULL                       :: TDateTime AS DateEnd
                , 0                          :: TFloat    AS Amount
                , 0                          :: TFloat    AS Price
                , 0                          :: TFloat    AS Area 

               /* , 0                          :: TFloat    AS Amount_before
                , 0                          :: TFloat    AS Price_before
                , 0                          :: TFloat    AS Area_before
                                                                
                , 0                          :: TFloat    AS Amount_after
                , 0                          :: TFloat    AS Price_after
                , 0                          :: TFloat    AS Area_after
                */
                , False                      :: Boolean   AS isErased
   
           FROM tmpUnit
                LEFT JOIN tmpMI ON tmpMI.UnitId = tmpUnit.UnitId 

                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpUnit.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
           WHERE tmpMI.UnitId IS NULL

     UNION ALL
           -- Показываем только строки документа 
           SELECT tmpMI.Id                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
                
                , Object_InfoMoney.Id           AS Object_InfoMoneyId
                , Object_InfoMoney.ObjectCode   AS Object_InfoMoneyCode
                , Object_InfoMoney.ValueData    AS Object_InfoMoneyName

                , Object_CommentInfoMoney.Id         AS Object_CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS Object_CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS Object_CommentInfoMoneyName

                , NULL                       :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.Amount               :: TFloat    AS Amount
                , tmpMI.Price                :: TFloat    AS Price
                , tmpMI.Area                 :: TFloat    AS Area   

               /* , 0                          :: TFloat    AS Amount_before
                , 0                          :: TFloat    AS Price_before
                , 0                          :: TFloat    AS Area_before

                , 0                          :: TFloat    AS Amount_after
                , 0                          :: TFloat    AS Price_after
                , 0                          :: TFloat    AS Area_after
                */
                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId

                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
          ;

     ELSE 
         -- Результат такой - Показываем только строки документа
         RETURN QUERY 
          WITH tmpMI AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId                  AS UnitId   
                              , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                              , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                              , MovementItem.Amount 
                              , COALESCE (MIFloat_Price.ValueData, 0)  AS Price
                              , COALESCE (MIFloat_Area.ValueData, 0)   AS Area
                              , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                              , MovementItem.isErased
                          FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                               JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = tmpIsErased.isErased

                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price() 

                               LEFT JOIN MovementItemFloat AS MIFloat_Area
                                                           ON MIFloat_Area.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Area.DescId = zc_MIFloat_Area()
   
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()  

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                   
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                          ) 
          --данные за другие периоды для определения даты начала и предыдущих и след.значений
         , tmpMI_its AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId AS UnitId
                              , MovementItem.Amount
                         FROM Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.ObjectId IN (SELECT DISTINCT tmpMI.UnitId FROM tmpMI) 
                         WHERE Movement.DescId = zc_Movement_ServiceItemAdd()
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                         AND Movement.Id <> inMovementId
                         ) 

         , tmpMI_itsAll AS (SELECT MovementItem.UnitId
                                 , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId 
                                 , MovementItem.Amount 
                                 , COALESCE (MIFloat_Price.ValueData, 0)  AS Price
                                 , COALESCE (MIFloat_Area.ValueData, 0)   AS Area
                                 , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                            FROM tmpMI_its AS MovementItem
                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price() 

                               LEFT JOIN MovementItemFloat AS MIFloat_Area
                                                           ON MIFloat_Area.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Area.DescId = zc_MIFloat_Area()
   
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()  

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                             )
         
         , tmpMI_before AS (SELECT tmp.*
                                 , (tmp.DateEnd + Interval '1 day') ::TDateTime AS DateStart
                            FROM (SELECT tmpMI_itsAll.UnitId
                                       , tmpMI_itsAll.InfoMoneyId
                                       , tmpMI_itsAll.DateEnd
                                       , tmpMI_itsAll.Amount
                                       , tmpMI_itsAll.Price
                                       , tmpMI_itsAll.Area
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMI.UnitId, tmpMI.InfoMoneyId ORDER BY tmpMI_itsAll.DateEnd DESC) AS Ord
                                  FROM tmpMI
                                       LEFT JOIN tmpMI_itsAll ON tmpMI_itsAll.UnitId  = tmpMI.UnitId
                                                             AND tmpMI_itsAll.InfoMoneyId  = tmpMI.InfoMoneyId
                                                             AND tmpMI_itsAll.DateEnd < tmpMI.DateEnd
                                ) AS tmp
                            WHERE tmp.Ord = 1
                            )

        /* , tmpMI_after AS (SELECT tmp.*
                           FROM (SELECT tmpMI_itsAll.UnitId
                                      , tmpMI_itsAll.InfoMoneyId
                                      , tmpMI_itsAll.DateEnd
                                      , tmpMI_itsAll.Amount
                                      , tmpMI_itsAll.Price
                                      , tmpMI_itsAll.Area
                                      , ROW_NUMBER() OVER (PARTITION BY tmpMI.UnitId, tmpMI.InfoMoneyId ORDER BY tmpMI_itsAll.DateEnd Asc) AS Ord
                                 FROM tmpMI
                                      LEFT JOIN tmpMI_itsAll ON tmpMI_itsAll.UnitId  = tmpMI.UnitId
                                                            AND tmpMI_itsAll.InfoMoneyId  = tmpMI.InfoMoneyId
                                                            AND tmpMI_itsAll.DateEnd > tmpMI.DateEnd
                               ) AS tmp
                           WHERE tmp.Ord = 1
                           ) 
          */

           SELECT tmpMI.Id                      AS Id
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

                , COALESCE (tmpMI_before.DateStart, zc_DateStart()) :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.Amount               :: TFloat    AS Amount
                , tmpMI.Price                :: TFloat    AS Price
                , tmpMI.Area                 :: TFloat    AS Area   

              /*  , tmpMI_before.Amount        :: TFloat    AS Amount_before
                , tmpMI_before.Price         :: TFloat    AS Price_before
                , tmpMI_before.Area          :: TFloat    AS Area_before

                , tmpMI_after.Amount         :: TFloat    AS Amount_after
                , tmpMI_after.Price          :: TFloat    AS Price_after
                , tmpMI_after.Area           :: TFloat    AS Area_after
                 */
                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull() 

                LEFT JOIN tmpMI_before ON tmpMI_before.UnitId = tmpMI.UnitId  
                                      AND tmpMI_before.InfoMoneyId = tmpMI.InfoMoneyId

               /* LEFT JOIN tmpMI_after ON tmpMI_after.UnitId = tmpMI.UnitId  
                                     AND tmpMI_after.InfoMoneyId = tmpMI.InfoMoneyId
              */
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ServiceItemAdd (inMovementId:= 7, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MovementItem_ServiceItemAdd (inMovementId:= 7, inShowAll:= TRUE,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
