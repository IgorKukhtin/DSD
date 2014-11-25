-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportOption (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportOption(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (SortField integer, FieldType TVarChar, Caption TVarChar, FieldName TVarChar,  DisplayFormat TVarChar
             , TableName TVarChar, TableSyn TVarChar, ConnectFieldName TVarChar
             , VisibleFieldName TVarChar, ShowDateType TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- ���������
     RETURN QUERY 
     SELECT * FROM 
     (
         SELECT 1, 'data'::TVarChar, '����� ����������'::TVarChar, 'sale_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 2, 'data'::TVarChar, '��� ����������'::TVarChar, 'Sale_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 3, 'data'::TVarChar, '����� ����������'::TVarChar, 'Sale_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 4, 'data'::TVarChar, '����� ��������'::TVarChar, 'Return_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 5, 'data'::TVarChar, '��� ��������'::TVarChar, 'Return_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 6, 'data'::TVarChar, '����� ��������'::TVarChar, 'Return_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 7, 'dimension'::TVarChar, '��. ����'::TVarChar, 'JuridicalName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectJuridical'::TVarChar, 'JuridicalId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 8, 'dimension'::TVarChar, '������'::TVarChar, 'AreaName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectArea'::TVarChar, 'AreaId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 9, 'dimension'::TVarChar, '������� �������� �����'::TVarChar, 'PartnerTagName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartnerTag'::TVarChar, 'PartnerTagId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 10, 'dimension'::TVarChar, '�������'::TVarChar, 'RegionName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectRegion'::TVarChar, 'RegionId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 11, 'dimension'::TVarChar, '�����'::TVarChar, 'ProvinceName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectProvince'::TVarChar, 'ProvinceId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 12, 'dimension'::TVarChar, '��� ����������� ������'::TVarChar, 'CityKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectCityKind'::TVarChar, 'CityKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 13, 'dimension'::TVarChar, '���������� �����'::TVarChar, 'CityName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectCity'::TVarChar, 'CityId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 14, 'dimension'::TVarChar, '����� ������'::TVarChar, 'ProvinceCityName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectProvinceCity'::TVarChar, 'ProvinceCityId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 15, 'dimension'::TVarChar, '��� �����'::TVarChar, 'StreetKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectStreetKind'::TVarChar, 'StreetKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 16, 'dimension'::TVarChar, '�����'::TVarChar, 'StreetName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectStreet'::TVarChar, 'StreetId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 17, 'dimension'::TVarChar, '�������'::TVarChar, 'PartnerName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartner'::TVarChar, 'PartnerId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 18, 'dimension'::TVarChar, '�������'::TVarChar, 'ContractName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectContract'::TVarChar, 'ContractId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 19, 'dimension'::TVarChar, '������'::TVarChar, 'InfoMoneyName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectInfoMoney'::TVarChar, 'InfoMoneyId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 20, 'dimension'::TVarChar, '������'::TVarChar, 'BranchName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectBranch'::TVarChar, 'BranchId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 21, 'dimension'::TVarChar, '�����'::TVarChar, 'GoodsName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoods'::TVarChar, 'GoodsId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 22, 'dimension'::TVarChar, '��� ������'::TVarChar, 'GoodsKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsKind'::TVarChar, 'GoodsKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
     
     )
                 AS SetupData ORDER BY 1;

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