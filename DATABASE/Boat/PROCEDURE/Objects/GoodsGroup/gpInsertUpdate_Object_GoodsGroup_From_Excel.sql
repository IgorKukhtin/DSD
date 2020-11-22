-- Function: gpInsertUpdate_Object_GoodsGroup_From_Excel (Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_From_Excel (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup_From_Excel(
    IN inCode                     Integer   ,    -- Код объекта <Группа товара>
    IN inName                     TVarChar  ,    -- Название объекта <Группа товара>
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());
   vbUserId:= lpGetUserBySession (inSession);

   --проверка есть ли уже такая группа
   IF EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND TRIM (Object.ValueData) ILIKE TRIM(inName))
   THEN
     --RAISE EXCEPTION 'Ошибка.Уже существует <%>.', inName;
       RETURN;
   END IF;

   PERFORM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                           , ioCode            := inCode    :: Integer
                                           , inName            := inName    :: TVarChar
                                           , inParentId        := 0         :: Integer
                                           , inInfoMoneyId     := 0         :: Integer
                                           , inModelEtiketenId := 0         :: Integer
                                           , inSession         := inSession :: TVarChar
                                            );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
09.11.20          *
*/

-- тест
--