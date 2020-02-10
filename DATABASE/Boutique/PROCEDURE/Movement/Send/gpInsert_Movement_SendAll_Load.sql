-- Function: gpInsert_Movement_SendAll_Load()

DROP FUNCTION IF EXISTS gpInsert_Movement_SendAll_Load (TDateTime, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_SendAll_Load(
    IN inOperDate              TDateTime ,
    IN inObjectCode            Integer   , -- код товара
    IN inAmount                TFloat    , -- кол-во
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbGoodsId            Integer;
   DECLARE vbPartionId          Integer;
   DECLARE vbUnitFromId         Integer;
   DECLARE vbUnitToId           Integer;
   DECLARE vbMovementId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);

     -- вносим данне только где остаток <> 0
     IF COALESCE (inAmount, 0) = 0
     THEN
         -- !!!ВЫХОД!!!
         RETURN;
     END IF;


     -- определяем подразделения
     vbUnitFromId := 6318; -- магазин PODIUM 
     vbUnitToId   := 6319; -- магазин Киев

/*     vbUnitFromId := (SELECT Object.Id
                      FROM Object
                      WHERE Object.DescId = zc_Object_Unit()
                         AND TRIM (Object.ValueData) ILIKE TRIM ('%магазин PODIUM%') -- магазин PODIUM 
                      );
     vbUnitToId := (SELECT Object.Id
                    FROM Object
                    WHERE Object.DescId = zc_Object_Unit()
                       AND TRIM (Object.ValueData) ILIKE TRIM ('%магазин Киев%') -- магазин Киев
                    );
*/

     -- находим товар и партию
     SELECT Object_PartionGoods.MovementItemId
          , Object_PartionGoods.GoodsId
    INTO vbPartionId, vbGoodsId
     FROM Object_PartionGoods
          INNER JOIN Object ON Object.Id = Object_PartionGoods.GoodsId
                           AND Object.DescId = zc_Object_Goods()
                           AND Object.ObjectCode = inObjectCode
     LIMIT 1;

     --если не нашли товар пропускаем
     IF COALESCE (vbGoodsId, 0) = 0
     THEN
         -- !!!ВЫХОД!!!
         RETURN;
         --RAISE EXCEPTION 'Ошибка.Не найден товар с кодом <%>.', inObjectCode;
     END IF;


     -- найти документ по ключу дата, от кого, кому
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = Movement.Id
                                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                        AND MLO_From.ObjectId   = vbUnitFromId
                           INNER JOIN MovementLinkObject AS MLO_To
                                                         ON MLO_To.MovementId = Movement.Id
                                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                        AND MLO_To.ObjectId   = vbUnitToId
                      WHERE Movement.DescId   = zc_Movement_Send()
                        AND Movement.OperDate = inOperDate
                     );

     IF COALESCE (vbMovementId, 0) = 0
     THEN
        -- сохранили <Документ>
        vbMovementId := lpInsertUpdate_Movement_Send (ioId       := 0
                                                    , inInvNumber:= CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                                    , inOperDate := inOperDate
                                                    , inFromId   := vbUnitFromId
                                                    , inToId     := vbUnitToId
                                                    , inComment  := 'загрузка' ::TVarChar
                                                    , inUserId   := vbUserId
                                                     );
     END IF;

     -- Элемент
     PERFORM gpInsertUpdate_MovementItem_Send( ioId                  :=  0    -- Ключ объекта <Элемент документа>
                                             , inMovementId          :=  vbMovementId    -- Ключ объекта <Документ>
                                             , inGoodsId             :=  vbGoodsId       -- Товар
                                             , inPartionId           :=  vbPartionId     -- Партия
                                             , inAmount              :=  inAmount ::TFloat     -- Количество
                                             , ioOperPriceList       :=  0 ::TFloat     -- Цена (прайс)
                                             , inOperPriceListTo     :=  0 ::TFloat     -- Цена (прайс)(кому) --(для магазина получателя)
                                             , inSession             :=  inSession :: TVarChar    -- сессия пользователя
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.02.20         *
*/

-- тест
