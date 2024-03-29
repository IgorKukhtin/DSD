-- Function: gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, Boolean, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
 INOUT ioId            Integer   ,     -- ключ объекта <Прайс листы> 
    IN inCode          Integer   ,     -- Код объекта <Прайс листы> 
    IN inName          TVarChar  ,     -- Название объекта <Прайс листы> 
    IN inPriceWithVAT  Boolean   ,     -- Цена с НДС (да/нет)  
    IN inisUser        Boolean   ,     -- Ограниченный доступ
    IN inVATPercent    TFloat    ,     -- % НДС
    IN inCurrencyId    Integer   ,     -- Валюта
    IN inSession       TVarChar        -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbCode:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PriceList());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inCurrencyId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Валюта>.';
   END IF;


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_PriceList());
   
   -- проверка прав уникальности для свойства <Наименование Прайс листа>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PriceList(), inName);
   -- проверка прав уникальности для свойства <Код Прайс листа>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PriceList(), vbCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceList(), vbCode, inName);

   -- сохранили свойство <Цена с НДС (да/нет)>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PriceList_PriceWithVAT(), ioId, inPriceWithVAT);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PriceList_User(), ioId, inisUser);
   
   -- сохранили свойство <% НДС>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PriceList_VATPercent(), ioId, inVATPercent);
   
   -- сохранили свойство <Валюта>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PriceList_Currency(), ioId, inCurrencyId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.03.24          * inisUser 
 16.11.14                                        * add Currency...
 11.01.13                                        * add lfGet_ObjectCode
 07.09.13                                        * add PriceWithVAT and VATPercent
 14.06.13          *
*/
/*
!!!Sybase!!!
select * 
from (
select PriceListId, min (Bill.isNds) as a1, max (Bill.isNds) as a2
from dba.ScaleHistory_byObvalka
     join dba.Bill on Bill.Id = BillId
where ScaleHistory_byObvalka.InsertDate > '2014-01-01' and ScaleHistory_byObvalka.BillKind=zc_bkSaleToClient()
  and ScaleHistory_byObvalka.BillId <> 0
group by PriceListId
having a1 <> a2
) as tmp
left join dba.PriceList_byHistory on PriceList_byHistory.Id = tmp.PriceListId
*/
-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceList ()