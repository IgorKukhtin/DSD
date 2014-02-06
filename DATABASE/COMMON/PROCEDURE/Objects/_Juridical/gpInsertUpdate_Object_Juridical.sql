-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inCode                Integer   ,    -- свойство <Код Юридического лица>
    IN inName                TVarChar  ,    -- Название объекта <Юридическое лицо>
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inisCorporate         Boolean   ,    -- Признак наша ли собственность это юридическое лицо
    IN inJuridicalGroupId    Integer   ,    -- Группы юридических лиц
    IN inGoodsPropertyId     Integer   ,    -- Классификаторы свойств товаров
    IN inInfoMoneyId         Integer   ,    -- Статьи назначения
    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции
    IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId := inSession;

   -- !!! Если код не установлен, определяем его каи последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Juridical());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальность <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Juridical(), inName);
   -- проверка уникальности <Код>
   IF vbCode <> 0
   THEN
       PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), vbCode);
   END IF;

   -- проверка
   IF COALESCE (inInfoMoneyId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<УП статья назначения> не выбрана.';
   END IF;
   -- проверка
   IF COALESCE (inJuridicalGroupId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.<Группа юридических лиц> не выбрана.';
   END IF;
   -- проверка
   IF COALESCE (inName, '') = ''
   THEN
      RAISE EXCEPTION 'Ошибка.Необходимо определить <Название юридического лица>.';
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Juridical(), vbCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_GoodsProperty(), ioId, inGoodsPropertyId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceList(), ioId, inPriceListId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceListPromo(), ioId, inPriceListPromoId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_StartPromo(), ioId, inStartPromo);
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_EndPromo(), ioId, inEndPromo);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo               
 06.01.14                                        * add проверка уникальность <Код>
 06.01.14                                        * add проверка уникальность <Наименование>
 20.10.13                                        * vbCode_calc:=0
 03.07.13          * + InfoMoney              
 12.05.13                                        * rem lpCheckUnique_Object_ValueData
 12.06.13          *    
 16.06.13                                        * rem lpCheckUnique_Object_ObjectCode
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Juridical()
