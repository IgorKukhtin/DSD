-- View: Constant_ProfitLoss_Sale_ReturnIn_View

-- DROP VIEW IF EXISTS Constant_ProfitLoss_Sale_ReturnIn_View CASCADE;

CREATE OR REPLACE VIEW Constant_ProfitLoss_Sale_ReturnIn_View
AS
    -- ����� ����������: ��������� + ����
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10101() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10102() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL 
   -- ������� � �������� ������ (������ �� ������): ��������� + ����
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10200() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10201() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10200() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10202() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL 
   -- ������ ��������������: ��������� + ����
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10300() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10301() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10300() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10302() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost

  UNION ALL
   -- ����� ���������: ��������� + ����
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10700() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10701() AS ProfitLossId, FALSE AS isSale, FALSE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10700() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10702() AS ProfitLossId, FALSE AS isSale, FALSE AS isCost

  UNION ALL 
    -- ���������� ����� ���������: ���� + ����� + ������� + �������-���������
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70101() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70102() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70103() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70104() AS ProfitLossId, TRUE AS isSale, FALSE AS isCost
  UNION ALL
   -- �������� �� ����� ��������: ���� + �����
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70110() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70111() AS ProfitLossId, FALSE AS isSale, FALSE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70110() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70112() AS ProfitLossId, FALSE AS isSale, FALSE AS isCost

  UNION ALL 
   -- ������������� ����������: 104..��������� + ����
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10400() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10401() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10400() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10402() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost
  UNION ALL 
   -- ������������� ���������: 108..��������� + ����
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10800() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10801() AS ProfitLossId, FALSE AS isSale, TRUE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10800() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10802() AS ProfitLossId, FALSE AS isSale, TRUE AS isCost

  UNION ALL 
   -- ���������� ����� ���������: ���� + ����� + ������� + �������-���������
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70101() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70102() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost
  UNION ALL 
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70103() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70100() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70104() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost
  UNION ALL 
   -- �������� �� ����� ��������: ���� + �����
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70110() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70111() AS ProfitLossId, FALSE AS isSale, TRUE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_70000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_70110() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_70112() AS ProfitLossId, FALSE AS isSale, TRUE AS isCost
  ;


ALTER TABLE Constant_ProfitLoss_Sale_ReturnIn_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 24.11.14                                        * add zc_Enum_ProfitLoss_104.. and zc_Enum_ProfitLoss_108..
 13.05.14                                        * add zc_Enum_ProfitLoss_70...
 07.04.14                                        *
*/

-- ����
-- SELECT * FROM Constant_ProfitLoss_Sale_ReturnIn_View LEFT JOIN Object_ProfitLoss_View ON Object_ProfitLoss_View.ProfitLossId = Constant_ProfitLoss_Sale_ReturnIn_View.ProfitLossId ORDER BY 3
