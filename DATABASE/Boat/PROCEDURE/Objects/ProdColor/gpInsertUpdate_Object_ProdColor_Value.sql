-- Цвет

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColor_Value (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColor_Value(
    IN inName            TVarChar,      -- главное Название  цвета
    IN inValue           TVarChar,      --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;  
   DECLARE vbColor_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProdColor());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF NOT EXISTS (SELECT 1
                  FROM Object AS Object_ProdColor
                  WHERE Object_ProdColor.DescId    = zc_Object_ProdColor()
                   -- с таким названием Цвета
                   AND Object_ProdColor.ValueData ILIKE inName)
   THEN
     PERFORM gpInsertUpdate_Object_ProdColor(ioId        := 0
                                           , ioCode      := 0
                                           , inName      := inName
                                           , inComment   := ''
                                           , inValue     := inValue
                                           , inSession   := inSession
                                            );
     
   ELSE
      PERFORM gpUpdate_Object_ProdColor_Value (inId      := Object_ProdColor.Id
                                             , inValue   := inValue
                                             , inSession := inSession)          
      FROM Object AS Object_ProdColor
             
           LEFT JOIN ObjectString AS OS_ProdColor_Value
                                  ON OS_ProdColor_Value.DescId    = zc_ObjectString_ProdColor_Value()
                                 AND OS_ProdColor_Value.ObjectId  = Object_ProdColor.Id
                  
      WHERE Object_ProdColor.DescId    = zc_Object_ProdColor()
        -- с таким Цветом
        AND Object_ProdColor.ValueData ILIKE inName
        -- и если цвет отличаеться
        AND COALESCE(OS_ProdColor_Value.ValueData, '') NOT ILIKE inValue;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.09.22                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_ProdColor_Value()