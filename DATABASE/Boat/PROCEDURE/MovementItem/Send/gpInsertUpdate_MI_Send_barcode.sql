-- Function: gpInsertUpdate_MI_Send_BarCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_BarCode(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_BarCode(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBarCode_Goods       TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsId Integer;
   DECLARE vbCountForPrice TFloat;
   DECLARE vboperprice   TFloat;
   DECLARE vbAmount     TFloat;
   DECLARE vbPartNumber  TVarChar;
   
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionPersonal());
     vbUserId := lpGetUserBySession (inSession);

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- найдем товар
     IF TRIM (inBarCode_Goods) <> ''
     THEN
         IF CHAR_LENGTH (inBarCode_Goods) = 13
         THEN -- по штрих коду, 
              vbGoodsId:= (SELECT Object.Id
                           FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode_Goods, 4, 13-4)) AS GoodsId
                                ) AS tmp
                                INNER JOIN Object ON Object.Id = tmp.GoodsId
                                                   AND Object.DescId = zc_Object_Goods()
                                                   AND Object.isErased = FALSE
                          );
         ELSE -- по коду
              vbGoodsId:= (SELECT Object.Id
                           FROM Object
                           WHERE Object.ObjectCode = inBarCode_Goods::Integer
                             AND Object.DescId = zc_Object_Goods()
                             AND Object.isErased = FALSE
                          );
         END IF;

         -- Проверка
         IF COALESCE (vbGoodsId, 0) = 0
         THEN
             --RAISE EXCEPTION '', inBarCode_OrderClient;
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Комплектующие ' || CASE WHEN CHAR_LENGTH (inBarCode_Goods) = 13 THEN 'Ш/К' ELSE 'код' END || ' <%>  не найден.' :: TVarChar
                                                   , inProcedureName := 'gpInsertUpdate_MI_Send_barcode'     :: TVarChar
                                                   , inUserId        := vbUserId
                                                   , inParam1        := inBarCode_Goods      :: TVarChar
                                                   );
         END IF;

 
         -- пробуем найти сохраненную строку по такому товару, если есть +1 к кол-ву
         SELECT MovementItem.Id
              , MovementItem.Amount
              , MIFloat_OperPrice.ValueData     AS OperPrice
              , COALESCE (MIFloat_CountForPrice.ValueData, 1) AS CountForPrice
              , MIString_PartNumber.ValueData   AS PartNumber
        INTO ioId, vbAmount, vbOperPrice, vbCountForPrice, vbPartNumber
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                          ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                         AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
              LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                          ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                         AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
              LEFT JOIN MovementItemString AS MIString_PartNumber
                                           ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                          AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     =  zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.ObjectId   = vbGoodsId
         ;
   
         -- Если нашли закрываем
         IF COALESCE (ioId,0) <> 0
         THEN
             SELECT tmp.ioId
                    INTO ioId 
             FROM lpInsertUpdate_MovementItem_Send (COALESCE (ioId,0)
                                                  , inMovementId
                                                  , vbGoodsId
                                                  , (COALESCE (vbAmount,0) + 1) ::TFloat
                                                  , vbOperPrice
                                                  , vbCountForPrice
                                                  , COALESCE (vbPartNumber,'') ::TVarChar
                                                  , ''::TVarChar
                                                  , vbUserId
                                                  ) AS tmp;
         ELSE
            --нужно найти OperPrice, CountForPrice
            SELECT Object_PartionGoods.EKPrice ::TFloat AS OperPrice
                 , COALESCE (Object_PartionGoods.CountForPrice,1) ::TFloat AS CountForPrice
             INTO vbOperPrice, vbCountForPrice
            FROM Object_PartionGoods
            WHERE Object_PartionGoods.ObjectId = vbGoodsId
            ;
            
             --сохранили строку
             SELECT tmp.ioId
                    INTO ioId 
             FROM lpInsertUpdate_MovementItem_Send (COALESCE (ioId,0)
                                                  , inMovementId
                                                  , vbGoodsId
                                                  , (COALESCE (vbAmount,0) + 1) ::TFloat
                                                  , vbOperPrice
                                                  , vbCountForPrice
                                                  , COALESCE (vbPartNumber,'') ::TVarChar
                                                  , ''::TVarChar
                                                  , vbUserId
                                                  ) AS tmp;

         END IF;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
     
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.21         *
*/

-- тест
--