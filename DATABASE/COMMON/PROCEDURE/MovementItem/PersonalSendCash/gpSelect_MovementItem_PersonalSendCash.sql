-- Function: gpSelect_MovementItem_PersonalSendCash (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalSendCash (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalSendCash (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalSendCash(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MIId_20401 Integer, MIId_21201 Integer
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , Amount_20401 TFloat, Amount_21201 TFloat
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar, CarModelName TVarChar
             , OperDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalSendCash());

     RETURN QUERY 
       SELECT
             tmpMovementItem.MIId_20401
           , tmpMovementItem.MIId_21201
           , tmpMovementItem.PersonalId
           , View_Personal.PersonalCode
           , View_Personal.PersonalName
         
           , CAST (tmpMovementItem.Amount_20401 AS TFloat) AS Amount_20401
           , CAST (tmpMovementItem.Amount_21201 AS TFloat) AS Amount_21201
           
           , Object_Route.Id         AS RouteId
           , Object_Route.ValueData  AS RouteName

           , Object_Car.Id              AS CarId
           , Object_Car.ValueData       AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName

           , tmpMovementItem.OperDate
           , tmpMovementItem.isErased

       FROM (SELECT MovementItem.ObjectId       AS PersonalId
                  , MovementItem.isErased       AS isErased
                  , MILinkObject_Route.ObjectId AS RouteId
                  , MILinkObject_Car.ObjectId   AS CarId
                  , MIDate_OperDate.ValueData   AS OperDate
                  , MAX (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_20401() THEN MovementItem.Id ELSE 0 END) AS MIId_20401
                  , MAX (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_21201() THEN MovementItem.Id ELSE 0 END) AS MIId_21201
                  , SUM (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_20401() THEN MovementItem.Amount ELSE 0 END) AS Amount_20401
                  , SUM (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_21201() THEN MovementItem.Amount ELSE 0 END) AS Amount_21201
             FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                  JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = tmpIsErased.isErased
                  LEFT JOIN MovementItemDate AS MIDate_OperDate
                                             ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                            AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                   ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                   ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
             GROUP BY MovementItem.ObjectId
                    , MovementItem.isErased
                    , MILinkObject_Route.ObjectId
                    , MILinkObject_Car.ObjectId
                    , MIDate_OperDate.ValueData
            ) AS tmpMovementItem
            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = tmpMovementItem.PersonalId
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovementItem.RouteId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpMovementItem.CarId

            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PersonalSendCash (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.11.13                                        * add OperDate
 21.10.13                                        * add CarModelName
 07.10.13                                        * add MIId_20401 and MIId_21201
 04.10.13                                        * add inIsErased
 30.09.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PersonalSendCash (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_PersonalSendCash (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
