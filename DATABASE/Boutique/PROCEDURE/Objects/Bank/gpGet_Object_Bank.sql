-- Function: gpGet_Object_Bank(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Bank (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Bank(
    IN inId          Integer,       -- Подразделения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, MFO TVarChar, SWIFT TVarChar, IBAN TVarChar, JuridicalId Integer, JuridicalName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Bank());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                          AS Id
           , lfGet_ObjectCode(0, zc_Object_Bank())  AS Code
           , '' :: TVarChar                         AS Name
           , '' :: TVarChar                         AS MFO
           , '' :: TVarChar                         AS SWIFT
           , '' :: TVarChar                         AS IBAN
           ,  0 :: Integer                          AS JuridicalId      
           , '' :: TVarChar                         AS JuridicalName    

       ;
   ELSE
       RETURN QUERY
       SELECT 
             Object_Bank.Id                  AS Id
           , Object_Bank.ObjectCode          AS Code
           , Object_Bank.ValueData           AS Name
           , OS_Bank_MFO.ValueData           AS MFO
           , OS_Bank_SWIFT.ValueData         As SWIFT
           , OS_Bank_IBAN.ValueData          AS IBAN
           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName
       
       FROM Object AS Object_Bank
            LEFT JOIN ObjectString AS OS_Bank_MFO
                                   ON OS_Bank_MFO.ObjectId = Object_Bank.Id
                                  AND OS_Bank_MFO.DescId = zc_ObjectString_Bank_MFO()
            LEFT JOIN ObjectString AS OS_Bank_SWIFT
                                   ON OS_Bank_SWIFT.ObjectId = Object_Bank.Id
                                  AND OS_Bank_SWIFT.DescId = zc_ObjectString_Bank_SWIFT()
            LEFT JOIN ObjectString AS OS_Bank_IBAN
                                   ON OS_Bank_IBAN.ObjectId = Object_Bank.Id
                                  AND OS_Bank_IBAN.DescId = zc_ObjectString_Bank_IBAN()

            LEFT JOIN ObjectLink AS ObjectLink_Bank_Juridical
                                 ON ObjectLink_Bank_Juridical.ObjectId = Object_Bank.Id
                                AND ObjectLink_Bank_Juridical.DescId = zc_ObjectLink_Bank_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Bank_Juridical.ChildObjectId

      WHERE Object_Bank.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
09.05.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Bank(1,'2')
