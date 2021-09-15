-- Function: gpGet_Movement_OrderGoodsDetail()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderGoodsDetail (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderGoodsDetail(
    IN inParentId        Integer  , -- ключ Документа OrderGoods
    IN inOperDate        TDateTime, -- дата Документа
    IN inSession         TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , OperDateStart TDateTime, OperDateEnd TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderGoodsDetail());
     vbUserId:= lpGetUserBySession (inSession);

     inOperDate := DATE_TRUNC('MONTH',inOperDate);

     -- !!! 5 НЕДЕЛЬ  от последнего дня пред месяца.!!!
     vbStartDate := (inOperDate - ((5 * 7) :: TVarChar || ' DAY') :: INTERVAL) ::TDateTime;
     vbEndDate   := (inOperDate - INTERVAL '1 DAY')  ::TDateTime;

     IF COALESCE (inParentId, 0) = 0 OR NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_OrderGoodsDetail() AND Movement.StatusId <> zc_Enum_Status_Erased())
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , vbStartDate ::TDateTime AS OperDateStart
             , vbEndDate ::TDateTime AS OperDateEnd
          ;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                            AS Id
           , MovementDate_OperDateStart.ValueData   AS OperDateStart
           , MovementDate_OperDateEnd.ValueData     AS OperDateEnd
       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
       WHERE Movement.ParentId = inParentId
         AND Movement.DescId = zc_Movement_OrderGoodsDetail()
         AND Movement.StatusId <> zc_Enum_Status_Erased();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.21         * 
*/

-- тест
--SELECT * FROM gpGet_Movement_OrderGoodsDetail (inParentId:=20242962 , inOperDate:= CURRENT_DATE, inSession:= '9818')

--20242962 
