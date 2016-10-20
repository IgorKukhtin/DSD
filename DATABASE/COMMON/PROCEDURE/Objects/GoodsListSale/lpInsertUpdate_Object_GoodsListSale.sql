-- Function: lpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsListSale(
    IN inId                Integer   ,    -- ид элемента
    IN inGoodsId           Integer   ,    -- товар
    IN inContractId        Integer   ,    -- Договор
    IN inJuridicalId       Integer   ,    -- Юр. лицо
    IN inPartnerId         Integer   ,    -- Контрагент
    IN inAmount            TFloat    ,    -- Кол-во в реализации
    IN inUserId            Integer        -- сессия пользователя
)
 RETURNS Void AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbisErased Boolean;
BEGIN

   IF COALESCE (inId , 0) <> 0 -- AND vbisErased = TRUE             -- элемент существует но помечен на удаление - снимаем пометку удаления
      THEN
         -- Меняется признак <Удален> + там же сохраняется протокол
         PERFORM lpUpdate_Object_isErased (inObjectId:= inId, inUserId:= inUserId); 
    
         -- сохранили св-во <>
         PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsListSale_Amount(), inId, inAmount);

         -- сохранили свойство <Дата создания/изменений>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);

   ELSE 
       IF COALESCE (inId , 0) = 0
       THEN
       -- сохранили <Объект>
       vbId := lpInsertUpdate_Object (0, zc_Object_GoodsListSale(), 0, '');
                          
       -- сохранили связь с < >
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Contract(), vbId, inContractId);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Goods(), vbId, inGoodsId);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Juridical(), vbId, inJuridicalId);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Partner(), vbId, inPartnerId);
   
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsListSale_Amount(), vbId, inAmount);
 
       -- сохранили свойство <Дата создания/изменений>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), vbId, CURRENT_TIMESTAMP);

       -- сохранили протокол
       PERFORM lpInsert_ObjectProtocol (vbId, inUserId);
       END IF;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.10.16         *
*/

-- тест
-- select * from lpInsertUpdate_Object_GoodsListSale(ioId := 0 , inCode := 1 , inName := 'Белов' , inPhone := '4444' , Mail := 'выа@kjjkj' , Comment := '' , inGoodsId := 258441 , inJuridicalId := 0 , inContractId := 0 , inGoodsListSaleKindId := 153272 ,  inSession := '5');
