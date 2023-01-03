-- Function: gpInsertUpdate_MI_OrderInternal_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderInternal_Detail(Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderInternal_Detail(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>  
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inReceiptServiceId       Integer   , -- работы
    IN inPersonalId             Integer   , -- Сотрудник
 INOUT ioAmount                 TFloat    , -- 
 INOUT ioOperPrice              TFloat    , -- 
    IN inHours                  TFloat    , -- 
    IN inSumm                   TFloat    , -- 
    IN inComment                TVarChar  , --
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := lpGetUserBySession (inSession);

     --если введена сумма, тогда она в приоритете попадает в Сумма (расчет), а OperPrice - расчетное иначе затраты = часы*цену часа или сумма (ввод)
     IF COALESCE (inSumm,0) <> 0  
     THEN
         ioAmount := inSumm;
         ioOperPrice := CASE WHEN COALESCE (inHours,0)<>0 THEN inSumm / inHours ELSE 0 END; 
     ELSE
         ioAmount := inHours * ioOperPrice;
     END IF;
     
     -- сохранили <Элемент документа>
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MI_OrderInternal_Detail (ioId
                                                , inParentId
                                                , inMovementId
                                                , inReceiptServiceId
                                                , inPersonalId
                                                , ioAmount 
                                                , ioOperPrice
                                                , inHours
                                                , inSumm
                                                , inComment
                                                , vbUserId
                                                ) AS tmp;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.01.23         *
*/

-- тест
--