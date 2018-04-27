-- Function: gpGet_Object_GoodsPrint_Null (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsPrint_Null (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsPrint_Null(
   OUT outOrd              Integer,      -- № п/п сессии GoodsPrint
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserId           Integer,      -- Пользователь сессии GoodsPrint
   OUT outUserName         TVarChar,     --
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   outUserId:= lpGetUserBySession (inSession);

   -- Результат
   outOrd           := 0 ;
   outGoodsPrintName:= '';
   outUserName      := lfGet_Object_ValueData_sh (outUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
27.04.18          *
*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsPrint_Null (inSession:= zfCalc_UserAdmin());
