-- Function: gpInsertUpdate_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer,Integer, Integer, Boolean, TVarChar, TBlob, TVarChar, TVarChar, TFloat, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettings(
 INOUT ioId                      Integer   ,   	-- ключ объекта <>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inJuridicalId             Integer   ,    -- ссылка на главное юр.лицо
    IN inContractId              Integer   ,    -- ссылка на 
    IN inFileTypeId              Integer   ,    -- ссылка на 
    IN inImportTypeId            Integer   ,    -- ссылка на  
    IN inEmailId                 Integer   ,    -- ссылка на  
    IN inContactPersonId         Integer   ,    -- ссылка на контактное лицо
    IN inStartRow                Integer   ,    -- 
    IN inHDR                     Boolean   ,    -- 
    IN inDirectory               TVarChar  ,    --  
    IN inQuery                   TBlob     , 
    IN inStartTime               TVarChar  ,
    IN inEndTime                 TVarChar  ,
    IN inTime                    TFloat    ,
    IN inIsMultiLoad             Boolean   ,
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
   DECLARE vbStartTime TDateTime;  
   DECLARE vbEndTime TDateTime;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportSettings());
   -- vbUserId := lpGetUserBySession (inSession); 
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ImportSettings());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ImportSettings(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ImportSettings(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportSettings(), vbCode_calc, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_Contract(), ioId, inContractId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_FileType(), ioId, inFileTypeId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_ImportType(), ioId, inImportTypeId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_Email(), ioId, inEmailId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_ContactPerson(), ioId, inContactPersonId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ImportSettings_HDR(), ioId, inHDR);

   -- сохранили свойство <Много раз загружать прайс>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ImportSettings_MultiLoad(), ioId, inIsMultiLoad);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjecTFloat_ImportSettings_StartRow(), ioId, inStartRow);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjecTFloat_ImportSettings_Time(), ioId, inTime);

   IF COALESCE(inStartTime,'') <> '' 
   THEN 
       vbStartTime:= ( '' ||CURRENT_DATE::Date || ' '||inStartTime ::Time):: TDateTime;
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ImportSettings_StartTime(), ioId, vbStartTime);
   END IF;
   IF COALESCE(inEndTime,'') <> '' 
   THEN 
       vbEndTime  := ( '' ||CURRENT_DATE::Date || ' '||inEndTime ::Time):: TDateTime;
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ImportSettings_EndTime(), ioId, vbEndTime);
   END IF;
   
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportSettings_Directory(), ioId, inDirectory);

   PERFORM lpInsertUpdate_ObjectBlob(zc_ObjectBlob_ImportSettings_Query(), ioId, inQuery);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.03.16         *
 16.09.14                         * 
 09.09.14                         * 
 02.07.14         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ImportSettings ()                            
-- select * from gpInsertUpdate_Object_ImportSettings(ioId := 0 , inCode := 0 , inName := 'иом' , inJuridicalId := 141 , inContractId := 151 , inFileTypeId := 0 , inImportTypeId := 0 , inStartRow := 0 , inDirectory := 'ьмь' ,  inSession := '8');
