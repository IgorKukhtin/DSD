-- Поcтавщики

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Поcтавщики> 
 INOUT ioCode                     Integer,       -- Код объекта <Поcтавщики>  
    IN inBrandId                  Integer   ,    -- ключ объекта <Торговая марка> 
    IN inFabrikaId                Integer   ,    -- ключ объекта <Фабрика производитель> 
    IN inPeriodId                 Integer   ,    -- ключ объекта <Период> 
    IN inPeriodYear               TFloat    ,    -- Год периода
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName   TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);


   -- Расчетное свойство
   vbName:=    COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBrandId), '')
     || '-' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inPeriodId), '')
     || '-' || COALESCE ((inPeriodYear :: Integer) :: TVarChar, '');

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Partner_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_Partner_seq'); 
   END IF; 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), ioCode, vbName);

   -- сохранили связь с <Торговая марка>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Brand(), ioId, inBrandId);
   -- сохранили связь с <Фабрика производитель>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Fabrika(), ioId, inFabrikaId);
   -- сохранили связь с <Период>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Period(), ioId, inPeriodId);

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
08.05.17                                                           *
06.03.17                                                           *
27.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
