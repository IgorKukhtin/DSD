-- Function: gpSelect_Color()

DROP FUNCTION IF EXISTS gpSelect_Color(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Color(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ColorValue Integer, ColorValueDop Integer, ColorName TVarChar, Text1 TVarChar, Text2 TVarChar) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

   RETURN QUERY 
       SELECT zc_Color_Black(),             zc_Color_Black(),            zc_Color_White(), 'zc_Color_Black'             ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Red(),               zc_Color_Red(),              zc_Color_White(), 'zc_Color_Red'               ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Aqua(),              zc_Color_Aqua(),             zc_Color_White(), 'zc_Color_Aqua'              ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Cyan(),              zc_Color_Cyan(),             zc_Color_White(), 'zc_Color_Cyan'              ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_GreenL(),            zc_Color_GreenL(),           zc_Color_White(), 'zc_Color_GreenL'            ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Yelow(),             zc_Color_Yelow(),            zc_Color_Cyan(),  'zc_Color_Yelow'             ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_White(),             zc_Color_White(),            zc_Color_Cyan(),  'zc_Color_White'             ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Blue(),              zc_Color_Blue(),             zc_Color_White(), 'zc_Color_Blue'              ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Goods_Additional(),  zc_Color_Goods_Additional(), zc_Color_White(), 'zc_Color_Goods_Additional'  ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Goods_Alternative(), zc_Color_Goods_Alternative(),zc_Color_Cyan(),  'zc_Color_Goods_Alternative' ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Warning_Red(),       zc_Color_Warning_Red(),      zc_Color_White(), 'zc_Color_Warning_Red'       ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT zc_Color_Warning_Navy(),      zc_Color_Warning_Navy(),     zc_Color_White(), 'zc_Color_Warning_Navy'      ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT 33023,                        33023,                       zc_Color_White(), 'Orange'                     ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT 16257790,                     16257790,                    zc_Color_White(), 'Pink'                       ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT 8388863,                      8388863,                     zc_Color_White(), 'Pink_2'                     ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT 1018911,                      1018911,                     zc_Color_White(), 'Green'                      ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 UNION SELECT 14866996,                     14866996,                    zc_Color_White(), 'Blue'                      ::TVarChar, 'Текст' ::TVarChar, 'Фон' ::TVarChar
 ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Color ('2')
