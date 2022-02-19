-- Function: gpInsertUpdate_MovementItem_PriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, Integer, Integer, Integer
                                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PriceList(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inDiscountParnerId    Integer   , -- 
    IN inMeasureId           Integer   , -- 
    IN inMeasureParentId     Integer   , -- 
    IN inAmount              TFloat    , -- 
    IN inMeasureMult         TFloat    , -- 
    IN inPriceParent         TFloat    , -- 
    IN inEmpfPriceParent     TFloat    , -- 
    IN inMinCount            TFloat    , -- 
    IN inMinCountMult        TFloat    , -- 
    IN inWeightParent        TFloat    , -- 
    IN inCatalogPage         TVarChar  , --
    IN inisOutlet            Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PriceList());
     vbUserId := inSession;

     -- 
     PERFORM lpInsertUpdate_MovementItem_PriceList (ioId, inMovementId, inGoodsId
                                                  , inDiscountParnerId
                                                  , inMeasureId, inMeasureParentId
                                                  , inAmount
                                                  , inMeasureMult, inPriceParent, EmpfPriceParent
                                                  , inMinCount, inMinCountMult, WeightParent
                                                  , inCatalogPage
                                                  , inisOutlet
                                                  , vbUserId
                                                   );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.02.22         *
*/

-- тест
--