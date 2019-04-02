-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_OrderInternal_PrioritetPartner
         (Integer, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_OrderInternal_PrioritetPartner
         (Integer, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_OrderInternal_PrioritetPartner(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inJuridicalId         Integer   , -- Юр лицо
    IN inJuridicalName       TVarChar  , 
    IN inContractId          Integer   , -- Договоры
    IN inContractName        TVarChar  , 
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inSuperPrice          TFloat    , 
    IN inSuperPrice_Deferment TFloat    ,
    IN inPrice               TFloat    , 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer, JuridicalName TVarChar, 
               ContractId Integer, ContractName TVarChar,
               GoodsId Integer, GoodsCode TVarChar, GoodsName TVarChar,
               SuperPrice TFloat, Price TFloat)
AS               
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;

     -- сохранили связь с <Юр. лицом>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), inId, inJuridicalId);

     -- сохранили связь с <Договором>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), inId, inContractId);

     -- сохранили связь с <Товаром>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), inId, inGoodsId);

     RETURN QUERY
     SELECT 
          inJuridicalId AS JuridicalId, 
          inJuridicalName AS JuridicalName, 
          inContractId AS ContractId, 
          inContractName AS ContractName,
          inGoodsId AS GoodsId, 
          inGoodsCode AS GoodsCode, 
          inGoodsName AS GoodsName,
          inSuperPrice AS SuperPrice, 
          inSuperPrice_Deferment AS SuperPrice_Deferment, 
          inPrice AS Price;


     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.04.19         * add inSuperPrice_Deferment
 15.10.14                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_OrderInternal_PrioritetPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
