-- Function: gpSelect_Object_GoodsByGoodsKind1CLink (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportOption (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportOption(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (SortField integer, FieldType TVarChar, Caption TVarChar, FieldName TVarChar,  DisplayFormat TVarChar
             , TableName TVarChar, TableSyn TVarChar, ConnectFieldName TVarChar
             , VisibleFieldName TVarChar, SummaryType TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsByGoodsKind1CLink());
   
     -- ���������
     RETURN QUERY 
     SELECT * FROM 
     (
         SELECT 101, 'data'::TVarChar, '���.��� �������' :: TVarChar, 'Sale_AmountPartner_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   -- UNION SELECT 102, 'data'::TVarChar, '���.��. �������' :: TVarChar, 'Sale_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
   --              ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 103, 'data'::TVarChar, '����� �������' :: TVarChar, 'Sale_Summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 104, 'data'::TVarChar, '�\� �������' :: TVarChar, 'Sale_SummCost'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 105, 'data'::TVarChar, '������ �� ���.���.' :: TVarChar, 'Sale_Summ_10200'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 106, 'data'::TVarChar, '������ �����' :: TVarChar, 'Sale_Summ_10250'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 106, 'data'::TVarChar, '������ ���.' :: TVarChar, 'Sale_Summ_10300'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 111, 'data'::TVarChar, '���.��� �������' :: TVarChar, 'Return_AmountPartner_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   -- UNION SELECT 112, 'data'::TVarChar, '���.��. �������' :: TVarChar, 'Return_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
   --               ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 113, 'data'::TVarChar, '����� �������'::TVarChar, 'Return_Summ' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 114, 'data'::TVarChar, '�\� �������'::TVarChar, 'Return_SummCost' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 121, 'data'::TVarChar, '���.��� �������-�������' :: TVarChar, 'SaleReturn_Amount_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   -- UNION SELECT 122, 'data'::TVarChar, '���.��. �������-�������' :: TVarChar, 'SaleReturn_Amount_Sh'::TVarChar, ',0.###'::TVarChar, 
   --               ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 123, 'data'::TVarChar, '����� �������-�������' :: TVarChar, 'SaleReturn_summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 124, 'data'::TVarChar, '�\� �������-�������' :: TVarChar, 'SaleReturn_SummCost'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 131, 'data'::TVarChar, '����� ������' :: TVarChar, 'SaleReturn_Summ_10300'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 132, 'data'::TVarChar, '����� ������ (�� ����)' :: TVarChar, 'Sale_SummCost_10500'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 133, 'data'::TVarChar, '����� ����� (������)' :: TVarChar, 'BonusBasis'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 134, 'data'::TVarChar, '����� ����� (������)' :: TVarChar, 'Bonus'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   -- UNION SELECT 132, 'data'::TVarChar, '����� �������-�����' :: TVarChar, 'SaleBonus'::TVarChar, ',0.00'::TVarChar, 
   --               ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 141, 'data'::TVarChar, '������� �������' :: TVarChar, 'Sale_Profit'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 142, 'data'::TVarChar, '������� �������-�����' :: TVarChar, 'SaleBonus_Profit'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 143, 'data'::TVarChar, '������� �������-�������' :: TVarChar, 'SaleReturn_Profit'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 144, 'data'::TVarChar, '������� �������-�������-�����' :: TVarChar, 'SaleReturnBonus_Profit'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 151, 'data'::TVarChar, '% ����. �������' :: TVarChar, 'Sale_Percent'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                'Sale_SummCost,Sale_Profit'::TVarChar,
                'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(Sale_Profit) / SUM(Sale_SummCost) * 100 END'::TVarChar,
                'stPercent'::TVarChar
   UNION SELECT 152, 'data'::TVarChar, '% ����. �������-�����'::TVarChar, 'SaleBonus_Percent'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                 'Sale_SummCost,SaleBonus_Profit'::TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleBonus_Profit) / SUM(Sale_SummCost) * 100 END'::TVarChar,
                 'stPercent'::TVarChar
   UNION SELECT 153, 'data'::TVarChar, '% ����. �������-�������' :: TVarChar, 'SaleReturn_Percent'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                 'Sale_SummCost,SaleReturn_Profit'::TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleReturn_Profit) / SUM(Sale_SummCost) * 100 END'::TVarChar,
                 'stPercent'::TVarChar
   UNION SELECT 154, 'data'::TVarChar, '% ����. �������-�������-�����'::TVarChar, 'SaleReturnBonus_Percent'::TVarChar, ',0.0'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                 'Sale_SummCost,SaleReturnBonus_Profit'::TVarChar,
                 'CASE WHEN SUM(Sale_SummCost) = 0 THEN 0 ELSE SUM(SaleReturnBonus_Profit) / SUM(Sale_SummCost) * 100 END'::TVarChar,
                 'stPercent'::TVarChar

   UNION SELECT 161, 'data'::TVarChar, '���� ���.���'::TVarChar, 'Plan_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 162, 'data'::TVarChar, '���� �����'::TVarChar, 'Plan_Summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 163, 'data'::TVarChar, '% ���������� ���� ���.���'::TVarChar, 'Plan_Percent'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,
                 'Plan_Weight,Sale_AmountPartner_Weight'::TVarChar,
                 'CASE WHEN SUM(Plan_Weight) = 0 THEN 0 ELSE SUM(Sale_AmountPartner_Weight) / SUM(Plan_Weight) * 100 - 100 END'::TVarChar,
                 'stPercent'::TVarChar

   UNION SELECT 161, 'data'::TVarChar, '����� ��'::TVarChar, 'Actions_Weight'::TVarChar, ',0.###'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 162, 'data'::TVarChar, '����� �/�'::TVarChar, 'Actions_SummCost'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 162, 'data'::TVarChar, '����� �����'::TVarChar, 'Actions_Summ'::TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 171, 'data'::TVarChar, '������ �����'::TVarChar, 'Money_Summ' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 172, 'data'::TVarChar, '��-����� �����'::TVarChar, 'SendDebt_Summ' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar
   UNION SELECT 173, 'data'::TVarChar, '������ � ��-�����'::TVarChar, 'Money_SendDebt_Summ' :: TVarChar, ',0.00'::TVarChar, 
                 ''::TVarChar, ''::TVarChar,''::TVarChar,''::TVarChar,''::TVarChar

   UNION SELECT 11, 'dimension'::TVarChar, '����� ������'::TVarChar, 'PaidKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPaidKind'::TVarChar, 'PaidKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 12, 'dimension'::TVarChar, '������'::TVarChar, 'BranchName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectBranch'::TVarChar, 'BranchId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 13, 'dimension'::TVarChar, '������'::TVarChar, 'AreaName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectArea'::TVarChar, 'AreaId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 14, 'dimension'::TVarChar, '�������� ����'::TVarChar, 'RetailName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectRetail'::TVarChar, 'RetailId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 15, 'dimension'::TVarChar, '����������� ����'::TVarChar, 'JuridicalName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectJuridical'::TVarChar, 'JuridicalId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 16, 'dimension'::TVarChar, '����������'::TVarChar, 'PartnerName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartner'::TVarChar, 'PartnerId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 17, 'dimension'::TVarChar, '������� �������� �����'::TVarChar, 'PartnerTagName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPartnerTag'::TVarChar, 'PartnerTagId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 18, 'dimension'::TVarChar, '������ ������� ��������'::TVarChar, 'ContractTagGroupName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectContractTagGroup'::TVarChar, 'ContractTagGroupId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 19, 'dimension'::TVarChar, '������� ��������'::TVarChar, 'ContractTagName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectContractTag'::TVarChar, 'ContractTagId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 20, 'dimension'::TVarChar, '�� ������'::TVarChar, 'InfoMoneyName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectInfoMoney'::TVarChar, 'InfoMoneyId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar

   UNION SELECT 31, 'dimension'::TVarChar, '��� (�����������)'::TVarChar, 'PersonalName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPersonal'::TVarChar, 'PersonalId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 32, 'dimension'::TVarChar, '��� (��)'::TVarChar, 'PersonalTradeName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectPersonalTrade'::TVarChar, 'PersonalTradeId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 33, 'dimension'::TVarChar, '������ (�����������)'::TVarChar, 'BranchPersonalName'::TVarChar, ''::TVarChar,
                 'Object'::TVarChar, 'ObjectBranchPersonal'::TVarChar, 'BranchId_Personal'::TVarChar, 'ValueData'::TVarChar,''::TVarChar

   /*UNION SELECT 40, 'dimension'::TVarChar, '�����'::TVarChar, 'Address'::TVarChar, ''::TVarChar, 
                 ''::TVarChar, ''::TVarChar,'Address'::TVarChar,''::TVarChar,''::TVarChar*/

   UNION SELECT 41, 'dimension'::TVarChar, '�������'::TVarChar, 'RegionName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectRegion'::TVarChar, 'RegionId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 42, 'dimension'::TVarChar, '�����'::TVarChar, 'ProvinceName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectProvince'::TVarChar, 'ProvinceId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 43, 'dimension'::TVarChar, '��� �.�.'::TVarChar, 'CityKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectCityKind'::TVarChar, 'CityKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 44, 'dimension'::TVarChar, '���������� �����'::TVarChar, 'CityName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectCity'::TVarChar, 'CityId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 45, 'dimension'::TVarChar, '����������'::TVarChar, 'ProvinceCityName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectProvinceCity'::TVarChar, 'ProvinceCityId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 46, 'dimension'::TVarChar, '��� ��.'::TVarChar, 'StreetKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectStreetKind'::TVarChar, 'StreetKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 47, 'dimension'::TVarChar, '�����'::TVarChar, 'StreetName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectStreet'::TVarChar, 'StreetId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar

   UNION SELECT 50, 'dimension'::TVarChar, '������' :: TVarChar, 'BusinessName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectBusiness' :: TVarChar, 'BusinessId' :: TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 50, 'dimension'::TVarChar, '���������������� ��������' :: TVarChar, 'GoodsPlatformName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsPlatform'::TVarChar, 'GoodsPlatformId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 51, 'dimension'::TVarChar, '�������� �����' :: TVarChar, 'TradeMarkName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectTradeMark'::TVarChar, 'TradeMarkId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 52, 'dimension'::TVarChar, '������ ���������' :: TVarChar, 'GoodsGroupAnalystName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsGroupAnalyst'::TVarChar, 'GoodsGroupAnalystId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 53, 'dimension'::TVarChar, '������� ������' :: TVarChar, 'GoodsTagName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsTag'::TVarChar, 'GoodsTagId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 54, 'dimension'::TVarChar, '�����'::TVarChar, 'GoodsName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoods'::TVarChar, 'GoodsId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 55, 'dimension'::TVarChar, '��� ������'::TVarChar, 'GoodsKindName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectGoodsKind'::TVarChar, 'GoodsKindId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
   UNION SELECT 56, 'dimension'::TVarChar, '��. ���.' :: TVarChar, 'MeasureName'::TVarChar, ''::TVarChar, 
                 'Object'::TVarChar, 'ObjectMeasure'::TVarChar, 'MeasureId'::TVarChar, 'ValueData'::TVarChar,''::TVarChar
     )
                 AS SetupData ORDER BY 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_OlapSoldReportOption (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.01.15                                        * all
 21.11.14                        * 
*/

-- ����
-- SELECT * FROM gpGet_OlapSoldReportOption (zfCalc_UserAdmin())
