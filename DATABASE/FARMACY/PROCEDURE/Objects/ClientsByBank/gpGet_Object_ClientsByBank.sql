-- Function: gpGet_Object_ClientsByBank (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ClientsByBank (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ClientsByBank(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , OKPO TVarChar
             , INN TVarChar
             , Phone TVarChar
             , ContactPerson TVarChar
             , RegAddress TVarChar
             , SendingAddress TVarChar
             , Accounting TVarChar
             , PhoneAccountancy TVarChar
             , Comment TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ClientsByBank());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_ClientsByBank.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS OKPO
           , CAST ('' as TVarChar)  AS INN
           , CAST ('' as TVarChar)  AS Phone
           , CAST ('' as TVarChar)  AS ContactPerson
           , CAST ('' as TVarChar)  AS RegAddress
           , CAST ('' as TVarChar)  AS SendingAddress
           , CAST ('' as TVarChar)  AS Accounting
           , CAST ('' as TVarChar)  AS PhoneAccountancy
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_ClientsByBank
       WHERE Object_ClientsByBank.DescId = zc_Object_ClientsByBank();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ClientsByBank.Id                    AS Id
           , Object_ClientsByBank.ObjectCode            AS Code
           , Object_ClientsByBank.ValueData             AS Name
           
           , ObjectString_OKPO.ValueData                AS OKPO
           , ObjectString_INN.ValueData                 AS INN
           , ObjectString_Phone.ValueData               AS Phone
           , ObjectString_ContactPerson.ValueData       AS ContactPerson
           , ObjectString_RegAddress.ValueData          AS RegAddress
           , ObjectString_SendingAddress.ValueData      AS SendingAddress
           , ObjectString_Accounting.ValueData          AS Accounting
           , ObjectString_PhoneAccountancy.ValueData    AS PhoneAccountancy
           , ObjectString_Comment.ValueData             AS Comment

           , Object_ClientsByBank.isErased AS isErased
           
       FROM Object AS Object_ClientsByBank
       
            LEFT JOIN ObjectString AS ObjectString_OKPO
                                   ON ObjectString_OKPO.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_OKPO.DescId = zc_ObjectString_ClientsByBank_OKPO()

            LEFT JOIN ObjectString AS ObjectString_INN
                                   ON ObjectString_INN.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_INN.DescId = zc_ObjectString_ClientsByBank_INN()

            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_Phone.DescId = zc_ObjectString_ClientsByBank_Phone()

            LEFT JOIN ObjectString AS ObjectString_ContactPerson
                                   ON ObjectString_ContactPerson.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_ContactPerson.DescId = zc_ObjectString_ClientsByBank_ContactPerson()

            LEFT JOIN ObjectString AS ObjectString_RegAddress
                                   ON ObjectString_RegAddress.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_RegAddress.DescId = zc_ObjectString_ClientsByBank_RegAddress()

            LEFT JOIN ObjectString AS ObjectString_SendingAddress
                                   ON ObjectString_SendingAddress.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_SendingAddress.DescId = zc_ObjectString_ClientsByBank_SendingAddress()

            LEFT JOIN ObjectString AS ObjectString_Accounting
                                   ON ObjectString_Accounting.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_Accounting.DescId = zc_ObjectString_ClientsByBank_Accounting()

            LEFT JOIN ObjectString AS ObjectString_PhoneAccountancy
                                   ON ObjectString_PhoneAccountancy.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_PhoneAccountancy.DescId = zc_ObjectString_ClientsByBank_PhoneAccountancy()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_ClientsByBank.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_ClientsByBank_Comment()

       WHERE Object_ClientsByBank.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_ClientsByBank (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
               Шаблий О.В.
 28.09.18         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_ClientsByBank (0, inSession := '5')
