-- Function: gpInsertUpdate_Object_Partner (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Поcтавщики> 
    IN inCode                     Integer,       -- Код объекта <Поcтавщики>  
    IN inBrandId                  Integer   ,    -- ключ объекта <Торговая марка> 
    IN inFabrikaId                Integer   ,    -- ключ объекта <Фабрика производитель> 
    IN inPeriodId                 Integer   ,    -- ключ объекта <Период> 
    IN inPeriodYear               TFloat    ,    -- Год периода
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   select coalesce(vbName,'')|| coalesce(valuedata,'') into vbName from object where id = inBrandId;
   select coalesce(vbName,'')|| coalesce('-'||valuedata,'') into vbName from object where id = inPeriodId;
   select coalesce(vbName,'')|| coalesce('-'||inPeriodYear::integer::Tvarchar,'') into vbName;

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Partner_seq'); END IF; 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, vbName);

   -- сохранили связь с <Торговая марка>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Brand(), ioId, inBrandId);
   -- сохранили связь с <Фабрика производитель>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Fabrika(), ioId, inFabrikaId);
   -- сохранили связь с <Период>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Period(), ioId, inPeriodId);

   -- сохранили <Год периода>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_PeriodYear(), ioId, inPeriodYear);
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
06.03.17                                                           *
27.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
