-- Function: gpGet_Object_SPKind_1303 (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_SPKind_1303 (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SPKind_1303(
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, 
               Name TVarChar
              )
AS
$BODY$
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_SPKind());

    RETURN QUERY 
       SELECT Object_SPKind.Id          AS Id
            , Object_SPKind.ValueData   AS Name
       FROM Object AS Object_SPKind
            LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                                  ON ObjectFloat_Tax.ObjectId = Object_SPKind.Id
                                 AND ObjectFloat_Tax.DescId   = zc_ObjectFloat_SPKind_Tax()
       WHERE Object_SPKind.DescId   = zc_Object_SPKind()
         AND Object_SPKind.isErased = FALSE
         AND Object_SPKind.Id = zc_Enum_SPKind_1303()
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.02.21                                                       *
*/

-- ����
-- 
SELECT * FROM gpGet_Object_SPKind_1303 ('3')
