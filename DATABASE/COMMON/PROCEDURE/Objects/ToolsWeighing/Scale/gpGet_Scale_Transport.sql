-- Function: gpGet_Scale_Transport()

DROP FUNCTION IF EXISTS gpGet_Scale_Transport (TDateTime, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Transport(
    IN inOperDate          TDateTime   ,
    IN inBranchCode        Integer     , --
    IN inBarCode           TVarChar    ,
    IN inMovementId_order  Integer     , --
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , BarCode               TVarChar
             , InvNumber             TVarChar
             , PersonalDriverId      Integer
             , PersonalDriverName    TVarChar
             , CarName               TVarChar
             , RouteName             TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbBranchId   Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
   -- сразу запомнили время начала выполнения Проц.
   vbOperDate_Begin1:= CLOCK_TIMESTAMP();

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


    -- определяется
    vbBranchId:= CASE WHEN inBranchCode > 100 THEN zc_Branch_Basis()
                      ELSE (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBranchCode and Object.DescId = zc_Object_Branch())
                 END;

    -- Результат
    RETURN QUERY
       WITH tmpMovement AS (SELECT tmpMovement.Id
                                 , tmpMovement.InvNumber
                                 , tmpMovement.OperDate
                                 , COALESCE (MILinkObject_Route.ObjectId, CASE WHEN tmpMovement.DescId = zc_Movement_Transport() THEN MovementItem.ObjectId END) AS RouteId
                                 , COALESCE (MILinkObject_Car.ObjectId, MovementLinkObject_Car.ObjectId) AS CarId
                                 , COALESCE (MovementLinkObject_PersonalDriver.ObjectId, CASE WHEN tmpMovement.DescId = zc_Movement_TransportService() THEN MovementItem.ObjectId END) AS PersonalDriverId
                            FROM (SELECT Movement.Id
                                       , Movement.DescId
                                       , Movement.InvNumber
                                       , Movement.OperDate
                                  FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS MovementId WHERE CHAR_LENGTH (inBarCode) >= 13
                                       ) AS tmp
                                       INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                          AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
                                                          AND Movement.OperDate BETWEEN inOperDate - INTERVAL '30 DAY' AND inOperDate + INTERVAL '30 DAY'
                                                          AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 ) AS tmpMovement
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                                        ON MovementLinkObject_Route.MovementId = inMovementId_order
                                                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                                                        ON MovementLinkObject_Car.MovementId = tmpMovement.Id
                                                                       AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                                                        ON MovementLinkObject_PersonalDriver.MovementId = tmpMovement.Id
                                                                       AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()

                                           LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                                                 AND (MovementItem.ObjectId  = MovementLinkObject_Route.ObjectId OR tmpMovement.DescId = zc_Movement_TransportService() OR inMovementId_order = 0)
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                                                            ON MILinkObject_Route.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
                                                                           AND (MILinkObject_Route.ObjectId = MovementLinkObject_Route.ObjectId OR inMovementId_order = 0)
                                                                           AND tmpMovement.DescId = zc_Movement_TransportService()
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                                            ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
                                                                           AND tmpMovement.DescId = zc_Movement_TransportService()
                           )
       SELECT tmpMovement.Id                  AS MovementId
            , inBarCode                       AS BarCode
            , ('№ <' || tmpMovement.InvNumber || '>' || ' от <' || DATE (tmpMovement.OperDate) :: TVarChar || '>') :: TVarChar AS InvNumber
            , Object_PersonalDriver.Id        AS PersonalDriverId
            , Object_PersonalDriver.ValueData AS PersonalDriverName
            , (COALESCE (Object_Car.ValueData, '') || ' ' || COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '')) :: TVarChar AS CarName   
            
            , Object_Route.ValueData          AS RouteName
       FROM tmpMovement
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = tmpMovement.PersonalDriverId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpMovement.CarId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId
      ;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
   /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpGet_Scale_Transport'
               -- ProtocolData
             , zfConvert_DateToString (inOperDate)
    || ', ' || inBranchCode :: TVarChar
    || ', ' || inBarCode
    || ', ' || inMovementId_order :: TVarChar
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_Transport (TDateTime, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.08.15                                        *
*/

-- тест

-- SELECT * FROM gpGet_Scale_Transport (inOperDate:= ('31.08.2015')::TDateTime, inBranchCode:= 1, inBarCode:= '202002205973', inMovementId_order:= 2214230, inSession := zfCalc_UserAdmin());
-- SELECT * FROM gpGet_Scale_Transport (inOperDate:= ('31.08.2015')::TDateTime, inBranchCode:= 1, inBarCode:= '2020021977936', inMovementId_order:= 2214230, inSession := zfCalc_UserAdmin());
