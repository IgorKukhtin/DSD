-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inCode                Integer   ,    -- свойство <Код Юридического лица>
    IN inName                TVarChar  ,    -- Название объекта <Юридическое лицо>
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inisCorporate         Boolean   ,    -- Признак наша ли собственность это юридическое лицо
    IN inisTaxSummary        Boolean   ,    -- Признак сводная налоговая
    IN inisDiscountPrice     Boolean   ,    -- Печать в накладной цену со скидкой
    IN inisPriceWithVAT      Boolean   ,    -- Печать в накладной цену с НДС (да/нет)   
    IN inisNotRealGoods      Boolean   ,    -- нет cхемы с заменой факт/бухг отгрузка)
    IN inDayTaxSummary       TFloat    ,    -- Кол-во дней для сводной налоговой
    IN inJuridicalGroupId    Integer   ,    -- Группы юридических лиц
    IN inGoodsPropertyId     Integer   ,    -- Классификаторы свойств товаров
    IN inRetailId            Integer   ,    -- Торговая сеть
    IN inRetailReportId      Integer   ,    -- Торговая сеть(отчет) 
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
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());


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

   -- Проверка
   IF ioId > 0
      AND COALESCE (inPriceListId, 0) <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Juridical_PriceList()), 0)
   THEN
       -- RAISE EXCEPTION 'Ошибка.Нет прав устанавливать прайс <%>.', lfGet_Object_ValueData_sh (inPriceListId);
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Juridical_PriceList());
   ELSEIF COALESCE (ioId, 0) = 0 -- AND inPriceListId > 0 AND inPriceListId <> zc_PriceList_Basis()
   THEN
       -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Juridical_PriceList());
      inPriceListId:= NULL;
      inPriceListPromoId:= NULL;
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
   -- проверка
   IF inIsCorporate = TRUE AND COALESCE (ioId, 0) <> zc_Juridical_Basis()
   THEN
      RAISE EXCEPTION 'Ошибка.Неправильно установлен признак <Главное юридическое лицо>.';
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Juridical(), vbCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_DayTaxSummary(), ioId, inDayTaxSummary);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isTaxSummary(), ioId, inisTaxSummary);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isDiscountPrice(), ioId, inisDiscountPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isPriceWithVAT(), ioId, inisPriceWithVAT);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isNotRealGoods(), ioId, inisNotRealGoods);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_GoodsProperty(), ioId, inGoodsPropertyId);
    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);
    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_RetailReport(), ioId, inRetailReportId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceList(), ioId, inPriceListId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceListPromo(), ioId, inPriceListPromoId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_StartPromo(), ioId, DATE (inStartPromo));
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_EndPromo(), ioId, DATE (inEndPromo));
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Juridical  (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.09.22         * add inisNotRealGoods
 07.02.17         * add isPriceWithVAT
 17.12.15         * add isDiscountPrice 
 20.11.14         *
 07.11.14         * изменено RetailReport
 23.05.14         * add Retail
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
