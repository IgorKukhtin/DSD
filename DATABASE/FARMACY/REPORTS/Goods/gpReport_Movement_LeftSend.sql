-- Function: gpReport_Movement_LeftSend()

DROP FUNCTION IF EXISTS gpReport_Movement_LeftSend (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_LeftSend(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , ReturnRate TFloat, TotalCount TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- 1. Результат работы
     CREATE TEMP TABLE _tmpResult  (Id Integer, InventID Integer, ReturnRate TFloat ) ON COMMIT DROP;

     -- 2. Инвентаризации
     CREATE TEMP TABLE _tmpInvent  (Id Integer) ON COMMIT DROP;

     -- 3. Все что получили
     CREATE TEMP TABLE _tmpWasGot (Id Integer, InventID Integer, GoodsId Integer, Amount TFloat, AmountReturn  TFloat) ON COMMIT DROP;

     --  4.Перемещения отправителя
     CREATE TEMP TABLE _tmpWasSentMovement (Id Integer, InventID Integer) ON COMMIT DROP;


     PERFORM gpReport_Movement_LeftSendUnit(inInventID   := Movement.Id
                                          , inOperDate   := Movement.OperDate
                                          , inUnitID     := MovementLinkObject_Unit.ObjectId
                                          , inSession    := inSession)
     FROM Movement

          INNER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                     ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                    AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
                                    AND MovementBoolean_FullInvent.ValueData = TRUE

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                               AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.DescId = zc_Movement_Inventory()
       AND Movement.StatusId = zc_Enum_Status_Complete();


     -- Результат
     RETURN QUERY
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName
           , _tmpResult.ReturnRate                  AS ReturnRate
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm
           , Object_From.Id                         AS FromId
           , Object_From.ValueData                  AS FromName
           , Object_To.Id                           AS ToId
           , Object_To.ValueData                    AS ToName
           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment

           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
       FROM _tmpResult

            LEFT JOIN Movement ON Movement.id = _tmpResult.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Movement_LeftSend (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.08.20                                                       *
*/

-- тест
-- SELECT * FROM gpReport_Movement_LeftSend (inStartDate:= '21.09.2019', inEndDate:= '21.09.2019', inSession:= '3')