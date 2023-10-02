-- Function: gpInsertUpdate_Movement_TransportGoods_byTransport ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportGoods_byTransport (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportGoods_byTransport(
    IN inMovementId_Sale               Integer  , --
    IN inMovementId_TransportGoods     Integer  ,
   OUT outMovementId_TransportGoods    Integer  ,
    IN inMovementId_Transport          Integer  ,
    
    IN inSession                       TVarChar    -- сессия пользователя

)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId       Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     --проверка 
     IF COALESCE (inMovementId_Transport,0) = 0
     THEN   
          RAISE EXCEPTION 'Ошибка. Не выбран документ Путевого листа'; 
     END IF;
     
     -- если нет ТТН - создаем
     outMovementId_TransportGoods:= 
                         lpInsertUpdate_Movement_TransportGoods (ioId              := tmpTransportGoods.Id         ::Integer
                                                               , inInvNumber       := tmpTransportGoods.InvNumber  ::TVarChar
                                                               , inOperDate        := tmpTransportGoods.OperDate   ::TDateTime
                                                               , inMovementId_Sale := inMovementId_Sale
                                                               , inInvNumberMark   := tmpTransportGoods.InvNumberMark ::TVarChar
                                                               , inCarId           := (SELECT MLO.ObjectId                      --машина з Шляхового листа
                                                                                       FROM MovementLinkObject AS MLO
                                                                                       WHERE MLO.MovementId = inMovementId_Transport
                                                                                         AND MLO.DescId = zc_MovementLinkObject_Car()
                                                                                       )
                                                               , inCarTrailerId    := (SELECT MLO.ObjectId                      --причеп з Шляхового листа
                                                                                       FROM MovementLinkObject AS MLO
                                                                                       WHERE MLO.MovementId = inMovementId_Transport
                                                                                         AND MLO.DescId = zc_MovementLinkObject_CarTrailer()
                                                                                       )  ::Integer
                                                               , inPersonalDriverId:= (SELECT MLO.ObjectId                      --водій з Шляхового листа
                                                                                       FROM MovementLinkObject AS MLO
                                                                                       WHERE MLO.MovementId = inMovementId_Transport
                                                                                         AND MLO.DescId = zc_MovementLinkObject_PersonalDriver()
                                                                                       )
                                                               , inRouteId         := (SELECT MovementItem.ObjectId             --маршрут з Шляхового листа
                                                                                       FROM MovementItem
                                                                                       WHERE MovementItem.MovementId = inMovementId_Transport 
                                                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                                                         AND MovementItem.isErased   = FALSE
                                                                                       LIMIT 1
                                                                                       )
                                                                 -- отримав водій/експедитор - 1
                                                               , inMemberId1       := (SELECT MLO.ObjectId                      --водій з Шляхового листа
                                                                                       FROM MovementLinkObject AS MLO
                                                                                       WHERE MLO.MovementId = inMovementId_Transport
                                                                                         AND MLO.DescId = zc_MovementLinkObject_PersonalDriver()
                                                                                       )
                                                                 -- Бухгалтер (відповідальна особа вантажовідправника) - 2
                                                               , inMemberId2       := tmpTransportGoods.MemberId2
                                                                 -- Відпуск дозволив - 3
                                                               , inMemberId3       := tmpTransportGoods.MemberId3
                                                                 -- Здав (відповідальна особа вантажовідправника) - 4
                                                               , inMemberId4       := tmpTransportGoods.MemberId4
                                                                 -- Прийняв водій/експедитор - 1
                                                               , inMemberId5       := tmpTransportGoods.MemberId5
                                                                 -- Здав водій/експедитор - пусто ИЛИ 1
                                                               , inMemberId6       := tmpTransportGoods.MemberId6
                                                                 --  Прийняв (відповідальна особа вантажоодержувача) - пусто
                                                               , inMemberId7       := tmpTransportGoods.MemberId7
                                                                 --
                                                               , inUserId          := vbUserId
                                                                )
                          FROM  gpGet_Movement_TransportGoods(inMovementId      := inMovementId_TransportGoods :: Integer
                                                            , inMovementId_Sale := inMovementId_Sale           :: Integer  
                                                            , inOperDate        :=(SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Sale) :: TDateTime 
                                                            , inSession         := inSession :: TVarChar
                                                              ) AS tmpTransportGoods 
                        ;

   IF vbUserId = 9457 OR vbUserId = 5
   THEN
         RAISE EXCEPTION 'Тест. Ок. <%>', outMovementId_TransportGoods; 
   END IF; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.10.23         *
*/

-- тест
--