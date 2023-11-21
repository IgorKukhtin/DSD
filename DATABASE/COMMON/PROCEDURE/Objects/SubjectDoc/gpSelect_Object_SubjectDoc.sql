-- Function: gpSelect_Object_SubjectDoc()

DROP FUNCTION IF EXISTS gpSelect_Object_SubjectDoc(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SubjectDoc(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Short TVarChar
             , ReasonId Integer, ReasonName TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SubjectDoc()());

   RETURN QUERY 
   SELECT 
          Object_SubjectDoc.Id         AS Id 
        , Object_SubjectDoc.ObjectCode AS Code
        , Object_SubjectDoc.ValueData  AS Name
        , ObjectString_Short.ValueData ::TVarChar AS Short
        , Object_Reason.Id             AS ReasonId
        , Object_Reason.ValueData      AS ReasonName
        , Object_SubjectDoc.isErased   AS isErased
   FROM Object AS Object_SubjectDoc
        LEFT JOIN ObjectString AS ObjectString_Short
                               ON ObjectString_Short.ObjectId = Object_SubjectDoc.Id 
                              AND ObjectString_Short.DescId = zc_ObjectString_SubjectDoc_Short() 

        LEFT JOIN ObjectLink AS ObjectLink_Reason
                             ON ObjectLink_Reason.ObjectId = Object_SubjectDoc.Id 
                            AND ObjectLink_Reason.DescId = zc_ObjectLink_SubjectDoc_Reason()
        LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = ObjectLink_Reason.ChildObjectId
   WHERE Object_SubjectDoc.DescId = zc_Object_SubjectDoc();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.11.23         *
 06.02.20         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_SubjectDoc('2')