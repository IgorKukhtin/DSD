-- Function: gpInsertUpdate_MovementItem_ProductionPersonal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProductionPersonal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId_start    Integer   , -- сотрудник Старт
    IN inPersonalId_end      Integer   , -- сотрудник ФИНИШ
    IN inOrderClientId       Integer   , -- заказ клиента
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPersonalId Integer;
   DECLARE vbProductId Integer;
   DECLARE vbStartBegin TDateTime;
   DECLARE vbEndBegin   TDateTime;
   DECLARE vbAmount     TFloat;
   
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionPersonal());
     vbUserId := lpGetUserBySession (inSession);

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     vbProductId := (SELECT MovementLinkObject_Product.ObjectId       AS ProductId
                     FROM MovementLinkObject AS MovementLinkObject_Product
                     WHERE MovementLinkObject_Product.MovementId = inOrderClientId
                       AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                     );

     IF COALESCE (inPersonalId_start,0) = 0 AND COALESCE (inPersonalId_end,0) = 0
     THEN
         RETURN;
     END IF;
     
     IF COALESCE (inPersonalId_start,0) <> 0
     THEN
         vbPersonalId := inPersonalId_start;
         vbStartBegin := CURRENT_TIMESTAMP;
         vbEndBegin   := NULL ::TDateTime;
         vbAmount     := 0;
         ioId         := 0;
     END IF;

    IF COALESCE (inPersonalId_end,0) <> 0
     THEN
         vbPersonalId := inPersonalId_end;
         vbEndBegin   := CURRENT_TIMESTAMP;

         -- находим строку по сотруднику с пустой датой окончания
         SELECT MovementItem.Id
              , MIDate_StartBegin.ValueData
        INTO ioId, vbStartBegin
         FROM MovementItem
              INNER JOIN MovementItemLinkObject AS MILO_Product
                                                ON MILO_Product.MovementItemId = MovementItem.Id
                                               AND MILO_Product.DescId = zc_MILinkObject_Product()
                                               AND MILO_Product.ObjectId = vbProductId

              LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                         ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                        AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
              LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                         ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                        AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     =  zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.ObjectId   = vbPersonalId
           AND MIDate_EndBegin.ValueData IS NULL
         ;   
         
         -- если нет строки начала ошибка
         IF COALESCE (ioId,0) = 0
         THEN
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Нет строки начала работы для выбранного сотрудника' :: TVarChar
                                                   , inProcedureName := 'gpInsertUpdate_MovementItem_ProductionPersonal'   :: TVarChar
                                                   , inUserId        := vbUserId);
         END IF;
         
         --часы работы
         vbAmount := ( CAST ( date_part( 'hours', vbEndBegin -vbStartBegin) + date_part( 'minute' , vbEndBegin - vbStartBegin)/60 AS NUMERIC (16,2)));
     END IF;

     -- сохранили <Элемент документа>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MovementItem_ProductionPersonal (ioId
                                                        , inMovementId
                                                        , vbPersonalId
                                                        , vbProductId
                                                        , vbStartBegin
                                                        , vbEndBegin
                                                        , vbAmount
                                                        , vbUserId
                                                        ) AS tmp;


     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
--