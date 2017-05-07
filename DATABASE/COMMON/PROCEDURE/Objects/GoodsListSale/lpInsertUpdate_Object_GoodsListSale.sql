-- Function: lpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TFloat, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TFloat, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsListSale(
    IN inId                Integer   ,    -- ид элемента
    IN inGoodsId           Integer   ,    -- товар
    IN inGoodsKindId_max   Integer   ,    -- вид товара
    IN inContractId        Integer   ,    -- Договор
    IN inJuridicalId       Integer   ,    -- Юр. лицо
    IN inPartnerId         Integer   ,    -- Контрагент
    IN inAmount            TFloat    ,    -- Кол-во в реализации
    IN inAmountChoice      TFloat    ,    -- Кол-во в реализации для МАКС
    IN inGoodsKindId_List  TVarChar  ,    -- Список всех вид товара
    IN inisErased          Boolean   ,    -- элемент удален Да/нет
    IN inUserId            Integer        -- сессия пользователя
)
 RETURNS VOID
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

   IF COALESCE (inId , 0) <> 0 -- AND vbisErased = TRUE             -- элемент существует но помечен на удаление - снимаем пометку удаления
      THEN
         -- если элемент помечен на удаление нужно снять пометку
         IF inisErased = TRUE 
            THEN
                -- Меняется признак <Удален> + там же сохраняется протокол
                PERFORM lpUpdate_Object_isErased (inObjectId:= inId, inUserId:= inUserId); 
         END IF;

         -- сохранили св-во <>
         PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsListSale_Amount(), inId, inAmount);
         -- сохранили св-во <Кол-во в реализации для МАКС> - информативно
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsListSale_AmountChoice(), inId, inAmountChoice);

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListSale_GoodsKind(), inId, inGoodsKindId_List);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_GoodsKind(), inId, inGoodsKindId_max);

         -- сохранили свойство <Дата создания/изменений> - убрал т.к. сохраняется в протоколе
         -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);

         -- сохранили протокол
         PERFORM lpInsert_ObjectProtocol (vbId, inUserId);


   ELSE 
       IF COALESCE (inId , 0) = 0
       THEN
       -- сохранили <Объект>
       vbId := lpInsertUpdate_Object (0, zc_Object_GoodsListSale(), 0, '');
                          
       -- сохранили связь с < >
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_Contract(), vbId, inContractId);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_Goods(), vbId, inGoodsId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_GoodsKind(), vbId, inGoodsKindId_max);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_Juridical(), vbId, inJuridicalId);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_Partner(), vbId, inPartnerId);
       -- сохранили св-во <Кол-во в реализации> - информативно
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsListSale_Amount(), vbId, inAmount);
       -- сохранили св-во <Кол-во в реализации для МАКС> - информативно
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsListSale_AmountChoice(), vbId, inAmountChoice);

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListSale_GoodsKind(), vbId, inGoodsKindId_List);
 
       -- сохранили свойство <Дата создания/изменений> - убрал т.к. сохраняется в протоколе
       -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), vbId, CURRENT_TIMESTAMP);

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
 07.12.16         *
 11.10.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_GoodsListSale(ioId := 0 , inCode := 1 , inName := 'Белов' , inPhone := '4444' , Mail := 'выа@kjjkj' , Comment := '' , inGoodsId := 258441 , inJuridicalId := 0 , inContractId := 0 , inGoodsListSaleKindId := 153272 ,  inSession := '5');
