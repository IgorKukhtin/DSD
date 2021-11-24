-- Function: lpInsertUpdate_MovementItem_RepriceSite()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_RepriceSite (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_RepriceSite(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inJuridicalId         Integer   , -- поставщик
    IN inContractId          Integer   , -- Договор
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inMinExpirationDate   TDateTime , -- Срок годности остатка
    IN inAmount              TFloat    , -- Количество
    IN inPriceOld            TFloat    , -- Цена
    IN inPriceNew            TFloat    , -- НОВАЯ цена
    IN inJuridical_Price     TFloat    , -- Цена поставщика
    IN inisJuridicalTwo      Boolean   , -- Расчет по 2 поставщикам  
    IN inJuridicalTwoId      Integer   , -- поставщик
    IN inContractTwoId       Integer   , -- Договор
    IN inJuridical_PriceTwo  TFloat    , -- Цена поставщика
    IN inExpirationDateTwo   TDateTime , -- Срок годности
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
    
    -- сохранили <цену старую>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPriceOld);

    -- сохранили <цену новую>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPriceNew);

    -- сохранили <цену поставщика>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPrice(), ioId, inJuridical_Price);

    -- сохранили <Срок годности>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inExpirationDate);
    -- сохранили <Срок годности остатка>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);
    -- сохранили связь с <поставщик>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, inJuridicalId);
    -- сохранили связь с <Договор>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

    IF COALESCE (inisJuridicalTwo, False) = True
    THEN
      -- сохранили <Признак лог отсечения>
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_JuridicalTwo(), ioId, inisJuridicalTwo);
      
      IF COALESCE (inJuridicalTwoId, 0) <> 0
      THEN
        -- сохранили связь с <поставщик>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_JuridicalTwo(), ioId, inJuridicalTwoId);
        -- сохранили связь с <Договор>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractTwo(), ioId, inContractTwoId);
        -- сохранили <цену поставщика>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_JuridicalPriceTwo(), ioId, inJuridical_PriceTwo);      
        -- сохранили <Срок годности>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDateTwo(), ioId, inExpirationDateTwo);
      END IF;    
    END IF;

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSummRepriceSite (inMovementId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 10.06.21                                                      *  
 */