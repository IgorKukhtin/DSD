-- Function: gpGet_Object_Currency()

DROP FUNCTION IF EXISTS gpGet_Object_Currency (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Currency(
    IN inId          Integer,       -- ������ 
    IN inSession     TVarChar       -- ������ ������������ 
    )
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, InternalName TVarChar) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST (0 as Integer)    AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST ('' as TVarChar)  AS InternalName;
   ELSE
       RETURN QUERY 
       SELECT 
            Object_Currency_View.Id
          , Object_Currency_View.Code
          , Object_Currency_View.Name
          , Object_Currency_View.isErased
          , Object_Currency_View.InternalName
       FROM Object_Currency_View
      WHERE Object_Currency_View.Id = inId;
   END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Currency (integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        *Cyr1251
 05.12.13                         *
 11.06.13          *
 03.06.13          
*/

-- ����
-- SELECT * FROM gpGet_Object_Currency(2,'2')