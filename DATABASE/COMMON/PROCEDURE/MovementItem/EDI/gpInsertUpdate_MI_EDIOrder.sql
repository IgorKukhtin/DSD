-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EDIOrder(Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_EDIOrder(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_EDIOrder(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsPropertyId     Integer   ,
    IN inGoodsName           TVarChar  , -- Товар
    IN inGLNCode             TVarChar  , -- Товар
    IN inAmountOrder         TFloat    , -- Количество Заказа
    IN inPriceOrder          TFloat    , -- Цена из Эксайта
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbGoodsId        Integer;
   DECLARE vbGoodsKindId    Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_EDI());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF 0 < (SELECT COUNT (*)
             FROM Movement
                  INNER JOIN MovementString AS MovementString_DealId
                                            ON MovementString_DealId.MovementId = Movement.Id
                                           AND MovementString_DealId.DescId     = zc_MovementString_DealId()
                                           AND MovementString_DealId.ValueData  <> ''
             WHERE Movement.Id = inMovementId
            )
     THEN
         -- Выход т.к. документ уже загружен
         RETURN;
     END IF;


     -- Проверка
     IF 1 < (WITH tmpMI AS (SELECT MovementItem.Id
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                           )
                , tmpMIS AS (SELECT MovementItemString.*
                             FROM MovementItemString
                             WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemString.DescId         = zc_MIString_GLNCode()
                            )
             -- Результат
             SELECT COUNT(*) FROM tmpMIS WHERE tmpMIS.ValueData = inGLNCode
            )
     THEN
         -- попробуем исправить ... закомментил, т.к. не проверил как оно работает
         /**/
         UPDATE MovementItem SET isErased = TRUE
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.Id         IN (WITH tmpMI AS (SELECT MovementItem.Id
                                                          FROM MovementItem
                                                          WHERE MovementItem.MovementId = inMovementId
                                                            AND MovementItem.DescId = zc_MI_Master()
                                                            AND MovementItem.isErased = FALSE
                                                         )
                                              , tmpMIS AS (SELECT MovementItemString.*
                                                           FROM MovementItemString
                                                           WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                             AND MovementItemString.DescId         = zc_MIString_GLNCode()
                                                          )
                                           -- Результат
                                           SELECT tmp.MovementItemId
                                           FROM (SELECT tmpMIS.MovementItemId
                                                      , ROW_NUMBER() OVER (PARTITION BY tmpMIS.ValueData ORDER BY tmpMIS.MovementItemId DESC) AS Ord
                                                 FROM tmpMIS
                                                 WHERE tmpMIS.ValueData = inGLNCode
                                                ) AS tmp
                                           WHERE tmp.Ord <> 1
                                          );
         /**/

         -- Проверка после исправления
         IF 1 < (WITH tmpMI AS (SELECT MovementItem.Id
                                FROM MovementItem
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                               )
                    , tmpMIS AS (SELECT MovementItemString.*
                                 FROM MovementItemString
                                 WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemString.DescId         = zc_MIString_GLNCode()
                                )
                 -- Результат
                 SELECT COUNT(*) FROM tmpMIS WHERE tmpMIS.ValueData = inGLNCode
                )
         THEN
             RAISE EXCEPTION 'Ошибка.В документе EDI № <%> от <%> дублирование товара с GLN = <%>', (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_EDI())
                                                                                                  , DATE ((SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_EDI()))
                                                                                                  , inGLNCode;
        END IF;
     END IF;

     -- находим элемент (по идее один товар - один GLN-код)
     vbMovementItemId := COALESCE((WITH tmpMI AS (SELECT MovementItem.Id
                                                  FROM MovementItem
                                                  WHERE MovementItem.MovementId = inMovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                                 )
                                      , tmpMIS AS (SELECT MovementItemString.*
                                                   FROM MovementItemString
                                                   WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                     AND MovementItemString.DescId         = zc_MIString_GLNCode()
                                                  )
                                   -- Результат
                                   SELECT tmpMIS.MovementItemId FROM tmpMIS WHERE tmpMIS.ValueData = inGLNCode
                                  ), 0);

     -- если есть классификатор
     IF COALESCE (inGoodsPropertyId, 0) <> 0 AND TRIM (inGLNCode) <>''
     THEN
         -- Находим vbGoodsId и vbGoodsKindId
         SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId     AS GoodsId
              , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
                INTO vbGoodsId, vbGoodsKindId
         FROM ObjectString AS ObjectString_ArticleGLN
              JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                              ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId      = ObjectString_ArticleGLN.objectid
                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId
              LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                   ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectString_ArticleGLN.objectid
                                  AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
              LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectString_ArticleGLN.objectid
                                  AND ObjectLink_GoodsPropertyValue_Goods.DescId   = zc_ObjectLink_GoodsPropertyValue_Goods()
         WHERE ObjectString_ArticleGLN.DescId    = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
           AND ObjectString_ArticleGLN.ValueData = inGLNCode;
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- сохранили <Элемент документа>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), vbGoodsId, inMovementId, inAmountOrder, NULL);

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GLNCode(), vbMovementItemId, inGLNCode);

     -- сохранили
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), vbMovementItemId, inGoodsName);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), vbMovementItemId, vbGoodsKindId);

     -- сохранили <Цена из Эксайта>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPriceOrder);

     -- Проверка
     IF 1 < (WITH tmpMI AS (SELECT MovementItem.Id
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                           )
                , tmpMIS AS (SELECT MovementItemString.*
                             FROM MovementItemString
                             WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                               AND MovementItemString.DescId         = zc_MIString_GLNCode()
                            )
             -- Результат
             SELECT COUNT(*) FROM tmpMIS WHERE tmpMIS.ValueData = inGLNCode
            )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе EDI № <%> от <%> дублирование товара с GLN = <%>. Повторите действие через 25 сек.'
                                                                                              , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_EDI())
                                                                                              , DATE ((SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_EDI()))
                                                                                              , inGLNCode;
     END IF;


     -- Проверка через УНИКАЛЬНОСТЬ
     IF vbIsInsert = TRUE AND inGLNCode <> ''

     THEN
         PERFORM lpInsert_LockUnique (inKeyData:= 'MI'
                                        || ';' || zc_Movement_EDI() :: TVarChar
                                        || ';' || inMovementId :: TVarChar
                                        || ';' || inGLNCode
                                    , inUserId:= vbUserId);
     END IF;


     -- только 1 раз
     IF vbIsInsert = TRUE
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);
     END IF;

IF vbUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.Test-ok-end % ', vbGoodsKindId;
END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.05.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_EDIOrder (inMovementId:= 16086413, inGoodsPropertyId:= 536616, inGoodsName:= 'Ковбаса Алан Яловича в/г с/к 1/2 в/у ваг', inGLNCode:= '9-0034180', inAmountOrder:= 0.6, inPriceOrder:= 215.7, inSession:= '5')
