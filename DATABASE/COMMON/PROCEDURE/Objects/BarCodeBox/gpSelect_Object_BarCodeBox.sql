-- Function: gpSelect_Object_BarCodeBox (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BarCodeBox (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BarCodeBox(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , BarCode TVarChar
             , Weight TFloat
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_BarCodeBox());

   RETURN QUERY 
       SELECT
             Object_BarCodeBox.Id         AS Id
           , Object_BarCodeBox.ObjectCode AS Code
                      
           , Object_Box.Id         AS BoxId 
           , Object_Box.ObjectCode AS BoxCode
           , Object_Box.ValueData  AS BoxName            

           , ObjectString_BarCode.ValueData  AS BarCode
           , ObjectFloat_Weight.ValueData    AS Weight

           , Object_BarCodeBox.isErased   AS isErased
           
       FROM Object AS Object_BarCodeBox
            LEFT JOIN ObjectLink AS ObjectLink_BarCodeBox_Box
                                 ON ObjectLink_BarCodeBox_Box.ObjectId = Object_BarCodeBox.Id
                                AND ObjectLink_BarCodeBox_Box.DescId = zc_ObjectLink_BarCodeBox_Box()
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_BarCodeBox_Box.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_BarCodeBox.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_BarCodeBox_Weight()

            LEFT JOIN ObjectString AS ObjectString_BarCode
                                   ON ObjectString_BarCode.ObjectId = Object_BarCodeBox.Id
                                  AND ObjectString_BarCode.DescId = zc_ObjectString_BarCodeBox_BarCode()

   WHERE Object_BarCodeBox.DescId = zc_Object_BarCodeBox();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.19          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_BarCodeBox('2')
