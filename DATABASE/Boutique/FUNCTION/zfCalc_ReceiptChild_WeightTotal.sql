-- Function: zfCalc_ReceiptChild_isWeightTotal

DROP FUNCTION IF EXISTS zfCalc_ReceiptChild_isWeightTotal (Integer, Integer, Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_ReceiptChild_isWeightTotal(
    IN inGoodsId                Integer, -- 
    IN inGoodsKindId            Integer, -- 
    IN inInfoMoneyDestinationId Integer, -- 
    IN inInfoMoneyId            Integer, -- 
    IN inIsWeightMain           Boolean, -- 
    IN inIsTaxExit              Boolean  -- 
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- ���������� ���������
     RETURN (CASE WHEN inInfoMoneyId <> zc_Enum_InfoMoney_10202() -- �������� ����� + ������ ����� + ��������
                   AND inInfoMoneyId <> zc_Enum_InfoMoney_10203() -- �������� ����� + ������ ����� + ��������
                   AND inInfoMoneyId <> zc_Enum_InfoMoney_10204() -- �������� ����� + ������ ����� + ������ �����
                   AND (COALESCE (inIsTaxExit, FALSE) = FALSE
                     OR inInfoMoneyId = zc_Enum_InfoMoney_20901() -- ������������� + ����
                     OR inInfoMoneyId = zc_Enum_InfoMoney_30101() -- ������ + ��������� + ������� ���������
                     OR inInfoMoneyId = zc_Enum_InfoMoney_30201() -- ������ + ��������� + ������ �����
                       )
                     THEN TRUE
                 ELSE FALSE
           END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_ReceiptChild_isWeightTotal (Integer, Integer, Integer, Integer, Boolean, Boolean) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.03.15                                        *
*/
/*
-- ����
SELECT * FROM zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := 100
                                             , inGoodsKindId            := 1
                                             , inInfoMoneyDestinationId := 17
                                             , inInfoMoneyId            := 100
                                             , inIsWeightMain           := FALSE
                                             , inIsTaxExit              := FALSE
                                              )
*/