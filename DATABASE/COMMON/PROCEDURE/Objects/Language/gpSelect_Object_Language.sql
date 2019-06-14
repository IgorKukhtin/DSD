-- Function: gpSelect_Object_Language (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Language (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Language(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , Value1 TVarChar
             , Value2 TVarChar
             , Value3 TVarChar
             , Value4 TVarChar
             , Value5 TVarChar
             , Value6 TVarChar
             , Value7 TVarChar
             , Value8 TVarChar
             , Value9 TVarChar
             , Value10 TVarChar
             , Value11 TVarChar
             , Value12 TVarChar
             , Value13 TVarChar
             , Value14 TVarChar
             , Value15 TVarChar
             , Value16 TVarChar
             , Value17 TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Language());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
       SELECT
             Object_Language.Id          AS Id
           , Object_Language.ObjectCode  AS Code
           , Object_Language.ValueData   AS Name

           , ObjectString_Comment.ValueData AS Comment
           , ObjectString_Value1.ValueData  AS Value1
           , ObjectString_Value2.ValueData  AS Value2
           , ObjectString_Value3.ValueData  AS Value3
           , ObjectString_Value4.ValueData  AS Value4
           , ObjectString_Value5.ValueData  AS Value5
           , ObjectString_Value6.ValueData  AS Value6
           , ObjectString_Value7.ValueData  AS Value7
           , ObjectString_Value8.ValueData  AS Value8
           , ObjectString_Value9.ValueData  AS Value9
           , ObjectString_Value10.ValueData AS Value10
           , ObjectString_Value11.ValueData AS Value11
           , ObjectString_Value12.ValueData AS Value12
           , ObjectString_Value13.ValueData AS Value13
           , ObjectString_Value14.ValueData AS Value14
           , ObjectString_Value15.ValueData AS Value15
           , ObjectString_Value16.ValueData AS Value16
           , ObjectString_Value17.ValueData AS Value17

           , Object_Language.isErased    AS isErased

       FROM tmpIsErased
            INNER JOIN Object AS Object_Language
                              ON Object_Language.isErased = tmpIsErased.isErased
                             AND Object_Language.DescId = zc_Object_Language()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Language.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Language_Comment()

            LEFT JOIN ObjectString AS ObjectString_Value1
                                   ON ObjectString_Value1.ObjectId = Object_Language.Id
                                  AND ObjectString_Value1.DescId = zc_ObjectString_Language_Value1()
            LEFT JOIN ObjectString AS ObjectString_Value2
                                   ON ObjectString_Value2.ObjectId = Object_Language.Id
                                  AND ObjectString_Value2.DescId = zc_ObjectString_Language_Value2()
            LEFT JOIN ObjectString AS ObjectString_Value3
                                   ON ObjectString_Value3.ObjectId = Object_Language.Id
                                  AND ObjectString_Value3.DescId = zc_ObjectString_Language_Value3()
            LEFT JOIN ObjectString AS ObjectString_Value4
                                   ON ObjectString_Value4.ObjectId = Object_Language.Id
                                  AND ObjectString_Value4.DescId = zc_ObjectString_Language_Value4()
            LEFT JOIN ObjectString AS ObjectString_Value5
                                   ON ObjectString_Value5.ObjectId = Object_Language.Id
                                  AND ObjectString_Value5.DescId = zc_ObjectString_Language_Value5()
            LEFT JOIN ObjectString AS ObjectString_Value6
                                   ON ObjectString_Value6.ObjectId = Object_Language.Id
                                  AND ObjectString_Value6.DescId = zc_ObjectString_Language_Value6()
            LEFT JOIN ObjectString AS ObjectString_Value7
                                   ON ObjectString_Value7.ObjectId = Object_Language.Id
                                  AND ObjectString_Value7.DescId = zc_ObjectString_Language_Value7()
            LEFT JOIN ObjectString AS ObjectString_Value8
                                   ON ObjectString_Value8.ObjectId = Object_Language.Id
                                  AND ObjectString_Value8.DescId = zc_ObjectString_Language_Value8()
            LEFT JOIN ObjectString AS ObjectString_Value9
                                   ON ObjectString_Value9.ObjectId = Object_Language.Id
                                  AND ObjectString_Value9.DescId = zc_ObjectString_Language_Value9()
            LEFT JOIN ObjectString AS ObjectString_Value10
                                   ON ObjectString_Value10.ObjectId = Object_Language.Id
                                  AND ObjectString_Value10.DescId = zc_ObjectString_Language_Value10()
            LEFT JOIN ObjectString AS ObjectString_Value11
                                   ON ObjectString_Value11.ObjectId = Object_Language.Id
                                  AND ObjectString_Value11.DescId = zc_ObjectString_Language_Value11()
            LEFT JOIN ObjectString AS ObjectString_Value12
                                   ON ObjectString_Value12.ObjectId = Object_Language.Id
                                  AND ObjectString_Value12.DescId = zc_ObjectString_Language_Value12()
            LEFT JOIN ObjectString AS ObjectString_Value13
                                   ON ObjectString_Value13.ObjectId = Object_Language.Id
                                  AND ObjectString_Value13.DescId = zc_ObjectString_Language_Value13()
            LEFT JOIN ObjectString AS ObjectString_Value14
                                   ON ObjectString_Value14.ObjectId = Object_Language.Id
                                  AND ObjectString_Value14.DescId = zc_ObjectString_Language_Value14()
            LEFT JOIN ObjectString AS ObjectString_Value15
                                   ON ObjectString_Value15.ObjectId = Object_Language.Id
                                  AND ObjectString_Value15.DescId = zc_ObjectString_Language_Value15()
            LEFT JOIN ObjectString AS ObjectString_Value16
                                   ON ObjectString_Value16.ObjectId = Object_Language.Id
                                  AND ObjectString_Value16.DescId = zc_ObjectString_Language_Value16()
            LEFT JOIN ObjectString AS ObjectString_Value17
                                   ON ObjectString_Value17.ObjectId = Object_Language.Id
                                  AND ObjectString_Value17.DescId = zc_ObjectString_Language_Value17()
       ORDER BY Object_Language.ObjectCode
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.19         *
 10.10.18         *
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Language (FALSE, zfCalc_UserAdmin())
