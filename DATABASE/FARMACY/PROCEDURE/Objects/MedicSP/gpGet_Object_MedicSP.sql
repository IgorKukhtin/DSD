-- Function: gpGet_Object_MedicSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MedicSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MedicSP(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MedicSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MedicSP()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_MedicSP.Id          AS Id
            , Object_MedicSP.ObjectCode  AS Code
            , Object_MedicSP.ValueData   AS Name
            , Object_MedicSP.isErased    AS isErased
       FROM Object AS Object_MedicSP
       WHERE Object_MedicSP.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.02.17         *
*/

-- ����
-- SELECT * FROM gpGet_Object_MedicSP(0,'2')