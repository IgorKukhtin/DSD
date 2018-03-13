-- Function: gpUpdate_FloatValue_DS (TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_FloatValue_DS (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_FloatValue_DS(
    IN inValue    TFloat,       --
   OUT outValue   TFloat,       --
    IN inSession  TVarChar      -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
BEGIN

   -- Результат
   outValue:= inValue;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 24.02.18                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_FloatValue_DS (inSession := zfCalc_UserAdmin());
