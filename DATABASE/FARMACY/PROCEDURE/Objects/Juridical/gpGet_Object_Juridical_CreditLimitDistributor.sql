-- Function: gpGet_Object_Juridical_CreditLimitDistributor()

DROP FUNCTION IF EXISTS gpGet_Object_Juridical_CreditLimitDistributor(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Juridical_CreditLimitDistributor(
    IN inId          Integer,       -- ������������� 
    IN inSession     TVarChar       -- ������ ������������ 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               CreditLimit TFloat,
               isErased boolean) AS
$BODY$
BEGIN 

  -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Juridical());
   IF COALESCE (inId, 0) = 0
   THEN
      RAISE EXCEPTION '������. �� ������� ��.����';
   ELSE
       RETURN QUERY 
       SELECT 
              Object_Juridical.Id                 AS Id
            , Object_Juridical.ObjectCode         AS Code
            , Object_Juridical.ValueData          AS Name

            , COALESCE(ObjectFloat_CreditLimit.ValueData, 0)::TFloat AS CreditLimit

            , Object_Juridical.isErased           AS isErased
                      
       FROM Object AS Object_Juridical

            LEFT JOIN ObjectFloat AS ObjectFloat_CreditLimit
                                  ON ObjectFloat_CreditLimit.ObjectId = Object_Juridical.Id
                                 AND ObjectFloat_CreditLimit.DescId = zc_ObjectFloat_Juridical_CreditLimit()

       WHERE Object_Juridical.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.04.19                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Juridical_CreditLimitDistributor(0, '3')
-- select * from gpGet_Object_Juridical_CreditLimitDistributor(inId := 59610 ,  inSession := '3');
