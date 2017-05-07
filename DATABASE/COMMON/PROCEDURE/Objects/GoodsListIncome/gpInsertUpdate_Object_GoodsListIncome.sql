-- Function: gpInsertUpdate_Object_GoodsListIncome  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListIncome (Integer,Integer,Integer,Integer,Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsListIncome(
 INOUT ioId                Integer   ,    -- ключ объекта <Товары в реализации покупателям> 
    IN inGoodsId           Integer   ,    -- товар
    IN inContractId        Integer   ,    -- Договор
    IN inJuridicalId       Integer   ,    -- Юр. лицо
    IN inPartnerId         Integer   ,    -- Контрагент
    IN inGoodsKindId_List  TVarChar  ,    -- Список всех вид товара
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsListIncome());
   
   -- ищем элемент, исключаем дубли
   vbId := (  SELECT Object_GoodsListIncome.Id 
              FROM Object AS Object_GoodsListIncome 
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                             ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                            AND ObjectLink_GoodsListIncome_Goods.ChildObjectId = inGoodsId
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                             ON ObjectLink_GoodsListIncome_Partner.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
                            AND ObjectLink_GoodsListIncome_Partner.ChildObjectId = inPartnerId
                     INNER JOIN ObjectLink AS GoodsListIncome_Contract
                             ON GoodsListIncome_Contract.ObjectId = Object_GoodsListIncome.Id
                            AND GoodsListIncome_Contract.DescId = zc_ObjectLink_GoodsListIncome_Contract()
                            AND GoodsListIncome_Contract.ChildObjectId = inContractId
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                             ON ObjectLink_GoodsListIncome_Juridical.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Juridical.DescId = zc_ObjectLink_GoodsListIncome_Juridical()
                            AND ObjectLink_GoodsListIncome_Juridical.ChildObjectId = inJuridicalId
              WHERE Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome());
 
   IF COALESCE(vbId,0) <> 0
      THEN
          -- сохранили свойство <>
          PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListIncome_GoodsKind(), vbId, inGoodsKindId_List);
          --RAISE EXCEPTION 'Ошибка.Элемент уже существует.';
   END IF;


   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsListIncome(), 0,'');
                          
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListIncome_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListIncome_Goods(), ioId, inGoodsId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListIncome_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListIncome_Partner(), ioId, inPartnerId);
 
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListIncome_GoodsKind(), ioId, inGoodsKindId_List);

   -- сохранили свойство <Дата создания/изменений> - убрал т.к. сохраняется в протоколе
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.03.17         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsListIncome (ioId := 737011 , inGoodsId := 5005 , inContractId := 439611 , inJuridicalId := 15158 , inPartnerId := 313098 , inGoodsKindId_List := '8339,8351,8333,8329' ,  inSession := '5');
