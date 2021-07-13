-- Function: gpSelect_Object_MobilePack()

DROP FUNCTION IF EXISTS gpSelect_Object_MobilePack (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MobilePack(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MobilePack());

   RETURN QUERY 
   SELECT 
         Object_MobilePack.Id         AS Id 
       , Object_MobilePack.ObjectCode AS Code
       , Object_MobilePack.ValueData  AS NAME
       , ObjectString_Comment.ValueData AS Comment
       , Object_MobilePack.isErased   AS isErased
       
   FROM Object AS Object_MobilePack
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_MobilePack.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_MobilePack_Comment()
   WHERE Object_MobilePack.DescId = zc_Object_MobilePack()
 UNION 
   SELECT 0
        , 0 
        , '�������' ::TVarChar
        , '' ::TVarChar
        , FALSE
   ;
  
END;
$BODY$
LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.07.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_MobilePack('2')