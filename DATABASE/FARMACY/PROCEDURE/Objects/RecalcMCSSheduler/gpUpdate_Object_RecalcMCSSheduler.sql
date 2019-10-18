-- Function: gpUpdate_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpUpdate_Object_RecalcMCSSheduler(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_RecalcMCSSheduler(
    IN inId                      Integer   ,   	-- ключ объекта <>
    IN inSelectRun               Boolean,
   OUT outSelectRun              Boolean,
    IN inSession                 TVarChar       -- Сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;
   DECLARE RetailId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;
   
   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Документ не сохранен..';
   END IF;

   --сохранили
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_RecalcMCSSheduler_SelectRun(), inId, inSelectRun);
   
   outSelectRun := COALESCE((SELECT ObjectBoolean.ValueData FROM ObjectBoolean 
                             WHERE ObjectBoolean.ObjectID = inId
                               AND ObjectBoolean.DescId = zc_ObjectBoolean_RecalcMCSSheduler_SelectRun()), False);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_RecalcMCSSheduler(Integer, Boolean, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.02.19                                                       *
 21.12.18                                                       *

*/