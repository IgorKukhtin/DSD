-- Function: gpGet_MI_ServiceItem ()


DROP FUNCTION IF EXISTS gpGet_MI_ServiceItem (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_ServiceItem(
    IN inId                 Integer   , --
    IN inUnitId             Integer   , --
    IN inInfoMoneyId        Integer   , --
    IN inStartDate          TDateTime , -- Дата Истории
    IN inEndDate            TDateTime , -- Дата Истории
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, NameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , Amount TFloat, Price TFloat, Area TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     -- Выбираем данные
     RETURN QUERY
     WITH tmpMI AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId                  AS UnitId   
                              , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                              , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                              , MovementItem.Amount 
                              , COALESCE (MIFloat_Price.ValueData, 0)  AS Price
                              , COALESCE (MIFloat_Area.ValueData, 0)   AS Area
                              , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                          FROM MovementItem

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
                                                               AND MILinkObject_CommentInfoMoney.DescId = zc_MILinkObject_CommentInfoMoney()  
                          WHERE MovementItem.Id = inId
                            AND MovementItem.DescId = zc_MI_Master()
                          )

           SELECT tmpMI.Id                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS NameFull
                
                , Object_InfoMoney.Id         AS Object_InfoMoneyId
                , Object_InfoMoney.ObjectCode AS Object_InfoMoneyCode
                , Object_InfoMoney.ValueData ::TVarChar AS Object_InfoMoneyName

                , Object_CommentInfoMoney.Id         AS Object_CommentInfoMoneyId
                , Object_CommentInfoMoney.ValueData ::TVarChar AS Object_CommentInfoMoneyName

                , Null           :: TDateTime AS DateStart
                , tmpMI.DateEnd  :: TDateTime AS DateEnd
                , tmpMI.Amount   :: TFloat    AS Amount
                , tmpMI.Price    :: TFloat    AS Price
                , tmpMI.Area     :: TFloat    AS Area
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull() 
           WHERE inId <> 0
        UNION
           SELECT 0                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS NameFull
                
                , Object_InfoMoney.Id         AS Object_InfoMoneyId
                , Object_InfoMoney.ObjectCode AS Object_InfoMoneyCode
                , Object_InfoMoney.ValueData ::TVarChar AS Object_InfoMoneyName

                , 0  AS Object_CommentInfoMoneyId
                , ''::TVarChar AS Object_CommentInfoMoneyName

                , inStartDate     :: TDateTime AS DateStart
                , inEndDate       :: TDateTime AS DateEnd
                , 0               :: TFloat    AS Amount
                , 0               :: TFloat    AS Price
                , 0               :: TFloat    AS Area   

           FROM Object AS Object_Unit
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = inInfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = Object_Unit.Id
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull() 
           WHERE inId = 0
             AND Object_Unit.Id = inUnitId
      ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.22         *
*/

-- тест
-- SELECT * FROM gpGet_MI_ServiceItem (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP, zfCalc_UserAdmin())
