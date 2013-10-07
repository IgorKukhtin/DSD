-- Function: gpInsertUpdate_Movement_TransportIncome()

-- DROP FUNCTION gpInsertUpdate_Movement_TransportIncome();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportIncome(
    IN inParentId            Integer   , -- Ключ Master <Документ>
 INOUT ioMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер чека
 INOUT ioOperDate            TDateTime , -- Дата документа
 INOUT ioPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
 INOUT ioVATPercent          TFloat    , -- % НДС
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
 INOUT ioPaidKindId          Integer   , -- Ключ Виды форм оплаты 
 INOUT ioPaidKindName        TVarChar  , -- Название Виды форм оплаты 
 INOUT ioContractId          Integer   , -- Ключ Договора
 INOUT ioContractName        TVarChar  , -- Название Договора
 INOUT ioRouteId             Integer   , -- Ключ Маршрут
 INOUT ioRouteName           TVarChar  , -- Название Маршрут
    IN inPersonalDriverId    Integer   , -- Сотрудник (водитель)

 INOUT ioMovementItemId      Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioGoodsId             Integer   , -- Ключ Товар
 INOUT ioGoodsCode           Integer   , -- Код Товар
 INOUT ioGoodsName           TVarChar  , -- Название Товар
 INOUT ioFuelName            TVarChar  , -- Название Вид топлива
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
   OUT outAmountSummTotal    TFloat    , -- Сумма с НДС (итог)

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportIncome());

     -- проверка
     IF COALESCE (inParentId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Путевой лист не сохранен.';
     END IF;

     -- проверка
     IF COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Автомобиль не выбран.';
     END IF;

     -- проверка
     IF ioRouteId <> 0
     THEN
         IF NOT EXISTS (SELECT MovementItem.ObjectId FROM MovementItem
                        WHERE MovementItem.MovementId = inParentId
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                          AND MovementItem.ObjectId   = ioRouteId
                        )
         THEN
             RAISE EXCEPTION 'Ошибка.Выбранный <Маршрут> не найден в <Путевом листе>.';
         END IF;
     END IF;



     -- для нового документа надо расчитать и вернуть свойства
     IF COALESCE (ioMovementId, 0) = 0 
     THEN
         -- для документа
         --
         -- расчитали свойство <Номер документа>
         ioInvNumber := lfGet_InvNumber (0, zc_Movement_Income());
         -- определили свойство из Default <Цена с НДС (да/нет)>
         ioPriceWithVAT := FALSE;
         -- определили свойство из Default <% НДС>
         ioVATPercent := 20;
         -- определили свойство из Default <Виды форм оплаты>
         IF COALESCE (ioPaidKindId, 0) = 0
         THEN
             ioPaidKindId := zc_Enum_PaidKind_FirstForm();
             ioPaidKindName := lfGet_Object_ValueData (ioPaidKindId);
         END IF;
         -- нашли свойство <Договора> у "Контрагента"
         IF COALESCE (ioContractId, 0) =0
         THEN
             ioContractId := 0;
             ioContractName := lfGet_Object_ValueData (ioContractId);
         END IF;
         -- нашли свойство <Маршрут> у Master <Документа>
         IF COALESCE (ioRouteId, 0) =0
         THEN
             ioRouteId := (SELECT MovementItem.ObjectId
                           FROM (SELECT MIN (Id) AS Id FROM MovementItem WHERE MovementId = inParentId AND DescId = zc_MI_Master() AND isErased = FALSE
                                ) AS tmpMI
                                JOIN MovementItem ON MovementItem.Id = tmpMI.Id
                          );
             ioRouteName := lfGet_Object_ValueData (ioRouteId);
         END IF;
         -- нашли свойство <Сотрудник (водитель)> у Master <Документа>
         inPersonalDriverId := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inParentId AND DescId = zc_MovementLinkObject_PersonalDriver());
         --
         -- теперь для строки
         --
         -- нашли свойство <Товар> и <Вид топлива> для Автомобиля
         IF COALESCE (ioGoodsId, 0) =0
         THEN
             SELECT Object_Goods.Id             AS GoodsId
                  , COALESCE (Object_Goods.ObjectCode, 0) AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_FuelMaster.ValueData AS FuelName
                    INTO ioGoodsId, ioGoodsCode, ioGoodsName, ioFuelName
             FROM ObjectLink AS ObjectLink_Car_FuelMaster
                  LEFT JOIN Object AS Object_FuelMaster ON Object_FuelMaster.Id = ObjectLink_Car_FuelMaster.ChildObjectId
                  LEFT JOIN (SELECT ChildObjectId AS FuelId, MAX (ObjectId) AS GoodsId FROM ObjectLink WHERE DescId = zc_ObjectLink_Goods_Fuel() GROUP BY ChildObjectId
                            ) AS tmpGoods ON tmpGoods.FuelId = ObjectLink_Car_FuelMaster.ChildObjectId
                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
             WHERE ObjectLink_Car_FuelMaster.ObjectId = inToId
               AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster();

             -- проверка
             IF COALESCE (ioFuelName, '') = ''
             THEN
                 RAISE EXCEPTION 'Ошибка.Не определен <Основной вид топлива> у <Автомобиля>.';
             END IF;

             -- проверка
             IF COALESCE (ioGoodsId, 0) = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Не определен <Товар> для вида топлива <%>.', ioFuelName;
             END IF;

         ELSE
             -- нашли свойство <Вид топлива> для <Товар> (это что б проверить у товара должен быть вид топлива)
             SELECT Object_Goods.ValueData AS GoodsName
                  , Object_Fuel.ValueData  AS FuelName
                    INTO ioGoodsName, ioFuelName
             FROM ObjectLink AS ObjectLink_Goods_Fuel
                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Fuel.ObjectId
                  LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
             WHERE ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                AND ObjectLink_Goods_Fuel.ObjectId = ioGoodsId;
             -- проверка
             IF COALESCE (ioFuelName, '') = ''
             THEN
                 RAISE EXCEPTION 'Ошибка.Не определен <Вид топлива> у товара <%>.', ioGoodsName;
             END IF;
         END IF;

     ELSE
         -- нашли свойство <Вид топлива> для <Товар> (это что б проверить у товара должен быть вид топлива)
         SELECT Object_Goods.ValueData AS GoodsName
              , Object_Fuel.ValueData  AS FuelName
                INTO ioGoodsName, ioFuelName
         FROM ObjectLink AS ObjectLink_Goods_Fuel
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Fuel.ObjectId
              LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
         WHERE ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
            AND ObjectLink_Goods_Fuel.ObjectId = ioGoodsId;
         -- проверка
         IF COALESCE (ioFuelName, '') = ''
         THEN
             RAISE EXCEPTION 'Ошибка.Не определен <Вид топлива> у товара <%>.', ioGoodsName;
         END IF;
     END IF;

     -- сохранили <Документ>
     ioMovementId := lpInsertUpdate_Movement_IncomeFuel (ioId               := ioMovementId
                                                       , inParentId         := inParentId
                                                       , inInvNumber        := ioInvNumber
                                                       , inInvNumberPartner := inInvNumberPartner
                                                       , inOperDate         := ioOperDate
                                                       , inPriceWithVAT     := ioPriceWithVAT
                                                       , inVATPercent       := ioVATPercent
                                                       , inFromId           := inFromId
                                                       , inToId             := inToId
                                                       , inPaidKindId       := ioPaidKindId
                                                       , inContractId       := ioContractId
                                                       , inRouteId          := ioRouteId
                                                       , inPersonalDriverId := inPersonalDriverId
                                                       , inUserId           := vbUserId 
                                                        );

     -- сохранили <Элемент документа> и вернули параметры
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioMovementItemId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_IncomeFuel (ioId            := ioMovementItemId
                                                , inMovementId    := ioMovementId
                                                , inGoodsId       := ioGoodsId
                                                , inAmount        := inAmount
                                                , inPrice         := inPrice
                                                , ioCountForPrice := ioCountForPrice
                                                , inUserId        := vbUserId
                                                 ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.13                                        * add lpCheckRight
 05.10.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransportIncome (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
