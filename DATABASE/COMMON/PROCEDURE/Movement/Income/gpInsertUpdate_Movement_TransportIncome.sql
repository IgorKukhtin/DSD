-- Function: gpInsertUpdate_Movement_TransportIncome()

 DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportIncome (integer, integer, tvarchar, tdatetime, tdatetime, tvarchar, boolean, tfloat, tfloat, integer, integer, integer, tvarchar, integer, tvarchar, integer, tvarchar, integer, integer, integer, integer, tvarchar, tvarchar, tfloat, tfloat, tfloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportIncome(
    IN inParentId            Integer   , -- Ключ Master <Документ>
 INOUT ioMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
 INOUT ioOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inInvNumberPartner    TVarChar  , -- Номер чека
 INOUT ioPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
 INOUT ioVATPercent          TFloat    , -- % НДС
    IN inChangePrice         TFloat    , -- Скидка в цене
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
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
   OUT outAmountSummTotal    TFloat    , -- Сумма с НДС (итог)

    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportIncome());
     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TransportIncome());

     -- отбрасываем время
     inOperDate:= DATE_TRUNC ('DAY', inOperDate);
     ioOperDatePartner:= DATE_TRUNC ('DAY', ioOperDatePartner);

     -- проверка
     IF inOperDate < '01.10.2012'
     THEN
         RAISE EXCEPTION 'Ошибка.<Дата документа> %.', inOperDate;
     END IF;
     -- проверка
     IF ioOperDatePartner < '01.10.2012'
     THEN
         RAISE EXCEPTION 'Ошибка.<Дата у поставщика> %.', ioOperDatePartner;
     END IF;

     -- проверка
     IF COALESCE (inParentId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.<Путевой лист> не сохранен.';
     END IF;

     -- проверка
     IF COALESCE (inFromId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.<Источник заправки> не выбран.';
     END IF;

     -- проверка
     IF COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.<Автомобиль> не выбран.';
     END IF;


     -- для нового документа надо расчитать и вернуть свойства
     IF COALESCE (ioMovementId, 0) = 0 
     THEN
         -- для документа
         --
         -- расчитали свойство <Номер документа>
         ioInvNumber := CAST (NEXTVAL ('Movement_Income_seq') AS TVarChar);
         -- определили свойство из Default <Цена с НДС (да/нет)>
         ioPriceWithVAT := TRUE;
         -- определили свойство из Default <% НДС>
         ioVATPercent := 20;
         -- определили свойство из Default <Виды форм оплаты>
         IF COALESCE (ioPaidKindId, 0) = 0
         THEN
             ioPaidKindId := zc_Enum_PaidKind_FirstForm();
             ioPaidKindName := lfGet_Object_ValueData (ioPaidKindId);
         END IF;
         -- нашли свойство <Договор> у "Контрагента"
         IF COALESCE (ioContractId, 0) = 0
         THEN
             ioContractId := 0;
             ioContractName := lfGet_Object_ValueData (ioContractId);
         END IF;
         -- нашли свойство <Маршрут> у Master <Документа>
         IF COALESCE (ioRouteId, 0) =0
         THEN
             ioRouteId := (WITH tmpMI AS (SELECT * FROM MovementItem WHERE MovementId = inParentId AND DescId = zc_MI_Master() AND isErased = FALSE)
                           SELECT tmpMI.ObjectId FROM tmpMI ORDER BY tmpMI.Id LIMIT 1
                          );
             ioRouteId:= COALESCE (ioRouteId, 0);
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
             -- проверка - товар не может быть Талоном
             IF EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_TicketFuel_Goods() AND ChildObjectId = ioGoodsId)
              AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inFromId AND DescId = zc_Object_TicketFuel())
             THEN
                 RAISE EXCEPTION 'Ошибка.Операция для товара <%> здесь недопустима.', ioGoodsName;
             END IF;

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
         -- проверка - товар не может быть Талоном
         IF EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_TicketFuel_Goods() AND ChildObjectId = ioGoodsId)
          AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inFromId AND DescId = zc_Object_TicketFuel())
         THEN
             RAISE EXCEPTION 'Ошибка.Операция для товара <%> здесь недопустима.', ioGoodsName;
         END IF;

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

     -- проверка
     IF NOT EXISTS (SELECT MovementItem.ObjectId FROM MovementItem
                    WHERE MovementItem.MovementId = inParentId
                      AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                       AND MovementItem.ObjectId   = ioRouteId
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Выбранный <Маршрут> не найден в <Путевом листе>.';
     END IF;


     -- сохранили <Документ>
     ioMovementId := lpInsertUpdate_Movement_IncomeFuel (ioId               := ioMovementId
                                                       , inParentId         := inParentId
                                                       , inInvNumber        := ioInvNumber
                                                       , inOperDate         := inOperDate
                                                       , inOperDatePartner  := ioOperDatePartner
                                                       , inInvNumberPartner := inInvNumberPartner
                                                       , inPriceWithVAT     := ioPriceWithVAT
                                                       , inVATPercent       := ioVATPercent
                                                       , inChangePrice      := inChangePrice
                                                       , inFromId           := inFromId
                                                       , inToId             := inToId
                                                       , inPaidKindId       := ioPaidKindId
                                                       , inContractId       := ioContractId
                                                       , inRouteId          := ioRouteId
                                                       , inPersonalDriverId := inPersonalDriverId
                                                       , inAccessKeyId      := vbAccessKeyId 
                                                       , inUserId           := vbUserId
                                                        );

     -- сохранили <Элемент документа> и вернули параметры
     SELECT tmp.ioId, tmp.ioPrice, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioMovementItemId, ioPrice, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_IncomeFuel (ioId            := ioMovementItemId
                                                , inMovementId    := ioMovementId
                                                , inGoodsId       := ioGoodsId
                                                , inAmount        := inAmount
                                                , ioPrice         := ioPrice
                                                , ioCountForPrice := ioCountForPrice
                                                , inUserId        := vbUserId
                                                 ) AS tmp;


-- if vbUserId = 5
-- then
--     RAISE EXCEPTION 'Ошибка.1';
-- end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 31.10.13                                        * add ioOperDatePartner
 26.10.13                                        * отбрасываем время
 23.10.13                                        * add NEXTVAL
 19.10.13                                        * add inChangePrice
 07.10.13                                        * add lpCheckRight
 05.10.13                                        *
*/

-- update MovementItemContainer set OperDate = DATE_TRUNC ('DAY', OperDate) where DATE_TRUNC ('DAY', OperDate) <> OperDate;
-- update Movement set OperDate = DATE_TRUNC ('DAY', OperDate) where DATE_TRUNC ('DAY', OperDate) <> OperDate;

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransportIncome (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePrice:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
-- select * from gpInsertUpdate_Movement_TransportIncome(inParentId := 15468942 , ioMovementId := 0 , ioInvNumber := '' , inOperDate := ('01.12.2019')::TDateTime , ioOperDatePartner := ('12.12.2019')::TDateTime , inInvNumberPartner := '' , ioPriceWithVAT := 'False' , ioVATPercent := 0 , inChangePrice := 4.2 , inFromId := 1002038 , inToId := 1002064 , ioPaidKindId := 4 , ioPaidKindName := 'Нал' , ioContractId := 880397 , ioContractName := 'П041652' , ioRouteId := 0 , ioRouteName := '' , inPersonalDriverId := 956811 , ioMovementItemId := 0 , ioGoodsId := 8124 , ioGoodsCode := 7001 , ioGoodsName := 'бензин А-92' , ioFuelName := 'Бензин' , inAmount := 40.33 , ioPrice := 28.99 , ioCountForPrice := 0 , inSession:= zfCalc_UserAdmin());
