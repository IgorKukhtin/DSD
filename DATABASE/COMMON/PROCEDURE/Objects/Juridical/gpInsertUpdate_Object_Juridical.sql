-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inCode                Integer   ,    -- свойство <Код Юридического лица>
    IN inName                TVarChar  ,    -- Название объекта <Юридическое лицо>
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inIsCorporate         Boolean   ,    -- Признак наша ли собственность это юридическое лицо
    IN inIsTaxSummary        Boolean   ,    -- Признак сводная налоговая
    IN inIsDiscountPrice     Boolean   ,    -- Печать в накладной цену со скидкой
    IN inIsPriceWithVAT      Boolean   ,    -- Печать в накладной цену с НДС (да/нет)
    IN inIsNotRealGoods      Boolean   ,    -- нет cхемы с заменой факт/бухг отгрузка)
    IN inisVchasnoEdi        Boolean   ,    -- Обработка на платформе Вчасно EDI
    IN inDayTaxSummary       TFloat    ,    -- Кол-во дней для сводной налоговой
    IN inJuridicalGroupId    Integer   ,    -- Группы юридических лиц
    IN inGoodsPropertyId     Integer   ,    -- Классификаторы свойств товаров
    IN inRetailId            Integer   ,    -- Торговая сеть
    IN inRetailReportId      Integer   ,    -- Торговая сеть(отчет)
    IN inInfoMoneyId         Integer   ,    -- Статьи назначения
    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inSectionId           Integer   ,    -- Сегмент
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbName_old TVarChar;
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
   AND 1=0
   THEN
      RAISE EXCEPTION 'Ошибка.Неправильно установлен признак <Главное юридическое лицо>.';
   END IF;

   vbName_old:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Juridical(), vbCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_DayTaxSummary(), ioId, inDayTaxSummary);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inIsCorporate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isTaxSummary(), ioId, inIsTaxSummary);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isDiscountPrice(), ioId, inIsDiscountPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isPriceWithVAT(), ioId, inIsPriceWithVAT);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isNotRealGoods(), ioId, inIsNotRealGoods);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_VchasnoEdi(), ioId, inisVchasnoEdi);

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

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Section(), ioId, inSectionId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_StartPromo(), ioId, DATE (inStartPromo));
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_EndPromo(), ioId, DATE (inEndPromo));

   -- сохранили
   PERFORM lpUpdate_Object_Partner_Address( inId                := OL_Partner_Juridical.ObjectId
                                          , inJuridicalId       := ioId
                                          , inShortName         := ObjectString_ShortName.ValueData
                                          , inCode              := Object_Partner.ObjectCode
                                          , inRegionName        := Object_Region.ValueData
                                          , inProvinceName      := Object_Province.ValueData
                                          , inCityName          := Object_Street_View.CityName
                                          , inCityKindId        := Object_CityKind.Id
                                          , inProvinceCityName  := Object_Street_View.ProvinceCityName
                                          , inPostalCode        := Object_Street_View.PostalCode
                                          , inStreetName        := Object_Street_View.Name
                                          , inStreetKindId      := Object_Street_View.StreetKindId
                                          , inHouseNumber       := ObjectString_HouseNumber.ValueData
                                          , inCaseNumber        := ObjectString_CaseNumber.ValueData
                                          , inRoomNumber        := ObjectString_RoomNumber.ValueData
                                          , inIsCheckUnique     := FALSE
                                          , inSession           := inSession
                                          , inUserId            := vbUserId
                                           )
      FROM ObjectLink AS OL_Partner_Juridical
           JOIN Object AS Object_Partner ON Object_Partner.Id = OL_Partner_Juridical.ObjectId
           LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                  ON ObjectString_HouseNumber.ObjectId = Object_Partner.Id
                                 AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()

           LEFT JOIN ObjectString AS ObjectString_ShortName
                                  ON ObjectString_ShortName.ObjectId = Object_Partner.Id
                                 AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()

           LEFT JOIN ObjectString AS ObjectString_CaseNumber
                                  ON ObjectString_CaseNumber.ObjectId = Object_Partner.Id
                                 AND ObjectString_CaseNumber.DescId = zc_ObjectString_Partner_CaseNumber()

           LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                  ON ObjectString_RoomNumber.ObjectId = Object_Partner.Id
                                 AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                                ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                               AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
           LEFT JOIN Object_Street_View ON Object_Street_View.Id = ObjectLink_Partner_Street.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_City_CityKind                                          -- по улице
                                ON ObjectLink_City_CityKind.ObjectId = Object_Street_View.CityId
                               AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
           LEFT JOIN Object AS Object_CityKind ON Object_CityKind.Id = ObjectLink_City_CityKind.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_City_Region
                                ON ObjectLink_City_Region.ObjectId = Object_Street_View.CityId
                               AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
           LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_City_Province
                                ON ObjectLink_City_Province.ObjectId = Object_Street_View.CityId
                               AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
           LEFT JOIN Object AS Object_Province ON Object_Province.Id = ObjectLink_City_Province.ChildObjectId

      WHERE OL_Partner_Juridical.ChildObjectId = ioId
        AND OL_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
        AND vbName_old                         <> inName
        AND Object_Street_View.CityName        <> ''
     ;

   -- проверка
   IF vbUserId = 5 OR vbUserId = 9457
   THEN
      RAISE EXCEPTION 'Ошибка. %  %.', vbName_old, inName;
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
 14.03.25         * inisVchasnoEdi
 02.11.22         * add inSectionId
 30.09.22         * add inIsNotRealGoods
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
