-- Function: gpSelect_Object_Bank (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Bank (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Bank(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, MFO TVarChar, SWIFT TVarChar, IBAN TVarChar, JuridicalName TVarChar, isErased boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Bank());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Bank.Id                  AS Id
           , Object_Bank.ObjectCode          AS Code
           , Object_Bank.ValueData           AS Name
           , OS_Bank_MFO.ValueData           AS MFO
           , OS_Bank_SWIFT.ValueData         As SWIFT
           , OS_Bank_IBAN.ValueData          AS IBAN
           , Object_Juridical.ValueData      AS JuridicalName
           , Object_Bank.isErased            AS isErased           
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

     WHERE Object_Bank.DescId = zc_Object_Bank()
              AND (Object_Bank.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
09.05.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Bank (TRUE, zfCalc_UserAdmin())