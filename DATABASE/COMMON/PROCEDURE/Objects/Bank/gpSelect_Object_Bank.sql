-- Function: gpSelect_Object_Bank(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Bank(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Bank(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MFO TVarChar, SWIFT TVarChar, IBAN TVarChar 
             , SummMax TFloat
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT
       Object.Id                    AS Id
     , Object.ObjectCode            AS Code
     , Object.ValueData             AS Name
     , ObjectString_MFO.ValueData   AS MFO
     , ObjectString_SWIFT.ValueData AS SWIFT
     , ObjectString_IBAN.ValueData  AS IBAN
     , ObjectFloat_SummMax.ValueData ::TFloat AS SummMax
     , Object.isErased
     FROM Object
        LEFT JOIN ObjectString AS ObjectString_MFO
                               ON ObjectString_MFO.ObjectId = Object.Id
                              AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
        LEFT JOIN ObjectString AS ObjectString_SWIFT
                               ON ObjectString_SWIFT.ObjectId = Object.Id
                              AND ObjectString_SWIFT.DescId = zc_ObjectString_Bank_SWIFT()
        LEFT JOIN ObjectString AS ObjectString_IBAN
                               ON ObjectString_IBAN.ObjectId = Object.Id
                              AND ObjectString_IBAN.DescId = zc_ObjectString_Bank_IBAN()

        LEFT JOIN ObjectFloat AS ObjectFloat_SummMax
                              ON ObjectFloat_SummMax.ObjectId = Object.Id 
                             AND ObjectFloat_SummMax.DescId = zc_ObjectFloat_Bank_SummMax()

     WHERE Object.DescId = zc_Object_Bank()
   UNION
     SELECT
       0                    AS Id
     , 0                    AS Code
     , 'Удалить'::TVarChar  AS Name
     , ''::TVarChar         AS MFO
     , ''::TVarChar         AS SWIFT
     , ''::TVarChar         AS IBAN  
     , 0 ::TFloat           AS SummMax
     , FALSE ::Boolean      AS isErased
     ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Bank (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.03.24         *
 10.10.14                                                       *
 17.06.14                         *
 19.02.14                                        *
 10.06.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Bank('2')