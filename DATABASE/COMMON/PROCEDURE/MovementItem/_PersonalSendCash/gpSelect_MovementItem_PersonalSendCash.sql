-- Function: gpSelect_MovementItem_PersonalSendCash()

-- DROP FUNCTION gpSelect_MovementItem_PersonalSendCash (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalSendCash(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , Amount_20401 TFloat, Amount_21201 TFloat
             , RouteId Integer, RouteName TVarChar 
             , CarId Integer, CarName TVarChar 
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PersonalSendCash());

     RETURN QUERY 
       SELECT
             Object_Personal.Id          AS PersonalId
           , Object_Personal.ObjectCode  AS PersonalCode
           , Object_Personal.ValueData   AS PersonalName
         
           , CAST (tmpMovementItem.Amount_20401 AS TFloat) AS Amount_20401
           , CAST (tmpMovementItem.Amount_21201 AS TFloat) AS Amount_21201
           
           , Object_Route.Id         AS RouteId
           , Object_Route.ValueData  AS RouteName

           , Object_Route.Id         AS CarId
           , Object_Route.ValueData  AS CarName

           , tmpMovementItem.isErased

       FROM (SELECT MovementItem.ObjectId       AS PersonalId
                  , MovementItem.isErased       AS isErased
                  , MILinkObject_Route.ObjectId AS RouteId
                  , MILinkObject_Car.ObjectId   AS CarId
                  , SUM (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_20401() THEN MovementItem.Amount ELSE 0 END) AS Amount_20401
                  , SUM (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_21201() THEN MovementItem.Amount ELSE 0 END) AS Amount_21201
             FROM MovementItem
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                   ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                   ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Car.DescId = zc_MILinkObject_Route()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId =  zc_MI_Master()
             GROUP BY MovementItem.ObjectId
                    , MovementItem.isErased
                    , MILinkObject_Route.ObjectId
                    , MILinkObject_Car.ObjectId
            ) AS tmpMovementItem
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpMovementItem.PersonalId
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovementItem.RouteId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpMovementItem.CarId
      ;
 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PersonalSendCash (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PersonalSendCash (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_PersonalSendCash (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
