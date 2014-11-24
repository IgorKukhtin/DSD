-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportOption (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportOption(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (FieldType TVarChar, Caption TVarChar, FieldName TVarChar,  DisplayFormat TVarChar
             , TableName TVarChar, TableSyn TVarChar, ConnectFieldName TVarChar
             , VisibleFieldName TVarChar, ShowDateType TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- ���������
     RETURN QUERY 
         SELECT 'data'::TVarChar, '����� ����������'::TVarChar, 'sale_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 'data'::TVarChar, '��� ����������'::TVarChar, 'Sale_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 'data'::TVarChar, '����� ����������'::TVarChar, 'Sale_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 'data'::TVarChar, '����� ��������'::TVarChar, 'Return_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 'data'::TVarChar, '��� ��������'::TVarChar, 'Return_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 'data'::TVarChar, '����� ��������'::TVarChar, 'Return_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 'dimension'::TVarChar, '��. ����'::TVarChar, 'JuridicalName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectJuridical'::TVarChar, 'JuridicalId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 'dimension'::TVarChar, '�������'::TVarChar, 'PartnerName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartner'::TVarChar, 'PartnerId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 'dimension'::TVarChar, '�������'::TVarChar, 'ContractName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectContract'::TVarChar, 'ContractId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 'dimension'::TVarChar, '������'::TVarChar, 'InfoMoneyName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectInfoMoney'::TVarChar, 'InfoMoneyId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 'dimension'::TVarChar, '������'::TVarChar, 'BranchName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectBranch'::TVarChar, 'BranchId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 'dimension'::TVarChar, '�����'::TVarChar, 'GoodsName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoods'::TVarChar, 'GoodsId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 'dimension'::TVarChar, '��� ������'::TVarChar, 'GoodsKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsKind'::TVarChar, 'GoodsKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OlapSoldReportOption (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.11.14                        * 
*/

-- ����
-- SELECT * FROM gpGet_OlapSoldReportOption (zfCalc_UserAdmin()) 