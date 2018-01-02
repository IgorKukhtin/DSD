-- Function: gpSelect_MI_Sale_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_Sale_BarCode (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Sale_BarCode(
     IN inBarCode              TVarChar,
     IN inBarCode_str          TVarChar,
     IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (BarCode TVarChar, BarCode_str TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inBarCode, '') <> '' AND COALESCE (inBarCode_str, '') <> ''
     THEN
         RETURN QUERY 
           SELECT NULL :: TVarChar AS BarCode
                , NULL :: TVarChar AS BarCode_str;
     ELSE
         RETURN QUERY 
           SELECT COALESCE (inBarCode, '')     :: TVarChar  AS BarCode
                , COALESCE (inBarCode_str, '') :: TVarChar  AS BarCode_str;     
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.12.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Sale_BarCode (inBarCode:='':: TVarChar, inBarCode_str:='':: TVarChar,inSession:= zfCalc_UserAdmin())
