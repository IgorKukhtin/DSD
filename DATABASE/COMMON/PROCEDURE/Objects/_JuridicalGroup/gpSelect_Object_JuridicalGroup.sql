-- Function: gpSelect_Object_JuridicalGroup()

-- DROP FUNCTION gpSelect_Object_JuridicalGroup();

CREATE OR REPLACE FUNCTION gpSelect_Object_JuridicalGroup(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalGroup());

     RETURN QUERY 
     SELECT 
         Object.Id         AS Id 
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , Object.isErased   AS isErased
       , ObjectLink.ChildObjectId AS ParentId
     FROM Object
LEFT JOIN ObjectLink 
       ON ObjectLink.ObjectId = Object.Id
      AND ObjectLink.DescId = zc_ObjectLink_JuridicalGroup_Parent()
    WHERE Object.DescId = zc_Object_JuridicalGroup();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.12.13                                        *Cyr1251
 13.06.13          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_JuridicalGroup('2')