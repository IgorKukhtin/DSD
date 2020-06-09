-- Название для ценника

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label_Load (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Label_Load(
    IN inName         TVarChar,      -- Название объекта <Название для ценника>
    IN inName_RUS     TVarChar,      -- Название объекта <Название для ценника> русс
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());
   vbUserId:= lpGetUserBySession (inSession);


   --  сначала ищем в ObjectString_RUS.ValueData
   vbId := (SELECT ObjectString.ObjectId FROM ObjectString WHERE ObjectString.DescId = zc_ObjectString_Label_RUS() AND UPPER (TRIM (ObjectString.ValueData) ) = UPPER (TRIM (inName_RUS)) );
   
   -- если не нашли в русс пробуем найти в Object.ValueData (актуально для первой загрузки, когда еще все русс. назв. пустые)
   IF COALESCE (vbId,0) = 0
   THEN
       vbId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Label() AND Object.isErased = FALSE AND UPPER (TRIM (Object.ValueData) ) = UPPER (TRIM (inName_RUS) ) );
   END IF;

   -- если нашли записываем свойства
   IF COALESCE (vbId,0) <> 0
   THEN
        PERFORM gpInsertUpdate_Object_Label(ioId       := vbId
                                          , ioCode     := 0
                                          , inName     := TRIM (inName)     :: TVarChar
                                          , inName_RUS := TRIM (inName_RUS) :: TVarChar
                                          , inSession  := inSession
                                          );
   END IF;   
   
   -- если не нашли ничего не делаем 

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
09.06.20          *
*/

-- тест
--