-- View: Constant_InfoMoney_isCorporate_View

DROP VIEW IF EXISTS Constant_InfoMoney_isCorporate_View CASCADE;

CREATE OR REPLACE VIEW Constant_InfoMoney_isCorporate_View
AS
   SELECT zc_Enum_InfoMoney_20801() AS InfoMoneyId -- ����
  UNION ALL 
   SELECT zc_Enum_InfoMoney_20901() AS InfoMoneyId -- ����
  UNION ALL 
   SELECT zc_Enum_InfoMoney_21001() AS InfoMoneyId -- �����
  UNION ALL 
   SELECT zc_Enum_InfoMoney_21101() AS InfoMoneyId -- �������
  UNION ALL 
   SELECT zc_Enum_InfoMoney_21151() AS InfoMoneyId -- �������-���������
  ;

ALTER TABLE Constant_InfoMoney_isCorporate_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.04.14                                        *
*/

-- ����
-- SELECT * FROM Constant_InfoMoney_isCorporate_View ORDER BY 1
