-- Function: lpInsertFind_Object_PartionModel (TVarChar, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionModel (TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionModel(
    IN inPartionModelName TVarChar, -- Группа счетов
    IN inUserId           Integer   -- Пользователь
)
RETURNS Integer
AS
$BODY$
  DECLARE vbPartionModelId Integer;
BEGIN

   -- Проверки
   IF COALESCE (TRIM (inPartionModelName), '') = ''
   THEN
       vbPartionModelId:= 0;
   ELSE
       vbPartionModelId:= (SELECT Id  FROM Object WHERE DescId = zc_Object_PartionModel() AND ValueData ILIKE inPartionModelName);
       --
       IF COALESCE (vbPartionModelId, 0) = 0
       THEN
           -- сохранили <Объект>
           vbPartionModelId := lpInsertUpdate_Object (vbPartionModelId, zc_Object_PartionModel(), 0, inPartionModelName);

       END IF;

   END IF;
   
   -- Возвращаем значение
   RETURN vbPartionModelId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.05.23                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionModel (inPartionModelName:= 'светлый', inUserId:= 5)
