-- Function: gpGet_Object_Area()

DROP FUNCTION IF EXISTS gpGet_Object_Area(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Area(
    IN inId          Integer,       -- ���� ������� <�������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , TelegramId TVarChar, TelegramBotToken TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Area()) AS Code
           , CAST ('' AS TVarChar)  AS Name 
           , CAST ('' AS TVarChar)  AS TelegramId
           , CAST ('' AS TVarChar)  AS TelegramBotToken
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , ObjectString_TelegramId.ValueData       ::TVarChar AS TelegramId
           , ObjectString_TelegramBotToken.ValueData ::TVarChar AS TelegramBotToken
           , Object.isErased   AS isErased
       FROM Object
            LEFT JOIN ObjectString AS ObjectString_TelegramId
                                   ON ObjectString_TelegramId.ObjectId = Object.Id
                                  AND ObjectString_TelegramId.DescId = zc_ObjectString_Area_TelegramId()
            LEFT JOIN ObjectString AS ObjectString_TelegramBotToken
                                   ON ObjectString_TelegramBotToken.ObjectId = Object.Id
                                  AND ObjectString_TelegramBotToken.DescId = zc_ObjectString_Area_TelegramBotToken()
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Area(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.11.13         *

*/

-- ����
-- SELECT * FROM gpGet_Object_Area (0, '2')