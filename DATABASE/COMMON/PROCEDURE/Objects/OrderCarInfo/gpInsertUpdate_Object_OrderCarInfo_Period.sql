-- Function: gpInsertUpdate_Object_OrderCarInfo_Period ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderCarInfo_Period (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderCarInfo_Period(
      IN inStartDate             TDateTime,
      IN inEndDate               TDateTime,
      IN inSession               TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderCarInfo());
   vbUserId:= lpGetUserBySession (inSession);

   CREATE TEMP TABLE _tmpData (RouteId Integer, RetailId Integer, UnitId Integer, OperDate TFloat, OperDatePartner TFloat, Days TFloat, Hour TFloat, Min TFloat, Ord Integer) ON COMMIT DROP;
   INSERT INTO _tmpData (RouteId, RetailId, UnitId, OperDate, OperDatePartner, Days, Hour, Min, Ord)
   WITH
       tmpMovementAll AS (SELECT Movement.*
                                 -- Дата/время отгрузки
                               , MovementDate_CarInfo.ValueData AS OperDate_CarInfo
                                 -- Дата смены
                               , CASE WHEN EXTRACT (HOUR FROM MovementDate_CarInfo.ValueData) < 8 THEN DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData) - INTERVAL '1 DAY'
                                      ELSE DATE_TRUNC ('DAY', MovementDate_CarInfo.ValueData)
                                 END  AS OperDate_CarInfo_date
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_CarInfo
                                                       ON MovementDate_CarInfo.MovementId = Movement.Id
                                                      AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()
                                                      AND MovementDate_CarInfo.ValueData >= inStartDate + INTERVAL '8 HOUR'
                                                      AND MovementDate_CarInfo.ValueData < inEndDate + INTERVAL '8 HOUR'
                          WHERE Movement.StatusId = zc_Enum_Status_Complete()
                            AND Movement.DescId = zc_Movement_OrderExternal()
                          )


     , tmpMovement AS (SELECT DISTINCT
                              Movement.OperDate
                            , MovementDate_OperDatePartner.ValueData AS OperDatePartner

                            , COALESCE (MovementLinkObject_Route.ObjectId, 0) AS RouteId
                            , CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId IS NULL AND MovementLinkObject_Route.ObjectId IS NULL
                                        THEN COALESCE (MovementLinkObject_From.ObjectId, 0)
                                   WHEN Object_From.DescId = zc_Object_Unit()
                                        THEN MovementLinkObject_From.ObjectId
                                   -- временно
                                   WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                                     OR Object_Route.ValueData ILIKE 'Самов%'
                                     OR Object_Route.ValueData ILIKE '%-колбаса'
                                     OR Object_Route.ValueData ILIKE '%Кривой Рог%'
                                        THEN 0
                                   ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0)
                              END AS RetailId
                            , MovementLinkObject_To.ObjectId AS UnitId

                            , MovementLinkObject_CarInfo.ObjectId                      AS CarInfoId
                            , Movement.OperDate_CarInfo                                AS OperDate_CarInfo
                            , Movement.OperDate_CarInfo_date                           AS OperDate_CarInfo_date

                       FROM tmpMovementAll AS Movement
                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()

					        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
                            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                       WHERE COALESCE (MovementLinkObject_Route.ObjectId,0) <> 0
                      )

       -- Результат
       SELECT DISTINCT
              tmpMovement.RouteId               AS RouteId
            , tmpMovement.RetailId              AS RetailId
            , tmpMovement.UnitId                AS UnitId

            --, tmpWeekDay.DayOfWeekName                   ::TVarChar AS OperDate
            --, tmpWeekDay_Partner.DayOfWeekName           ::TVarChar AS OperDatePartner
            , CASE EXTRACT (DOW FROM tmpMovement.OperDate) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM tmpMovement.OperDate) END               ::TFloat AS OperDate
            , CASE EXTRACT (DOW FROM tmpMovement.OperDatePartner) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM tmpMovement.OperDatePartner) END ::TFloat AS OperDatePartner

            , CASE WHEN tmpMovement.OperDate_CarInfo < tmpMovement.OperDatePartner
                        THEN -1 * EXTRACT (DAY FROM tmpMovement.OperDatePartner - DATE_TRUNC ('DAY', tmpMovement.OperDate_CarInfo))
                   WHEN tmpMovement.OperDatePartner < tmpMovement.OperDate_CarInfo
                        THEN  1 * EXTRACT (DAY FROM DATE_TRUNC ('DAY', tmpMovement.OperDate_CarInfo) - tmpMovement.OperDatePartner)
                   ELSE 0
              END :: Integer AS Days

            , EXTRACT (HOUR FROM tmpMovement.OperDate_CarInfo)   ::TFloat AS Hour
            , EXTRACT (MINUTE FROM tmpMovement.OperDate_CarInfo) ::TFloat AS Min
            , ROW_NUMBER() OVER (PARTITION BY tmpMovement.RouteId, tmpMovement.RetailId, tmpMovement.UnitId
                                            , CASE EXTRACT (DOW FROM tmpMovement.OperDate) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM tmpMovement.OperDate) END
                                            , CASE EXTRACT (DOW FROM tmpMovement.OperDatePartner) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM tmpMovement.OperDatePartner) END
                                 ORDER BY EXTRACT (HOUR FROM tmpMovement.OperDate_CarInfo) DESC
                                ) AS Ord

       FROM tmpMovement
      ;

   -- Сохраненные данные
   CREATE TEMP TABLE _tmpOrderCarInfo (Id Integer, RouteId Integer, RetailId Integer, UnitId Integer, OperDate TFloat, OperDatePartner TFloat) ON COMMIT DROP;
   INSERT INTO _tmpOrderCarInfo (Id, RouteId, RetailId, UnitId, OperDate, OperDatePartner)
    SELECT Object_OrderCarInfo.Id                                         AS Id
         , COALESCE (ObjectLink_Route.ChildObjectId, 0)                   AS RouteId
         , COALESCE (ObjectLink_Retail.ChildObjectId, 0)                  AS RetailId
         , COALESCE (ObjectLink_Unit.ChildObjectId, 0)                    AS UnitId
         , COALESCE (ObjectFloat_OperDate.ValueData, 0)        :: TFloat  AS OperDate
         , COALESCE (ObjectFloat_OperDatePartner.ValueData, 0) :: TFloat  AS OperDatePartner
    FROM Object AS Object_OrderCarInfo
            LEFT JOIN ObjectLink AS ObjectLink_Route
                                 ON ObjectLink_Route.ObjectId = Object_OrderCarInfo.Id
                                AND ObjectLink_Route.DescId = zc_ObjectLink_OrderCarInfo_Route()

            LEFT JOIN ObjectLink AS ObjectLink_Retail
                                 ON ObjectLink_Retail.ObjectId = Object_OrderCarInfo.Id
                                AND ObjectLink_Retail.DescId = zc_ObjectLink_OrderCarInfo_Retail()

            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_OrderCarInfo.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_OrderCarInfo_Unit()

        LEFT JOIN ObjectFloat AS ObjectFloat_OperDate
                              ON ObjectFloat_OperDate.ObjectId = Object_OrderCarInfo.Id
                             AND ObjectFloat_OperDate.DescId = zc_ObjectFloat_OrderCarInfo_OperDate()
        LEFT JOIN ObjectFloat AS ObjectFloat_OperDatePartner
                              ON ObjectFloat_OperDatePartner.ObjectId = Object_OrderCarInfo.Id
                             AND ObjectFloat_OperDatePartner.DescId = zc_ObjectFloat_OrderCarInfo_OperDatePartner()

    WHERE Object_OrderCarInfo.DescId = zc_Object_OrderCarInfo()
      AND Object_OrderCarInfo.isErased = FALSE
    ;

   -- сохранили <Объект>
   PERFORM lpInsertUpdate_Object_OrderCarInfo (ioId	      := COALESCE (_tmpOrderCarInfo.Id, 0)
                                             , inRouteId  := _tmpData.RouteId
                                             , inRetailId := _tmpData.RetailId
                                             , inUnitId   := _tmpData.UnitId
                                             , inOperDate := _tmpData.OperDate
                                             , inOperDatePartner := _tmpData.OperDatePartner
                                             , inDays     := _tmpData.Days
                                             , inHour     := _tmpData.Hour
                                             , inMin      := _tmpData.Min
                                             , inUserId   := vbUserId
                                              )
   FROM _tmpData
        LEFT JOIN _tmpOrderCarInfo ON COALESCE (_tmpOrderCarInfo.RouteId, 0) = COALESCE (_tmpData.RouteId, 0)
                                  AND COALESCE (_tmpOrderCarInfo.RetailId,0) = COALESCE (_tmpData.RetailId, 0)
                                  AND COALESCE (_tmpOrderCarInfo.UnitId, 0) = COALESCE (_tmpData.UnitId, 0)
                                  AND _tmpOrderCarInfo.OperDate = _tmpData.OperDate
                                  AND _tmpOrderCarInfo.OperDatePartner = _tmpData.OperDatePartner
   WHERE _tmpData.Ord = 1
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.22         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_OrderCarInfo()