-- Function: gpSelect_Object_Buyer()

DROP FUNCTION IF EXISTS gpSelect_Object_Buyer(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Buyer(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Phone TVarChar
             , Name TVarChar
             , DateBirth TVarChar, Sex TVarChar
             , Comment TVarChar 
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_Buyer.Id                        AS Id 
        , Object_Buyer.ObjectCode                AS Code
        , Object_Buyer.ValueData                 AS Phone
        , ObjectString_Buyer_Name.ValueData      AS Name
        , ObjectString_Buyer_DateBirth.ValueData AS DateBirth
        , ObjectString_Buyer_Sex.ValueData       AS Sex
        , ObjectString_Buyer_Comment.ValueData   AS Comment
        , Object_Buyer.isErased                  AS isErased
   FROM Object AS Object_Buyer
        LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                               ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()

        LEFT JOIN ObjectString AS ObjectString_Buyer_Comment
                               ON ObjectString_Buyer_Comment.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_Comment.DescId = zc_ObjectString_Buyer_Comment()

        LEFT JOIN ObjectString AS ObjectString_Buyer_DateBirth
                               ON ObjectString_Buyer_DateBirth.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_DateBirth.DescId = zc_ObjectString_Buyer_DateBirth()
        LEFT JOIN ObjectString AS ObjectString_Buyer_Sex
                               ON ObjectString_Buyer_Sex.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_Sex.DescId = zc_ObjectString_Buyer_Sex()
   WHERE Object_Buyer.DescId = zc_Object_Buyer();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Buyer(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Buyer('3')