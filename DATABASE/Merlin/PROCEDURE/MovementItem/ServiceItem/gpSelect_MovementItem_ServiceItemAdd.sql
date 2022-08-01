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
             
             , DateStart_Main TDateTime, DateEnd_Main TDateTime
             , Amount_Main TFloat, Price_Main TFloat, Area_Main TFloat
             
             --, Amount_before TFloat, Price_before TFloat, Area_before TFloat
             --, Amount_after TFloat, Price_after TFloat, Area_after TFloat 
             
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;    
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_ServiceItemAdd());
     vbUserId:= lpGetUserBySession (inSession);
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     
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
                              , COALESCE (MIDate_DateStart.ValueData, vbOperDate) AS DateStart 
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

                               LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                          ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateStart.DescId = zc_MIDate_DateStart() 
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

             , tmpMI_Main AS (SELECT *
                              FROM gpSelect_MovementItem_ServiceItem_onDate(inOperDate := vbOperDate ::TDateTime, inUnitId:= 0, inSession := inSession)
                              )

           -- результат
           SELECT 0                             AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
                
                , 0              AS InfoMoneyId
                , 0              AS InfoMoneyCode
                , '' ::TVarChar  AS InfoMoneyName

                , 0              AS CommentInfoMoneyId
                , 0              AS CommentInfoMoneyCode
                , '' ::TVarChar  AS CommentInfoMoneyName

                , NULL           :: TDateTime AS DateStart
                , NULL           :: TDateTime AS DateEnd
                , 0              :: TFloat    AS Amount
                , 0              :: TFloat    AS Price
                , 0              :: TFloat    AS Area 

                , NULL           :: TDateTime AS DateStart_Main
                , NULL           :: TDateTime AS DateEnd_Main
                , 0              :: TFloat    AS Amount_Main
                , 0              :: TFloat    AS Price_Main
                , 0              :: TFloat    AS Area_Main
                                                    
                , False          :: Boolean   AS isErased
   
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
                
                , Object_InfoMoney.Id           AS InfoMoneyId
                , Object_InfoMoney.ObjectCode   AS InfoMoneyCode
                , Object_InfoMoney.ValueData    AS InfoMoneyName

                , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

                , tmpMI.DateStart            :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.Amount               :: TFloat    AS Amount
                , tmpMI.Price                :: TFloat    AS Price
                , tmpMI.Area                 :: TFloat    AS Area 
                
                , tmpMI_Main.DateStart       :: TDateTime AS DateStart_Main
                , tmpMI_Main.DateEnd         :: TDateTime AS DateEnd_Main
                , tmpMI_Main.Amount          :: TFloat    AS Amount_Main
                , tmpMI_Main.Price           :: TFloat    AS Price_Main
                , tmpMI_Main.Area            :: TFloat    AS Area_Main

                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId

                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

                LEFT JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate := tmpMI.DateEnd ::TDateTime
                                                                  , inUnitId := tmpMI.UnitId
                                                                  , inSession := inSession
                                                                   ) AS tmpMI_Main
                                                                     ON tmpMI_Main.UnitId = tmpMI.UnitId
                                                                    AND tmpMI_Main.InfoMoneyId = tmpMI.InfoMoneyId
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
                              , COALESCE (MIDate_DateStart.ValueData, vbOperDate) AS DateStart 
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
   
                               LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                          ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateStart.DescId = zc_MIDate_DateStart()  
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

           SELECT tmpMI.Id                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
                
                , Object_InfoMoney.Id         AS InfoMoneyId
                , Object_InfoMoney.ObjectCode AS InfoMoneyCode
                , Object_InfoMoney.ValueData  AS InfoMoneyName

                , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

                , tmpMI.DateStart            :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.Amount               :: TFloat    AS Amount
                , tmpMI.Price                :: TFloat    AS Price
                , tmpMI.Area                 :: TFloat    AS Area   

                , tmpMI_Main.DateStart       :: TDateTime AS DateStart_Main
                , tmpMI_Main.DateEnd         :: TDateTime AS DateEnd_Main
                , tmpMI_Main.Amount          :: TFloat    AS Amount_Main
                , tmpMI_Main.Price           :: TFloat    AS Price_Main
                , tmpMI_Main.Area            :: TFloat    AS Area_Main

                , tmpMI.isErased
           FROM tmpMI
                

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull() 

                LEFT JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate := tmpMI.DateStart ::TDateTime
                                                                  , inUnitId := tmpMI.UnitId
                                                                  , inSession := inSession
                                                                   ) AS tmpMI_Main
                                                                     ON tmpMI_Main.UnitId = tmpMI.UnitId
                                                                    AND tmpMI_Main.InfoMoneyId = tmpMI.InfoMoneyId
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
