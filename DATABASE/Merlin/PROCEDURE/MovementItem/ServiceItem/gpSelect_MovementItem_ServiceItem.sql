-- Function: gpSelect_MovementItem_ServiceItem()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItem (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ServiceItem(
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
             
             , DateStart_before TDateTime, DateEnd_before TDateTime
             , Amount_before TFloat, Price_before TFloat, Area_before TFloat

             , DateStart_after TDateTime, DateEnd_after TDateTime
             , Amount_after TFloat, Price_after TFloat, Area_after TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_ServiceItem());
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
                                                          AND MIFloat_Price.DescId = zc_MIFloat_OperPrice() 

                               LEFT JOIN MovementItemFloat AS MIFloat_Area
                                                           ON MIFloat_Area.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Area.DescId = zc_MIFloat_OperPriceList()
   
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MIDate_DateEnd = MovementItem.Id
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
                
                , Object_InfoMoney.Id           AS Object_InfoMoneyId
                , Object_InfoMoney.ObjectCode   AS Object_InfoMoneyCode
                , Object_InfoMoney.ValueData    AS Object_InfoMoneyName

                , Object_CommentInfoMoney.Id         AS Object_CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS Object_CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS Object_CommentInfoMoneyName

                , NULL                       :: TDateTime AS DateStart
                , NULL                       :: TDateTime AS DateEnd
                , 0                          :: TFloat    AS Amount
                , 0                          :: TFloat    AS Price
                , 0                          :: TFloat    AS Area
                , False                      :: Boolean   AS isErased
   
           FROM tmpUnit
                LEFT JOIN tmpMI ON tmpMI.UnitId = tmpUnit.UnitId 

                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpUnit.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpUnit.InfoMoneyId


                LEFT JOIN ObjectString AS ObjectString_Unit_UnitGroupFull
                                       ON ObjectString_Unit_UnitGroupFull.ObjectId = tmpUnit.UnitId
                                      AND ObjectString_Unit_UnitGroupFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
           WHERE tmpMI.UnitId IS NULL

     UNION ALL
           -- Показываем только строки документа 
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

                , NULL                       :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.Amount               :: TFloat    AS Amount
                , tmpMI.Price                :: TFloat    AS Price
                , tmpMI.Area                 :: TFloat    AS Area
                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_UnitGroupFull
                                       ON ObjectString_Unit_UnitGroupFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_UnitGroupFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
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
                                                          AND MIFloat_Price.DescId = zc_MIFloat_OperPrice() 

                               LEFT JOIN MovementItemFloat AS MIFloat_Area
                                                           ON MIFloat_Area.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Area.DescId = zc_MIFloat_OperPriceList()
   
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MIDate_DateEnd = MovementItem.Id
                                                         AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()  

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                   
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                          )

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

                , NULL                       :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.Amount               :: TFloat    AS Amount
                , tmpMI.Price                :: TFloat    AS Price
                , tmpMI.Area                 :: TFloat    AS Area
                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_UnitGroupFull
                                       ON ObjectString_Unit_UnitGroupFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_UnitGroupFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
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
-- SELECT * FROM gpSelect_MovementItem_ServiceItem (inMovementId:= 7, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MovementItem_ServiceItem (inMovementId:= 7, inShowAll:= TRUE,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
