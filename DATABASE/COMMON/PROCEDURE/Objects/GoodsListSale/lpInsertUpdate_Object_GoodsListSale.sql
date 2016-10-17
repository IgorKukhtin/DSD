-- Function: lpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsListSale(
    IN inGoodsId           Integer   ,    -- товар
    IN inContractId        Integer   ,    -- Договор
    IN inJuridicalId       Integer   ,    -- Юр. лицо
    IN inPartnerId         Integer   ,    -- Контрагент
    IN inUserId            Integer        -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbisErased Boolean;
BEGIN

    -- пытаемся найти элемент 
    SELECT Object_GoodsListSale.Id 
         , Object_GoodsListSale.isErased 
  INTO vbId, vbisErased
    FROM Object AS Object_GoodsListSale 
       INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                             ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                            AND ObjectLink_GoodsListSale_Goods.ChildObjectId = inGoodsId
       INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                             ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                            AND ObjectLink_GoodsListSale_Partner.ChildObjectId = inPartnerId
       INNER JOIN ObjectLink AS GoodsListSale_Contract
                             ON GoodsListSale_Contract.ObjectId = Object_GoodsListSale.Id
                            AND GoodsListSale_Contract.DescId = zc_ObjectLink_GoodsListSale_Contract()
                            AND GoodsListSale_Contract.ChildObjectId = inContractId
       INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Juridical
                             ON ObjectLink_GoodsListSale_Juridical.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Juridical.DescId = zc_ObjectLink_GoodsListSale_Juridical()
                            AND ObjectLink_GoodsListSale_Juridical.ChildObjectId = inJuridicalId
    WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale();

   IF COALESCE (vbId , 0) <> 0 AND vbisErased = TRUE             -- элемент существует но помечен на удаление - снимаем пометку удаления
      THEN
         -- Меняется признак <Удален> + там же сохраняется протокол
         PERFORM lpUpdate_Object_isErased (inObjectId:= vbId, inUserId:= inUserId); 
         -- сохранили свойство <Дата корр.>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), vbId, CURRENT_TIMESTAMP);
 
   ELSE 
       IF COALESCE (vbId , 0) = 0
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
 
       -- сохранили свойство <Дата корр.>
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
