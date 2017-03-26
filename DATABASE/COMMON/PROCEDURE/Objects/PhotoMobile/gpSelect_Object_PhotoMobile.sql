-- Function: gpSelect_Object_PhotoMobile()

DROP FUNCTION IF EXISTS gpSelect_Object_PhotoMobile(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PhotoMobile(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PhotoData Tblob
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PhotoMobile()());

   RETURN QUERY 
   SELECT Object_PhotoMobile.Id         AS Id 
        , Object_PhotoMobile.ObjectCode AS Code
        , Object_PhotoMobile.ValueData  AS Name
        , ObjectBlob_Photo.ValueData    AS PhotoData
        , Object_PhotoMobile.isErased   AS isErased
   FROM Object AS Object_PhotoMobile
         LEFT JOIN ObjectBlob AS ObjectBlob_Photo
                              ON ObjectBlob_Photo.ObjectId = Object_PhotoMobile.Id
                             AND ObjectBlob_Photo.DescId = zc_ObjectBlob_PhotoMobile_Data()
   WHERE Object_PhotoMobile.DescId = zc_Object_PhotoMobile();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PhotoMobile(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.03.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PhotoMobile('2')