-- Function: lpInsertUpdate_MovementItem_PriceList()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PriceList (Integer, Integer, Integer, Integer, Integer, Integer
                                                             , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PriceList(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inDiscountPartnerId    Integer   , -- 
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
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
BEGIN

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MeasureMult(), ioId, inMeasureMult);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceParent(), ioId, inPriceParent);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_EmpfPriceParent(), ioId, inEmpfPriceParent);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MinCount(), ioId, inMinCount);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MinCountMult(), ioId, inMinCountMult);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightParent(), ioId, inWeightParent);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CatalogPage(), ioId, inCatalogPage);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Outlet(), ioId, inisOutlet);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DiscountPartner(), ioId, inDiscountPartnerId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Measure(), ioId, inMeasureId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MeasureParent(), ioId, inMeasureParentId);



     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

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