-- Function: gpSelect_Object_RetailForRepriceChange()

DROP FUNCTION IF EXISTS gpSelect_Object_RetailForRepriceChange (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RetailForRepriceChange(
    IN inJuridicalId      Integer,       -- ���� ��.����
    IN inProvinceCityId   Integer,       -- �����
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, UnitName TVarChar)
AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY 
         SELECT 
               Object_Retail.Id         AS Id
             , Object_Retail.ValueData  AS Name
         FROM Object AS Object_Retail
         WHERE Object_Retail.DescId   = zc_Object_Retail()
           AND Object_Retail.isErased = FALSE
         ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.08.18         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_RetailForRepriceChange (0, 0, zfCalc_UserAdmin())
