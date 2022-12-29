-- Function: gpInsertUpdate_MI_ProductionPersonal_basic()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPersonal_basic(Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionPersonal_basic(Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionPersonal_basic(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId          Integer   , -- 
    IN inMovementId_OrderClient  Integer   , -- 
   OUT outProductId          Integer   ,
   OUT outProductName        TVarChar  ,
    IN inGoodsId             Integer   , -- 
    IN inStartBegin          TDateTime ,
    IN inEndBegin            TDateTime ,
    IN inAmount              TFloat    , -- Количество
    IN inComment             TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId Integer; 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionPersonal());
     vbUserId := lpGetUserBySession (inSession);

     --лодка из заказа
     outProductId := (SELECT MovementLinkObject_Product.ObjectId AS ProductId
                      FROM MovementLinkObject AS MovementLinkObject_Product
                      WHERE MovementLinkObject_Product.MovementId = inMovementId_OrderClient
                       AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                     );

     -- сохранили <Элемент документа>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MovementItem_ProductionPersonal (ioId
                                                        , inMovementId
                                                        , inPersonalId
                                                        , outProductId
                                                        , inGoodsId
                                                        , inStartBegin
                                                        , inEndBegin
                                                        , inAmount 
                                                        , inComment
                                                        , vbUserId
                                                        ) AS tmp;

     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     outProductName := (SELECT Object.ValueData FROM Object WHERE Object.Id = outProductId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.22         *
*/

-- тест
--