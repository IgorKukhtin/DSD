-- Function: gpGet_Object_ConditionsKeep (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ConditionsKeep (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ConditionsKeep(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ConditionsKeep());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ConditionsKeep()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_ConditionsKeep.Id          AS Id
            , Object_ConditionsKeep.ObjectCode  AS Code
            , Object_ConditionsKeep.ValueData   AS Name
            , Object_ConditionsKeep.isErased    AS isErased
       FROM Object AS Object_ConditionsKeep
       WHERE Object_ConditionsKeep.Id = inId;
   END IF;
   
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.01.17         * 
*/

-- ����
-- SELECT * FROM gpGet_Object_ConditionsKeep(0,'2')