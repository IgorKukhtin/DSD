-- Function: gpUpdate_Object_Retail_KAM_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_KAM_Load (Integer, TVarChar, TVarChar, TVarChar);
-- 1)Код сети (информативно) 2) назв  (по нему заливаем) 3) ФИО - по нему ищем основное место для Personal, если не нашли - ошибка

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_KAM_Load(
    IN inRetailCode     Integer   , --
    IN inRetailName     TVarChar  ,
    IN inKAMName        TVarChar  ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
           vbRetailId   Integer;
           vbPersonalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Retail());
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Retail_KAM());

     IF COALESCE (inRetailName,'') = ''
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inKAMName,'') = ''
     THEN
         RETURN;
     END IF;

     -- находим торговую сеть
     vbRetailId := (SELECT Object.Id FROM Object WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inRetailName)) AND Object.DescId = zc_Object_Retail() Limit 1);
     
     IF COALESCE (vbRetailId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Торговая сеть <(%) %> не найдена', inRetailCode, inRetailName;
     END IF;

     -- находим ищем основное место для Personal
     vbPersonalId := (SELECT Object.Id
                      FROM Object
                           INNER JOIN ObjectBoolean ON ObjectBoolean.ObjectId = Object.Id
                                                   AND ObjectBoolean.DescId = zc_ObjectBoolean_Personal_Main()
                                                   AND ObjectBoolean.ValueData = TRUE
                      WHERE Object.DescId = zc_Object_Personal()
                        AND TRIM (Object.ValueData) ILIKE TRIM (inKAMName)      --Лаврик Світлана Миколаївна
                        AND Object.isErased = FALSE
                     );

     IF COALESCE (vbPersonalId,0) = 0
     THEN
         --
         RAISE EXCEPTION 'Ошибка. Сотрудник <(%)> не найден', inKAMName; 
     END IF;
     
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_KAM(), vbRetailId, vbPersonalId);
     
     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (vbRetailId, vbUserId);
   
     if vbUserId = 9457 then  RAISE EXCEPTION 'Test admin.Ok'; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.26         *
*/

-- тест
--