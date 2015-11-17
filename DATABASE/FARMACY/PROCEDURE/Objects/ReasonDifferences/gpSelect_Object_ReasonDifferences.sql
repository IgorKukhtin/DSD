-- Function: gpSelect_Object_ReasonDifferences()

DROP FUNCTION IF EXISTS gpSelect_Object_ReasonDifferences(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReasonDifferences(
    IN inShowDel     Boolean   ,    -- ���������� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReasonDifferences());

    RETURN QUERY 
        SELECT 
            Object_ReasonDifferences.Id
          , Object_ReasonDifferences.ObjectCode::Integer AS Code
          , Object_ReasonDifferences.ValueData           AS Name
          , Object_ReasonDifferences.IsErased            AS isErased
        FROM 
            Object AS Object_ReasonDifferences
        WHERE 
            Object_ReasonDifferences.DescId = zc_Object_ReasonDifferences()
            AND
            (
                Object_ReasonDifferences.isErased = FALSE
                OR
                inShowDel = TRUE
            );
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReasonDifferences(Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 17.11.15                                                         *
 
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReasonDifferences ('3')