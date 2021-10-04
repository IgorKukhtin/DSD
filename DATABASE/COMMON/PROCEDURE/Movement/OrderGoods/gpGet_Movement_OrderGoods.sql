-- Function: gpGet_Movement_OrderGoods()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderGoods (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderGoods(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, MonthName TVarChar
             , StatusCode Integer, StatusName TVarChar
             , OrderPeriodKindId Integer, OrderPeriodKindName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderGoods());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_OrderGoods_seq') AS TVarChar) AS InvNumber
             , DATE_TRUNC ('Month',inOperDate)       ::TDateTime AS OperDate
             , zfCalc_MonthName (inOperDate)         ::TVarChar AS MonthName
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName

             , Object_OrderPeriodKind.Id                        AS OrderPeriodKindId
             , Object_OrderPeriodKind.ValueData                 AS OrderPeriodKindName
             , Object_PriceList.Id                              AS PriceListId
             , Object_PriceList.ValueData                       AS PriceListName

             , Object_Unit.Id                                   AS UnitId
             , Object_Unit.ValueData                            AS UnitName

             , CAST ('' AS TVarChar) 		                AS Comment
             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP        ::TDateTime             AS InsertDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert          ON Object_Insert.Id          = vbUserId
              LEFT JOIN Object AS Object_PriceList       ON Object_PriceList.Id       = zc_PriceList_Basis()
              LEFT JOIN Object AS Object_OrderPeriodKind ON Object_OrderPeriodKind.Id = zc_Enum_OrderPeriodKind_Month()
              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = 8459 --"Склад Реализации"
          ;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate ::TDateTime          AS OperDate
           , zfCalc_MonthName (Movement.OperDate) ::TVarChar AS MonthName
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName

           , Object_OrderPeriodKind.Id              AS OrderPeriodKindId
           , Object_OrderPeriodKind.ValueData       AS OrderPeriodKindName

           , Object_PriceList.Id         ::Integer  AS PriceListId
           , Object_PriceList.ValueData  ::TVarChar AS PriceListName

           , Object_Unit.Id                         AS UnitId
           , Object_Unit.ValueData                  AS UnitName

           , MovementString_Comment.ValueData       AS Comment

           , Object_Insert.ValueData                AS InsertName
           , MovementDate_Insert.ValueData          AS InsertDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderPeriodKind
                                         ON MovementLinkObject_OrderPeriodKind.MovementId = Movement.Id
                                        AND MovementLinkObject_OrderPeriodKind.DescId = zc_MovementLinkObject_OrderPeriodKind()
            LEFT JOIN Object AS Object_OrderPeriodKind ON Object_OrderPeriodKind.Id = MovementLinkObject_OrderPeriodKind.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderGoods();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.21         * 
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderGoods (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= '9818')
