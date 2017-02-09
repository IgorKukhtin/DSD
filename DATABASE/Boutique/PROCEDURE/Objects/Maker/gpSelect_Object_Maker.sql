-- Function: gpSelect_Object_Maker()

DROP FUNCTION IF EXISTS gpSelect_Object_Maker(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Maker(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , CountryId Integer, CountryCode Integer, CountryName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Maker());

     RETURN QUERY  
       SELECT 
             Object_Maker.Id          AS Id
           , Object_Maker.ObjectCode  AS Code
           , Object_Maker.ValueData   AS Name
           
           , Object_Country.Id          AS CountryId
           , Object_Country.ObjectCode  AS CountryCode
           , Object_Country.ValueData   AS CountryName
          
           , Object_Maker.isErased AS isErased
           
       FROM Object AS Object_Maker
   
           LEFT JOIN ObjectLink AS ObjectLink_Maker_Country ON ObjectLink_Maker_Country.ObjectId = Object_Maker.Id 
                                                           AND ObjectLink_Maker_Country.DescId = zc_ObjectLink_Maker_Country()
           LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Maker_Country.ChildObjectId              

     WHERE Object_Maker.DescId = zc_Object_Maker();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Maker(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Maker('2')