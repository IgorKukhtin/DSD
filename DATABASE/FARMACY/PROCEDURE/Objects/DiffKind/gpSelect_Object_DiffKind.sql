-- Function: gpSelect_Object_DiffKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DiffKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiffKind(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isClose Boolean
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
     SELECT Object_DiffKind.Id                     AS Id
          , Object_DiffKind.ObjectCode             AS Code
          , Object_DiffKind.ValueData              AS Name
          , ObjectBoolean_DiffKind_Close.ValueData AS isClose
          , Object_DiffKind.isErased               AS isErased
     FROM Object AS Object_DiffKind
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                  ON ObjectBoolean_DiffKind_Close.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close()   
     WHERE Object_DiffKind.DescId = zc_Object_DiffKind();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.18         *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_DiffKind('2')