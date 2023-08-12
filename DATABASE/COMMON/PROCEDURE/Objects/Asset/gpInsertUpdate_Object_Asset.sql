-- Function: gpInsertUpdate_Object_Asset()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Asset(
 INOUT ioId                  Integer   ,    -- ключ объекта < Основные средства>
    IN inCode                Integer   ,    -- Код объекта 
    IN inName                TVarChar  ,    -- Название объекта 
    
    IN inRelease             TDateTime ,    -- Дата выпуска
    
    IN inInvNumber           TVarChar  ,    -- Инвентарный номер
    IN inFullName            TVarChar  ,    -- Полное название ОС
    IN inSerialNumber        TVarChar  ,    -- Заводской номер
    IN inPassportNumber      TVarChar  ,    -- Номер паспорта
    IN inComment             TVarChar  ,    -- Примечание
    
    IN inAssetGroupId        Integer   ,    -- ссылка на группу основных средств
    IN inJuridicalId         Integer   ,    -- ссылка на Юридические лица
    IN inMakerId             Integer   ,    -- ссылка на Производитель (ОС)
    IN inCarId               Integer   ,    -- ссылка на авто
    IN inAssetTypeId         Integer   ,    -- Тип ОС  
    IN inPartionModelId      Integer   ,    -- модель
    
    IN inPeriodUse           TFloat   ,     -- период эксплуатации
    IN inProduction          TFloat   ,     -- Производительность, кг
    IN inKW                  TFloat   ,     -- Потребляемая Мощность KW 
    IN inisDocGoods          Boolean  ,     -- 
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Asset());
   vbUserId:= lpGetUserBySession (inSession);

    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Asset()); 

   
   -- проверка уникальности для свойства <Наименование>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Asset(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Asset(), vbCode_calc);
   -- проверка уникальности для свойства <Инвентарный номер> 
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Asset_InvNumber(), inInvNumber);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Asset(), vbCode_calc, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_InvNumber(), ioId, inInvNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_FullName(), ioId, inFullName);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_SerialNumber(), ioId, inSerialNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_PassportNumber(), ioId, inPassportNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_Comment(), ioId, inComment);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_AssetGroup(), ioId, inAssetGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_Maker(), ioId, inMakerId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_AssetType(), ioId, inAssetTypeId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_PartionModel(), ioId, inPartionModelId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_Car(), ioId, inCarId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_PeriodUse(), ioId, inPeriodUse);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_Production(), ioId, inProduction);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Asset_KW(), ioId, inKW);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Asset_Release(), ioId, inRelease);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Asset_DocGoods(), ioId, inisDocGoods);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.08.23         *
 03.10.22         *
 17.11.20         *
 29.04.20         * add Production
 10.09.18         * add Car
 11.02.14         * add wiki  
 02.07.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Asset()
