-- Function: gpSelect_Object_ConditionsKeep(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ConditionsKeep(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ConditionsKeep(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean
             , RelatedProductId Integer, RelatedProductName TVarChar) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ConditionsKeep());

   RETURN QUERY 
     SELECT Object_ConditionsKeep.Id                       AS Id
          , Object_ConditionsKeep.ObjectCode               AS Code
          , Object_ConditionsKeep.ValueData                AS Name
          , Object_ConditionsKeep.isErased                 AS isErased
          , ObjectFloat_RelatedProduct.ValueData::Integer  AS RelatedProductId
          , MS_RelatedProduct_Comment.ValueData            AS RelatedProductName 
     FROM Object AS Object_ConditionsKeep

        LEFT JOIN ObjectFloat AS ObjectFloat_RelatedProduct
                              ON ObjectFloat_RelatedProduct.ObjectId = Object_ConditionsKeep.Id
                             AND ObjectFloat_RelatedProduct.DescId = zc_ObjectFloat_ConditionsKeep_RelatedProduct()
        LEFT JOIN MovementString AS MS_RelatedProduct_Comment
                                 ON MS_RelatedProduct_Comment.MovementId = ObjectFloat_RelatedProduct.ValueData
                                AND MS_RelatedProduct_Comment.DescId = zc_MovementString_Comment()

     WHERE Object_ConditionsKeep.DescId = zc_Object_ConditionsKeep();
  
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
-- SELECT * FROM gpSelect_Object_ConditionsKeep('2')