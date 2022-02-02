-- Function: gpGet_Object_ConditionsKeep (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ConditionsKeep (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ConditionsKeep(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isColdSUN boolean
             , isErased Boolean
             , RelatedProductId Integer, RelatedProductName TVarChar) AS
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
           , CAST (False AS Boolean) AS isColdSUN
           , CAST (False AS Boolean) AS isErased
           , CAST (0 as Integer)    AS RelatedProductId
           , CAST ('' as TVarChar)  AS RelatedProductName;
   ELSE
       RETURN QUERY 
       SELECT Object_ConditionsKeep.Id          AS Id
            , Object_ConditionsKeep.ObjectCode  AS Code
            , Object_ConditionsKeep.ValueData   AS Name
            , COALESCE (ObjectBoolean_ColdSUN.ValueData, FALSE) AS isColdSUN
            , Object_ConditionsKeep.isErased    AS isErased
            , ObjectFloat_RelatedProduct.ValueData::Integer  AS RelatedProductId
            , MS_RelatedProduct_Comment.ValueData            AS RelatedProductName 
       FROM Object AS Object_ConditionsKeep
       
            LEFT JOIN ObjectFloat AS ObjectFloat_RelatedProduct
                                  ON ObjectFloat_RelatedProduct.ObjectId = Object_ConditionsKeep.Id
                                 AND ObjectFloat_RelatedProduct.DescId = zc_ObjectFloat_ConditionsKeep_RelatedProduct()
            LEFT JOIN MovementString AS MS_RelatedProduct_Comment
                                     ON MS_RelatedProduct_Comment.MovementId = ObjectFloat_RelatedProduct.ValueData
                                    AND MS_RelatedProduct_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_ColdSUN
                                    ON ObjectBoolean_ColdSUN.ObjectId = Object_ConditionsKeep.Id
                                   AND ObjectBoolean_ColdSUN.DescId = zc_ObjectBoolean_ConditionsKeep_ColdSUN()

       WHERE Object_ConditionsKeep.Id = inId;
   END IF;
   
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 14.10.18                                                      *
 07.01.17         * 
*/

-- ����
-- SELECT * FROM gpGet_Object_ConditionsKeep(0,'2')