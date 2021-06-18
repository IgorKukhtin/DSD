-- Function: gpSelect_Object_Reason()

DROP FUNCTION IF EXISTS gpSelect_Object_Reason (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Reason(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ReturnKindId Integer, ReturnKindName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Reason());

   RETURN QUERY 
   SELECT 
         Object_Reason.Id         AS Id 
       , Object_Reason.ObjectCode AS Code
       , Object_Reason.ValueData  AS NAME
       
       , Object_ReturnKind.Id           AS ReturnKindId
       , Object_ReturnKind.ValueData    AS ReturnKindName 
       
       , Object_Reason.isErased   AS isErased
       
   FROM Object AS Object_Reason
          LEFT JOIN ObjectLink AS ObjectLink_ReturnKind
                               ON ObjectLink_ReturnKind.ObjectId = Object_Reason.Id 
                              AND ObjectLink_ReturnKind.DescId = zc_ObjectLink_Reason_ReturnKind()
          LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = ObjectLink_ReturnKind.ChildObjectId  
   WHERE Object_Reason.DescId = zc_Object_Reason();
  
END;
$BODY$
LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.06.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Reason('2')