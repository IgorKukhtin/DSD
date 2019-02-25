-- Function: gpSelect_Object_JackdawsChecks(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_JackdawsChecks(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_JackdawsChecks(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
     SELECT Object_JackdawsChecks.Id                     AS Id
          , Object_JackdawsChecks.ObjectCode             AS Code
          , Object_JackdawsChecks.ValueData              AS Name
          , Object_JackdawsChecks.isErased               AS isErased
     FROM Object AS Object_JackdawsChecks
     WHERE Object_JackdawsChecks.DescId = zc_Object_JackdawsChecks();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.02.19                                                       * 

*/

-- ����
-- SELECT * FROM gpSelect_Object_JackdawsChecks('2')