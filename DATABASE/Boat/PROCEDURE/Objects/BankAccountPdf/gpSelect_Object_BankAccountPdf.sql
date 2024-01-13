-- Function: gpSelect_Object_BankAccountPdf(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BankAccountPdf(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankAccountPdf(
    IN inMovmentItemId      Integer, 
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , FileName TVarChar) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MovmentItemCondition());

   RETURN QUERY 
     SELECT 
           Object_BankAccountPdf.Id        AS Id,
           Object_BankAccountPdf.ValueData AS FileName
     FROM Object AS Object_BankAccountPdf
          JOIN ObjectFloat AS ObjectFloat_BankAccountPdf_MovmentItemId
                           ON ObjectFloat_BankAccountPdf_MovmentItemId.ObjectId = Object_BankAccountPdf.Id
                          AND ObjectFloat_BankAccountPdf_MovmentItemId.DescId = zc_ObjectFloat_BankAccountPdf_MovmentItemId()
                          AND ObjectFloat_BankAccountPdf_MovmentItemId.ValueData = inMovmentItemId   
          LEFT JOIN ObjectLink AS ObjectLink_BankAccountPdf_PhotoTag
                               ON ObjectLink_BankAccountPdf_PhotoTag.ObjectId = Object_BankAccountPdf.Id
                              AND ObjectLink_BankAccountPdf_PhotoTag.DescId = zc_ObjectLink_BankAccountPdf_PhotoTag()
          LEFT JOIN Object AS Object_PhotoTag ON Object_PhotoTag.Id = ObjectLink_BankAccountPdf_PhotoTag.ObjectId
     WHERE Object_BankAccountPdf.DescId = zc_Object_BankAccountPdf(); 
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_BankAccountPdf (0,'2')