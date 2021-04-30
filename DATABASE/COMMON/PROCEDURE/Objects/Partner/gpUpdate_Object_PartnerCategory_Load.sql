-- Function: gpUpdate_Object_PartnerCategory_Load()

DROP FUNCTION IF EXISTS gpUpdate_Object_PartnerCategory_Load (Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_PartnerCategory_Load(
    IN inId              Integer   , --
    IN inCategory        TFloat    , -- Категория
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Category());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;

     -- проверка
     IF COALESCE (inCategory,0) = 0
     THEN
         RETURN;
     END IF;

     -- проверка
     IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inId AND Object.DescId = zc_Object_Partner())
     THEN
         RAISE EXCEPTION 'Ошибка.Контрагент с <Ключ-2> = <%> не найден', inId;
     END IF;

     -- сохранили свойство <inCategory>
     PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_Category(), inId, inCategory);
   
   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.21         *
*/

-- тест
--