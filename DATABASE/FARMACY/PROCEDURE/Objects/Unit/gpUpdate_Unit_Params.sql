-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_Params(Integer, TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Unit_Params(Integer, TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Unit_Params(Integer, TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Unit_Params(Integer, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_Params(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
 INOUT ioCreateDate          TDateTime ,    -- дата создания точки
 INOUT ioCloseDate           TDateTime ,    -- дата закрытия точки
    IN inUserManagerId       Integer   ,    -- ссылка на менеджер
    IN inUserManager2Id      Integer   ,    -- ссылка на менеджер 2
    IN inUserManager3Id      Integer   ,    -- ссылка на менеджер 3
    IN inAreaId              Integer   ,    -- регион
    IN inUnitRePriceId       Integer   ,    -- ссылка на подразделение 
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbCreateDate TDateTime;
   DECLARE vbCloseDate  TDateTime;
   
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_Params());
   vbUserId := lpGetUserBySession (inSession);

   -- находим предыдущее значение если есть
   vbCreateDate := (SELECT ObjectDate_Create.ValueData
                    FROM ObjectDate AS ObjectDate_Create
                    WHERE ObjectDate_Create.DescId = zc_ObjectDate_Unit_Create()
                      AND ObjectDate_Create.ObjectId = inId);
   vbCloseDate := (SELECT ObjectDate_Close.ValueData
                    FROM ObjectDate AS ObjectDate_Close
                    WHERE ObjectDate_Close.DescId = zc_ObjectDate_Unit_Close()
                      AND ObjectDate_Close.ObjectId = inId);

   -- сохранили связь с <менеджер>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UserManager(), inId, inUserManagerId);
   -- сохранили связь с <менеджер 2>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UserManager2(), inId, inUserManager2Id);
   -- сохранили связь с <менеджер 3>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UserManager3(), inId, inUserManager3Id);

   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Area(), inId, inAreaId);
   
   -- сохранили связь с подразделением
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UnitRePrice(), inId, inUnitRePriceId);
   
   IF (ioCreateDate is not NULL) OR (vbCreateDate is not NULL)
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Create(), inId, ioCreateDate);
   END IF;

   IF (ioCloseDate is not NULL) OR (vbCloseDate is not NULL)
   THEN   
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Close(), inId, ioCloseDate);
   END IF;

   -- если дата = завтра тогда обнуляем значение
   IF ioCreateDate = (CURRENT_DATE + INTERVAL '1 DAY')
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Create(), inId, NULL);
       ioCreateDate := Null ::TDatetime;
   END IF;

   IF ioCloseDate = (CURRENT_DATE + INTERVAL '1 DAY')
   THEN   
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Close(), inId, NULL);
       ioCloseDate := Null ::TDatetime;
   END IF;
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.19         *
 20.09.17         *
 15.09.17         *
*/