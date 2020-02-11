-- Function: gpSelect_StickerProperty_Value()

DROP FUNCTION IF EXISTS gpSelect_StickerProperty_Value (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_StickerProperty_Value(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat
             , Value5 TFloat, Value6 TFloat, Value7 TFloat
             , Value8 TFloat, Value9 TFloat, Value10 TFloat
             , Id Integer, Name TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_StickerProperty());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT DISTINCT
              ObjectFloat_Value1.ValueData       AS Value1
            , ObjectFloat_Value2.ValueData       AS Value2
            , ObjectFloat_Value3.ValueData       AS Value3
            , ObjectFloat_Value4.ValueData       AS Value4
            , ObjectFloat_Value5.ValueData       AS Value5
            , ObjectFloat_Value6.ValueData       AS Value6
            , ObjectFloat_Value7.ValueData       AS Value7
            , ObjectFloat_Value8.ValueData       AS Value8
            , ObjectFloat_Value9.ValueData       AS Value9
            , ObjectFloat_Value10.ValueData      AS Value10
            
            , 0               AS Id
            , '' :: TVarChar  AS Name

       FROM Object AS Object_StickerProperty
            LEFT JOIN ObjectFloat AS ObjectFloat_Value1
                                  ON ObjectFloat_Value1.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectFloat_Value1.DescId = zc_ObjectFloat_StickerProperty_Value1()

            LEFT JOIN ObjectFloat AS ObjectFloat_Value2
                                  ON ObjectFloat_Value2.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectFloat_Value2.DescId = zc_ObjectFloat_StickerProperty_Value2()

            LEFT JOIN ObjectFloat AS ObjectFloat_Value3
                                  ON ObjectFloat_Value3.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectFloat_Value3.DescId = zc_ObjectFloat_StickerProperty_Value3()

            LEFT JOIN ObjectFloat AS ObjectFloat_Value4
                                  ON ObjectFloat_Value4.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectFloat_Value4.DescId = zc_ObjectFloat_StickerProperty_Value4()

            LEFT JOIN ObjectFloat AS ObjectFloat_Value5
                                  ON ObjectFloat_Value5.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectFloat_Value5.DescId = zc_ObjectFloat_StickerProperty_Value5()

            LEFT JOIN ObjectFloat AS ObjectFloat_Value6
                                  ON ObjectFloat_Value6.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectFloat_Value6.DescId = zc_ObjectFloat_StickerProperty_Value6()

            LEFT JOIN ObjectFloat AS ObjectFloat_Value7
                                  ON ObjectFloat_Value7.ObjectId = Object_StickerProperty.Id 
                                 AND ObjectFloat_Value7.DescId = zc_ObjectFloat_StickerProperty_Value7()
             -- Т мін - второй срок 
             LEFT JOIN ObjectFloat AS ObjectFloat_Value8
                                   ON ObjectFloat_Value8.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value8.DescId = zc_ObjectFloat_StickerProperty_Value8()
             -- Т макс - второй срок
             LEFT JOIN ObjectFloat AS ObjectFloat_Value9
                                   ON ObjectFloat_Value9.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value9.DescId = zc_ObjectFloat_StickerProperty_Value9()
             -- кількість діб - второй срок
             LEFT JOIN ObjectFloat AS ObjectFloat_Value10
                                   ON ObjectFloat_Value10.ObjectId = Object_StickerProperty.Id 
                                  AND ObjectFloat_Value10.DescId = zc_ObjectFloat_StickerProperty_Value10()
                                  
       WHERE Object_StickerProperty.DescId = zc_Object_StickerProperty()
         AND Object_StickerProperty.isErased = FALSE
                  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_StickerProperty_Value ( zfCalc_UserAdmin())
