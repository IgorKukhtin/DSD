-- Function: gpSelect_MovementItem_TransportPersonalSendCash (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_TransportPersonalSendCash (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_TransportPersonalSendCash(
    IN inParentId    Integer      , -- Ключ Master <Документ>
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PersonalId_From Integer, PersonalCode_From Integer, PersonalName_From TVarChar
             , PersonalId_To Integer, PersonalCode_To Integer, PersonalName_To TVarChar
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar, CarModelName TVarChar
             , Amount_20401 TFloat, Amount_21201 TFloat
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
       SELECT
             tmpMovement.MovementId AS Id
           , zfConvert_StringToNumber (tmpMovement.InvNumber) AS InvNumber
           , tmpMovement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , View_PersonalFrom.PersonalId   AS PersonalId_From
           , View_PersonalFrom.PersonalCode AS PersonalCode_From
           , View_PersonalFrom.PersonalName AS PersonalName_From
           , View_PersonalTo.PersonalId     AS PersonalId_To
           , View_PersonalTo.PersonalCode   AS PersonalCode_To
           , View_PersonalTo.PersonalName   AS PersonalName_To

           , Object_Route.Id            AS RouteId
           , Object_Route.ValueData     AS RouteName
           , Object_Car.Id              AS CarId
           , Object_Car.ValueData       AS CarName
           , Object_CarModel.ValueData  AS CarModelName

           , CAST (tmpMovement.Amount_20401 AS TFloat) AS Amount_20401
           , CAST (tmpMovement.Amount_21201 AS TFloat) AS Amount_21201

       FROM Movement AS Movement_Parent
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement_Parent.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Parent.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalTo ON View_PersonalTo.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN (SELECT Movement.Id AS MovementId
                            , Movement.StatusId
                            , Movement.InvNumber
                            , Movement.OperDate
                            , MovementItem.ObjectId       AS PersonalId_To
                            , MILinkObject_Car.ObjectId   AS CarId
                            , MILinkObject_Route.ObjectId AS RouteId
                            , MovementLinkObject_Personal.ObjectId AS PersonalId_From
                            , SUM (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_20401() THEN MovementItem.Amount ELSE 0 END) AS Amount_20401
                            , SUM (CASE WHEN MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_21201() THEN MovementItem.Amount ELSE 0 END) AS Amount_21201
                       FROM Movement AS Movement_Parent
                            JOIN Movement ON Movement.OperDate = Movement_Parent.OperDate
                                         AND Movement.DescId = zc_Movement_PersonalSendCash()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                         ON MovementLinkObject_Car.MovementId = Movement_Parent.Id
                                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Parent.Id
                                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.ObjectId   = MovementLinkObject_PersonalDriver.ObjectId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = FALSE
                            JOIN MovementItemLinkObject AS MILinkObject_Car
                                                        ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Car.DescId         = zc_MILinkObject_Car()
                                                       AND MILinkObject_Car.ObjectId       = MovementLinkObject_Car.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                             ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                       WHERE Movement_Parent.DescId = zc_Movement_Transport()
                         AND Movement_Parent.Id     = inParentId
                       GROUP BY Movement.Id
                              , Movement.StatusId
                              , Movement.InvNumber
                              , Movement.OperDate
                              , MovementItem.ObjectId
                              , MILinkObject_Car.ObjectId
                              , MILinkObject_Route.ObjectId
                              , MovementLinkObject_Personal.ObjectId
                      ) AS tmpMovement ON tmpMovement.PersonalId_To = MovementLinkObject_PersonalDriver.ObjectId
                                      AND tmpMovement.CarId         = MovementLinkObject_Car.ObjectId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId

            LEFT JOIN Object_Personal_View AS View_PersonalFrom ON View_PersonalFrom.PersonalId = tmpMovement.PersonalId_From

            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

      WHERE Movement_Parent.DescId = zc_Movement_Transport()
        AND Movement_Parent.Id = inParentId;
  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_TransportPersonalSendCash (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_TransportPersonalSendCash (inParentId:= 104, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
