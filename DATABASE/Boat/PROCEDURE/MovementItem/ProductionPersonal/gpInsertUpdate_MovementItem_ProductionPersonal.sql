-- Function: gpInsertUpdate_MovementItem_ProductionPersonal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProductionPersonal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBarCode_start       TVarChar   , -- сотрудник Старт
    IN inBarCode_end         TVarChar   , -- сотрудник ФИНИШ
    IN inBarCode_OrderClient TVarChar   , -- заказ клиента
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPersonalId Integer;
   DECLARE vbProductId Integer;
   DECLARE vbProductId_end Integer;
   DECLARE vbMovementId_OrderClient Integer;
   DECLARE vbStartBegin TDateTime;
   DECLARE vbEndBegin   TDateTime;
   DECLARE vbAmount     TFloat;
   
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionPersonal());
     vbUserId := lpGetUserBySession (inSession);

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- найдем OrderClient
     IF TRIM (inBarCode_OrderClient) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_OrderClient) = 13
         THEN -- по штрих коду, но для "проверки" ограничение - 8 DAY
              vbMovementId_OrderClient:= (SELECT Movement.Id
                                          FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_OrderClient, 4, 13-4)) AS MovementId
                                               ) AS tmp
                                               INNER JOIN Movement ON Movement.Id = tmp.MovementId
                                                                  AND Movement.DescId = zc_Movement_OrderClient()
                                                                  AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '160 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                                         );
         ELSE -- по InvNumber, но для скорости ограничение - 8 DAY
              vbMovementId_OrderClient:= (SELECT Movement.Id
                                          FROM Movement
                                          WHERE Movement.InvNumber = TRIM (inBarCode_OrderClient)
                                            AND Movement.DescId = zc_Movement_OrderClient()
                                            AND Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '160 DAY' AND CURRENT_DATE + INTERVAL '8 DAY'
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                         );
         END IF;

         -- Проверка
         IF COALESCE (vbMovementId_OrderClient, 0) = 0
         THEN
             --RAISE EXCEPTION '', inBarCode_OrderClient;
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Документ <Заказ Клиента> с ' || CASE WHEN CHAR_LENGTH (inBarCode_OrderClient) = 13 THEN 'Ш/К' ELSE '№' END || ' <%> не найден.' :: TVarChar
                                                   , inProcedureName := 'gpInsertUpdate_MovementItem_ProductionPersonal'     :: TVarChar
                                                   , inUserId        := vbUserId
                                                   , inParam1        := inBarCode_OrderClient                                :: TVarChar
                                                   );
         END IF;

         vbProductId := (SELECT MovementLinkObject_Product.ObjectId       AS ProductId
                         FROM MovementLinkObject AS MovementLinkObject_Product
                         WHERE MovementLinkObject_Product.MovementId = vbMovementId_OrderClient
                           AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                         );
         IF COALESCE (vbProductId,0) = 0
         THEN
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Не определена лодка в Документе <Заказ Клиента> с ' || CASE WHEN CHAR_LENGTH (inBarCode_OrderClient) = 13 THEN 'Ш/К' ELSE '№' END || ' № <%>.' :: TVarChar
                                                   , inProcedureName := 'gpInsertUpdate_MovementItem_ProductionPersonal'     :: TVarChar
                                                   , inUserId        := vbUserId
                                                   , inParam1        := inBarCode_OrderClient                                :: TVarChar
                                                   );
         END IF;
     END IF;



     IF COALESCE (inBarCode_start, '') = '' AND COALESCE (inBarCode_end, '') = ''
     THEN
         RETURN;
     END IF;
 
     IF COALESCE (inBarCode_start,'') <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_start) = 13
         THEN -- по штрих коду
              vbPersonalId:= (SELECT Object.Id
                              FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_start, 4, 13-4)) AS ObjectId
                                   ) AS tmp
                                    INNER JOIN Object ON Object.Id = tmp.ObjectId
                                                     AND Object.DescId = zc_Object_Personal()
                                                     AND Object.isErased = FALSE
                              );
         END IF;

         -- Проверка
         IF COALESCE (vbPersonalId, 0) = 0
         THEN
            -- RAISE EXCEPTION 'Ошибка.Сотрудник с № <%> не найден.', inBarCode_start;
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Сотрудник с ' || CASE WHEN CHAR_LENGTH (inBarCode_OrderClient) = 13 THEN 'Ш/К' ELSE '№' END || ' <%> не найден.' :: TVarChar
                                                   , inProcedureName := 'gpInsertUpdate_MovementItem_ProductionPersonal'   :: TVarChar
                                                   , inUserId        := vbUserId
                                                   , inParam1        := inBarCode_start                       :: TVarChar
                                                   );
         END IF;

         --перед открытием новой смены проверяем нет ли открытой, если есть закрываем
         -- пробуем найти строку по сотруднику с пустой датой окончания
         SELECT MovementItem.Id
              , MIDate_StartBegin.ValueData
              , MILO_Product.ObjectId
        INTO ioId, vbStartBegin, vbProductId_end
         FROM MovementItem
              LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                         ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                        AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
              LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                         ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                        AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()
              LEFT JOIN MovementItemLinkObject AS MILO_Product
                                               ON MILO_Product.MovementItemId = MovementItem.Id
                                              AND MILO_Product.DescId = zc_MILinkObject_Product()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     =  zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.ObjectId   = vbPersonalId
           AND MIDate_EndBegin.ValueData IS NULL
         ;   
         -- Если нашли закрываем
         IF COALESCE (ioId,0) <> 0
         THEN
             vbEndBegin   := CURRENT_TIMESTAMP;

             --часы работы
             vbAmount := ( CAST ( COALESCE (date_part( 'day', vbEndBegin -vbStartBegin) * 24,0)      -- дни
                                + COALESCE (date_part( 'hours', vbEndBegin -vbStartBegin),0)      -- часы
                                + COALESCE (date_part( 'minute' , vbEndBegin - vbStartBegin)/60,0) AS NUMERIC (16,2)));  -- минуты

             -- сохранили <Элемент документа>
             SELECT tmp.ioId
                    INTO ioId 
             FROM lpInsertUpdate_MovementItem_ProductionPersonal (ioId
                                                                , inMovementId
                                                                , vbPersonalId
                                                                , vbProductId_end
                                                                , vbStartBegin
                                                                , vbEndBegin
                                                                , vbAmount
                                                                , vbUserId
                                                                ) AS tmp;
         END IF;
         
         


         vbStartBegin := CURRENT_TIMESTAMP;
         vbEndBegin   := NULL ::TDateTime;
         vbAmount     := 0;
         ioId         := 0;
     END IF;

    IF COALESCE (inBarCode_end,'') <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_end) = 13
         THEN -- по штрих коду
              vbPersonalId:= (SELECT Object.Id
                              FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_end, 4, 13-4)) AS ObjectId
                                   ) AS tmp
                                    INNER JOIN Object ON Object.Id = tmp.ObjectId
                                                     AND Object.DescId = zc_Object_Personal()
                                                     AND Object.isErased = FALSE
                              );
         END IF;

         -- Проверка
         IF COALESCE (vbPersonalId, 0) = 0
         THEN
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Сотрудник с ' || CASE WHEN CHAR_LENGTH (inBarCode_end) = 13 THEN 'Ш/К' ELSE '№' END || ' <%> не найден.' :: TVarChar
                                                   , inProcedureName := 'gpInsertUpdate_MovementItem_ProductionPersonal'   :: TVarChar
                                                   , inUserId        := vbUserId
                                                   , inParam1        := inBarCode_end                         :: TVarChar
                                                   );

         END IF;

         
         vbEndBegin   := CURRENT_TIMESTAMP + INTERVAL '3 HOUR';

         -- находим строку по сотруднику с пустой датой окончания
         SELECT MovementItem.Id
              , MIDate_StartBegin.ValueData
              , MILO_Product.ObjectId
        INTO ioId, vbStartBegin, vbProductId
         FROM MovementItem
              LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                         ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                        AND MIDate_StartBegin.DescId = zc_MIDate_StartBegin()
              LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                         ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                        AND MIDate_EndBegin.DescId = zc_MIDate_EndBegin()
              LEFT JOIN MovementItemLinkObject AS MILO_Product
                                               ON MILO_Product.MovementItemId = MovementItem.Id
                                              AND MILO_Product.DescId = zc_MILinkObject_Product()
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
         vbAmount := ( CAST ( COALESCE (date_part( 'day', vbEndBegin -vbStartBegin) * 24,0)      -- дни
                            + COALESCE (date_part( 'hours', vbEndBegin -vbStartBegin),0)      -- часы
                            + COALESCE (date_part( 'minute' , vbEndBegin - vbStartBegin)/60,0) AS NUMERIC (16,2)));  -- минуты
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