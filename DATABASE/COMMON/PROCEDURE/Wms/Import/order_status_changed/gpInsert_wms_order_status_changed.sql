-- Function: gpInsert_wms_order_status_changed()

DROP FUNCTION IF EXISTS lpGetGoodsId_for_sku_id (Integer);
DROP FUNCTION IF EXISTS gpInsert_movement_wms_scale_packet (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_wms_order_status_changed (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_wms_order_status_changed (
    IN inOrderId    Integer,  -- Наш Id заявки -> Movement.Id
    IN inSession    TVarChar  -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , InvNumber             TVarChar
             , OperDate              TDateTime
--             , InvNumberPartner      TVarChar
             , FromId         Integer, FromCode         Integer, FromName       TVarChar
             , ToId           Integer, ToCode           Integer, ToName         TVarChar
--             , PaidKindId     Integer, PaidKindName   TVarChar
--             , PriceListId     Integer, PriceListCode     Integer, PriceListName     TVarChar
              )
AS
$BODY$
   DEClARE vbMovementId Integer;
BEGIN
     -- !!!заменили!!!
     inSession:= '6044123'; -- Авто-Загрузка WMS

     -- создали Документ
     vbMovementId := lpInsert_wms_order_status_changed_Movement (ioMovementId := 0
                                                               , inOrderId    := inOrderId
                                                               , inSession    := inSession
                                                                );
     -- создали Строчную часть
     PERFORM lpInsert_wms_order_status_changed_MI (inMovementId := vbMovementId
                                                 , inOrderId    := inOrderId
                                                 , inSession    := inSession
                                                  );
     -- отметили что сообщения обработаны
     UPDATE wms_to_host_message SET Done = TRUE, UpdateDate = CLOCK_TIMESTAMP() WHERE wms_to_host_message.MovementId = inOrderId :: TVarChar;
     

  --RAISE EXCEPTION 'Ошибка.<%>', (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = vbMovementId AND MF.DescId = zc_MovementFloat_BranchCode());


     --
     PERFORM gpInsert_Scale_Movement_all (inBranchCode          := 1
                                        , inMovementId          := vbMovementId
                                        , inOperDate            := (SELECT gpGet_Scale_OperDate (FALSE, 1, inSession))
                                        , inSession             := inSession
                                         );

   --RAISE EXCEPTION 'Test-1 = end';


    -- Результат
    RETURN QUERY
     SELECT Movement.Id AS MovementId
          , Movement.InvNumber
          , Movement.OperDate
          , Object_From.Id AS FromId, Object_From.ObjectCode AS FromCode, Object_From.ValueData AS FromName
          , Object_To.Id   AS ToId,   Object_To.ObjectCode   AS ToCode,   Object_To.ValueData   AS ToName
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN Object AS Object_To   ON Object_To.Id   = MovementLinkObject_To.ObjectId
     WHERE Movement.Id = vbMovementId;

  --RAISE EXCEPTION 'Test = end';


END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 04.06.20                                        *
 03.06.20                                                          *
*/

-- тест
-- SELECT * FROM gpInsert_wms_order_status_changed (inOrderId:= 18341184, inSession:= zfCalc_UserAdmin())
