-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TFloat, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime,TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime,TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Подразделение>
    IN inCode                    Integer   ,    -- Код объекта <Подразделение>
    IN inName                    TVarChar  ,    -- Название объекта <Подразделение>
    IN inAddress                 TVarChar  ,    -- адрес
    IN inPhone                   TVarChar,
    IN inTaxService              TFloat    ,    -- % от выручки
    IN inTaxServiceNigth         TFloat    ,    -- % от выручки в ночную смену
    IN inStartServiceNigth       TDateTime ,
    IN inEndServiceNigth         TDateTime ,
    IN inCreateDate              TDateTime ,    -- дата создания точки
    IN inCloseDate               TDateTime ,    -- дата закрытия точки
    IN inTaxUnitStartDate        TDateTime ,
    IN inTaxUnitEndDate          TDateTime ,
    IN inDateSP                  TDateTime ,    -- Дата начала работы по Соц.проектам 
    IN inStartTimeSP             TDateTime ,    -- Время начала работы по Соц.проектам 
    IN inEndTimeSP               TDateTime ,    -- Время завершения работы по Соц.проектам
    IN inisSp                    Boolean   ,    -- Работают по Соц.проекту
    IN inisRepriceAuto           Boolean   ,    -- участвует в автопереоценке
    IN inAreaId                  Integer   ,    -- регион
    IN inParentId                Integer   ,    -- ссылка на подразделение
    IN inJuridicalId             Integer   ,    -- ссылка на Юридические лицо
    IN inMarginCategoryId        Integer   ,    -- ссылка на категорию наценок
    IN inProvinceCityId          Integer   ,    -- ссылка на Район
    IN inUserManagerId           Integer   ,    -- ссылка на менеджер
    IN inUnitCategoryId          Integer   ,    -- ссылка на категорию 
    IN inUnitRePriceId           Integer   ,    -- ссылка на подразделение 
    IN inNormOfManDays           Integer   ,    -- Норма человекодней в месяце
    IN inPartnerMedicalId        Integer   ,    -- Мед.учреждение для пкму 1303
    IN inPharmacyItem            Boolean   ,    -- Аптечный пункт
    IN inisGoodsCategory         Boolean   ,    -- 
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbCode_calc    Integer;  
   DECLARE vbOldId        Integer;
   DECLARE vbOldParentId  Integer;
   DECLARE vbCreateDate  TDateTime;
   DECLARE vbCloseDate   TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Unit());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), vbCode_calc);

   -- проверка цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- сохранили
   vbOldId:= ioId;
   -- сохранили
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent() AND ObjectId = ioId);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentId);

   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);

   -- сохранили связь с <Категория наценок>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_MarginCategory(), ioId, inMarginCategoryId);

   -- сохранили связь с <Районом>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_ProvinceCity(), ioId, inProvinceCityId);
   
   -- сохранили связь с <Категорией>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Category(), ioId, inUnitCategoryId);

   -- адрес
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_Address(), ioId, inAddress);

   -- телефон
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_Phone(), ioId, inPhone);

   -- % бонусирования
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_TaxService(), ioId, inTaxService);
   -- % ночной
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_TaxServiceNigth(), ioId, inTaxServiceNigth);

   IF inStartServiceNigth ::Time <> '00:00'
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_StartServiceNigth(), ioId, inStartServiceNigth);
   END IF;
   IF inEndServiceNigth ::Time <> '00:00'
   THEN   
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_EndServiceNigth(), ioId, inEndServiceNigth);
   END IF;

   IF inTaxUnitStartDate ::Time <> '00:00'
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_TaxUnitStart(), ioId, inTaxUnitStartDate);
   ELSE
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_TaxUnitStart(), ioId, NULL);
   END IF;
   IF inTaxUnitEndDate ::Time <> '00:00'
   THEN   
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_TaxUnitEnd(), ioId, inTaxUnitEndDate);
   ELSE
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_TaxUnitEnd(), ioId, NULL);
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_StartSP(), ioId, inStartTimeSP);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_EndSP(), ioId, inEndTimeSP);
     
   IF inisSp = TRUE
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SP(), ioId, inDateSP);
   ELSE 
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SP(), ioId, NULL);
   END IF;

   --
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SP(), ioId, inisSP);
   
   -- участвует в автопереоценке
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_RepriceAuto(), ioId, inisRepriceAuto);

   -- Если добавляли подразделение
   IF vbOldId <> ioId THEN
      -- Установить свойство лист\папка у себя
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- Точно теперь inParentId стал папкой 
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_Unit_Parent());
   END IF;
   
   -- сохранили связь с <менеджер>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UserManager(), ioId, inUserManagerId);
   
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Area(), ioId, inAreaId);
   
   -- сохранили связь с подразделением
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UnitRePrice(), ioId, inUnitRePriceId);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_PartnerMedical(), ioId, inPartnerMedicalId);

   IF inCreateDate <> (CURRENT_DATE + INTERVAL '1 DAY')
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Create(), ioId, inCreateDate);
   ELSE 
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Create(), ioId, NULL);
   END IF;

   IF inCloseDate <> (CURRENT_DATE + INTERVAL '1 DAY')
   THEN   
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Close(), ioId, inCloseDate);
   ELSE 
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Close(), ioId, NULL);
   END IF;
   
   -- Норма человекодней в месяце
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_NormOfManDays(), ioId, inNormOfManDays);

   --сохранили <Аптечный пункт>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_PharmacyItem(), ioId, inPharmacyItem);
   --сохранили <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_GoodsCategory(), ioId, inisGoodsCategory);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$

LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.03.19         *
 15.02.19         * inGoodsCategory
 09.02.19                                                        * add PharmacyItem
 15.01.19         *
 22.10.18         *
 29.08.18         * Phone
 14.05.18                                                        * add NormOfManDays               
 05.05.18                                                        * add UnitCategory               
 20.09.17         * add area
 15.09.17         * 
 08.08.17         * add ProvinceCity
 06.03.17         * add Address
 08.04.16         *
 24.02.16         * 
 14.02.16         * 
 27.06.14         * 
 25.06.13                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Unit ()                            
