-- Function: gpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsListSale(
 INOUT ioId                Integer   ,    -- ключ объекта <Товары в реализации покупателям> 
    IN inGoodsId           Integer   ,    -- товар
    IN inContractId        Integer   ,    -- Договор
    IN inJuridicalId       Integer   ,    -- Юр. лицо
    IN inPartnerId         Integer   ,    -- Контрагент
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsListSale());
   
   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsListSale(), Null, Null);
                          
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Goods(), ioId, inGoodsId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Partner(), ioId, inPartnerId);
 
    IF vbIsInsert = False THEN
       -- сохранили свойство <Дата корр.>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
       -- сохранили свойство <Пользователь (корр.)>
       --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, inUserId);
    END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.02.15         *

*/

-- тест
-- select * from gpInsertUpdate_Object_GoodsListSale(ioId := 0 , inCode := 1 , inName := 'Белов' , inPhone := '4444' , Mail := 'выа@kjjkj' , Comment := '' , inGoodsId := 258441 , inJuridicalId := 0 , inContractId := 0 , inGoodsListSaleKindId := 153272 ,  inSession := '5');
