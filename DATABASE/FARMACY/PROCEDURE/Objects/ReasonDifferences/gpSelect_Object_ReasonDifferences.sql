-- Function: gpSelect_Object_ReasonDifferences()

DROP FUNCTION IF EXISTS gpSelect_Object_ReasonDifferences(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReasonDifferences(
    IN inShowDel     Boolean   ,    -- ���������� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isDeficit Boolean, isSubstandard Boolean, isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReasonDifferences());

    RETURN QUERY 
        SELECT 
            Object_ReasonDifferences.Id
          , Object_ReasonDifferences.ObjectCode::Integer       AS Code
          , Object_ReasonDifferences.ValueData                 AS Name
          , COALESCE (PriceSite_Deficit.ValueData, FALSE)      AS isDeficit
          , COALESCE (PriceSite_Substandard.ValueData, FALSE)  AS isSubstandard
          , Object_ReasonDifferences.IsErased                  AS isErased
        FROM 
            Object AS Object_ReasonDifferences

            LEFT JOIN ObjectBoolean AS PriceSite_Deficit
                                    ON PriceSite_Deficit.ObjectId = Object_ReasonDifferences.Id
                                   AND PriceSite_Deficit.DescId = zc_ObjectBoolean_ReasonDifferences_Deficit()
                                   
            LEFT JOIN ObjectBoolean AS PriceSite_Substandard
                                    ON PriceSite_Substandard.ObjectId = Object_ReasonDifferences.Id
                                   AND PriceSite_Substandard.DescId = zc_ObjectBoolean_ReasonDifferences_Substandard()

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
-- SELECT * FROM gpSelect_Object_ReasonDifferences (False, '3')