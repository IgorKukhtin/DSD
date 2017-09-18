-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_Params(Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_Params(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inCreateDate          TDateTime ,    -- дата создания точки
    IN inCloseDate           TDateTime ,    -- дата закрытия точки
    IN inUserManagerId       Integer   ,    -- ссылка на менеджер
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
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
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_Params());
   --vbUserId := lpGetUserBySession (inSession);

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
   
   IF (inCreateDate is not NULL) OR (vbCreateDate is not NULL)
   THEN
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Create(), inId, inCreateDate);
   END IF;

   IF (inCloseDate is not NULL) OR (vbCloseDate is not NULL)
   THEN   
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Close(), inId, inCloseDate);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 15.09.17         *

*/