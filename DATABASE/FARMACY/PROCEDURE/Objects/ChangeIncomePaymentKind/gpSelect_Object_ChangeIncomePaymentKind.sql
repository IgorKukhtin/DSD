-- Function: gpSelect_Object_ChangeIncomePaymentKind (TVarChar)
DROP FUNCTION IF EXISTS gpSelect_Object_ChangeIncomePaymentKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ChangeIncomePaymentKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_NDSKind());

   RETURN QUERY 
   SELECT
        Object_ChangeIncomePaymentKind.Id           AS Id 
      , Object_ChangeIncomePaymentKind.ObjectCode   AS Code
      , Object_ChangeIncomePaymentKind.ValueData    AS Name
      , Object_ChangeIncomePaymentKind.isErased     AS isErased
      
   FROM OBJECT AS Object_ChangeIncomePaymentKind
   WHERE Object_ChangeIncomePaymentKind.DescId = zc_Object_ChangeIncomePaymentKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ChangeIncomePaymentKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 10.12.15                                                          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ChangeIncomePaymentKind('2')



