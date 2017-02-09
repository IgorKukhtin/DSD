-- Function: gpGet_Object_Maker()

DROP FUNCTION IF EXISTS gpGet_Object_Maker(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Maker(
    IN inId          Integer,       -- ���� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , CountryId Integer, CountryCode Integer, CountryName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Maker());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_Maker.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)   AS CountryId
           , CAST (0 as Integer)   AS CountryCode
           , CAST ('' as TVarChar) AS CountryName

           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_Maker
       WHERE Object_Maker.DescId = zc_Object_Maker();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Maker.Id          AS Id
           , Object_Maker.ObjectCode  AS Code
           , Object_Maker.ValueData   AS Name
           
           , Object_Country.Id    AS CountryId
           , Object_Country.ObjectCode  AS CountryCode
           , Object_Country.ValueData   AS CountryName

           , Object_Maker.isErased AS isErased
           
       FROM Object AS Object_Maker
       
           LEFT JOIN ObjectLink AS ObjectLink_Maker_Country ON ObjectLink_Maker_Country.ObjectId = Object_Maker.Id 
                                                               AND ObjectLink_Maker_Country.DescId = zc_ObjectLink_Maker_Country()
           LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Maker_Country.ChildObjectId              

       WHERE Object_Maker.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Maker(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.14         *  

*/

-- ����
-- SELECT * FROM gpGet_Object_Maker (2, '')
