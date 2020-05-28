-- Function: gpSelect_Object_BarCodeBox (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BarCodeBox (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_BarCodeBox (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BarCodeBox(
    IN inShowAll        Boolean  ,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , BarCode TVarChar, BarCode_Value TFloat
             , Weight TFloat, AmountPrint TFloat
             , isErased Boolean
             ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_BarCodeBox());

   RETURN QUERY
   WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
       SELECT
             Object_BarCodeBox.Id         AS Id
           , Object_BarCodeBox.ObjectCode AS Code

           , Object_Box.Id         AS BoxId
           , Object_Box.ObjectCode AS BoxCode
           , Object_Box.ValueData  AS BoxName

           , Object_BarCodeBox.ValueData     AS BarCode
           , CASE WHEN POSITION ('-' IN Object_BarCodeBox.ValueData) > 0
                  THEN zfConvert_StringToFloat (RIGHT (Object_BarCodeBox.ValueData , LENGTH(Object_BarCodeBox.ValueData) - POSITION ('-' IN Object_BarCodeBox.ValueData) ))-- (RIGHT (Object_BarCodeBox.ValueData , LENGTH(Object_BarCodeBox.ValueData) - POSITION ('-' IN Object_BarCodeBox.ValueData))) :: integer
                  ELSE zfConvert_StringToFloat (Object_BarCodeBox.ValueData)
             END  :: TFloat AS BarCode_Value
           , ObjectFloat_Weight.ValueData    AS Weight
           , ObjectFloat_Print.ValueData     AS AmountPrint

           , Object_BarCodeBox.isErased   AS isErased

       FROM Object AS Object_BarCodeBox
            INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_BarCodeBox.isErased

            LEFT JOIN ObjectLink AS ObjectLink_BarCodeBox_Box
                                 ON ObjectLink_BarCodeBox_Box.ObjectId = Object_BarCodeBox.Id
                                AND ObjectLink_BarCodeBox_Box.DescId = zc_ObjectLink_BarCodeBox_Box()
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_BarCodeBox_Box.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_BarCodeBox.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_BarCodeBox_Weight()

            LEFT JOIN ObjectFloat AS ObjectFloat_Print
                                  ON ObjectFloat_Print.ObjectId = Object_BarCodeBox.Id
                                 AND ObjectFloat_Print.DescId = zc_ObjectFloat_BarCodeBox_Print()

      WHERE Object_BarCodeBox.DescId = zc_Object_BarCodeBox();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.05.20         *
 14.05.19         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_BarCodeBox(false, '2')