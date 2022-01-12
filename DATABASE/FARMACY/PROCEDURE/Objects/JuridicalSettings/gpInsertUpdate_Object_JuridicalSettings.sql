-- Function: gpInsertUpdate_Object_()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalSettings(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Установки для ценовых групп>
    IN inName                    TVarChar  ,    -- Наименование (Номер договора)
    IN inJuridicalId             Integer   ,    -- Юр. лицо
    IN inMainJuridicalId         Integer   ,    -- Юр. лицо
    IN inContractId              Integer   ,    -- Договор
    IN inisBonusVirtual          Boolean   ,    -- Виртуальный бонус
    IN inisPriceClose            Boolean   ,    -- Закрыт прайс
    IN inisPriceCloseOrder       Boolean   ,    -- Закрыт прайс для заказа
    IN inisSite                  Boolean   ,    -- для сайта
    IN inisBonusClose            Boolean   ,    -- Не учитывать бонусы
    IN inBonus                   TFloat    ,    -- % бонусирования
    IN inPriceLimit              TFloat    ,    -- Цена до
    IN inConditionalPercent      TFloat    ,    -- Доп.условия по прайсу, %
    IN inStartDate               TDateTime ,    -- 
    IN inEndDate                 TDateTime ,    -- 
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   IF COALESCE (ioId, 0) = 0
   THEN
     vbCode_calc:= lfGet_ObjectCode (0, zc_Object_JuridicalSettings());
   ELSE
     vbCode_calc:= (SELECT ObjectCode from Object WHERE Object.Id = ioId);
   END IF;

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalSettings(), vbCode_calc, inName);

   -- сохранили связь с <Торговой сетью>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Retail(), ioId, vbObjectId);

   -- сохранили связь с <Юр. лицом>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Juridical(), ioId, inJuridicalId);

   -- сохранили связь с <Юр. лицом>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_MainJuridical(), ioId, inMainJuridicalId);

   -- сохранили связь с <Договор>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Contract(), ioId, inContractId);

   -- прайс закрыт
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_JuridicalSettings_isPriceClose(), ioId, inisPriceClose);
   -- прайс закрыт для заказа
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder(), ioId, inisPriceCloseOrder);
   -- прайс закрыт
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_JuridicalSettings_isBonusClose(), ioId, inisBonusClose);

   -- % бонусирования
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettings_Bonus(), ioId, inBonus);
   -- Цена до
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettings_PriceLimit(), ioId, inPriceLimit);

   -- Доп.условия по прайсу, %
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_ConditionalPercent(), inJuridicalId, inConditionalPercent);

   -- сохранили свойство <Виртуальный бонус>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_BonusVirtual(), ioId, inisBonusVirtual);

   -- сохранили свойство <для сайта>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_Site(), ioId, inisSite);


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Start(), ioId, inStartDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_End(), ioId, inEndDate);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_JuridicalSettings_PriceList(Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.02.19         * inisBonusClose
 22.10.18         *
 14.11.16         * add BonusVirtual
 13.04.16         *
 18.02.16         *
 11.02.16
 26.01.16         *                
 17.02.15                          *
 21.01.15                          *
 13.10.14                          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_JuridicalSettings ()           

--select * from gpInsertUpdate_Object_JuridicalSettings(ioId := 390626 , inName := '4456' , inJuridicalId := 59610 , inMainJuridicalId := 393053 , inContractId := 183275 , inisPriceClose := 'False' , inBonus := 0 , InStartDate := ('NULL')::TDateTime , inEndDate := ('NULL')::TDateTime ,  inSession := '3');                 