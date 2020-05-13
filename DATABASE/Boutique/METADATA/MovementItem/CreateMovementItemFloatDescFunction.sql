CREATE OR REPLACE FUNCTION zc_MIFloat_OperPriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_OperPriceList', '���� �� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceList');

CREATE OR REPLACE FUNCTION zc_MIFloat_OperPriceListReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceListReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_OperPriceListReal', '���� �� ������(����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceListReal');

CREATE OR REPLACE FUNCTION zc_MIFloat_OperPriceListTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceListTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_OperPriceListTo', '���� ����� (��� �������� ����������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceListTo');

CREATE OR REPLACE FUNCTION zc_MIFloat_OperPriceListTo_start() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceListTo_start'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_OperPriceListTo_start', '���� ����� (�� ����������, ��� �������� ����������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceListTo_start');

CREATE OR REPLACE FUNCTION zc_MIFloat_OperPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_OperPrice', '����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountForPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountForPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CountForPrice', '���� �� ����������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountForPrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountRemains', '��������� ������� �� ����� ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountRemains');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountSecond', '���������� ��������������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_ChangePercent', '(-)% ������ (+)% �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ChangePercent');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummChangePercent', '����� (-)������ (+)�������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChangePercent');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountSecondRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountSecondRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountSecondRemains', '���������� ����� - ��������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountSecondRemains');


CREATE OR REPLACE FUNCTION zc_MIFloat_TotalChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalChangePercent', '����� ����� ������ (� ���)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalChangePercent');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalChangePercentPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalChangePercentPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalChangePercentPay', '����� ����� ������ (� ���)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalChangePercentPay');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalPay', '����� ����� ������ (� ���)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPay');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalPayOth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPayOth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalPayOth', '����� ����� ������ (� ���)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPayOth');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalCountReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalCountReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalCountReturn', '����� ���������� ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalCountReturn');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalReturn', '����� ����� �������� �� ������� (� ���)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalReturn');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalPayReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPayReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalPayReturn', '����� ����� �������� ������ (� ���)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPayReturn');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountClient() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountClient'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountClient', '���������� � ���������� - ��������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountClient');

CREATE OR REPLACE FUNCTION zc_MIFloat_ParValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ParValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ParValue', '������� ������ ��� ������� �������� ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ParValue');

CREATE OR REPLACE FUNCTION zc_MIFloat_CurrencyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CurrencyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CurrencyValue', '���� ��� �������� �� ������ ������ � ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CurrencyValue');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceJur() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceJur'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceJur', '���� ��� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceJur');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummChangePercent_curr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChangePercent_curr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_SummChangePercent_curr', '����� �������������� ������ (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChangePercent_curr');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalChangePercent_curr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalChangePercent_curr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalChangePercent_curr', '����� ����� ������ (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalChangePercent_curr');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalChangePercentPay_curr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalChangePercentPay_curr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalChangePercentPay_curr', '����� ����� ������ (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalChangePercentPay_curr');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalPay_curr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPay_curr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalPay_curr', '����� ����� ������ (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPay_curr');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalPayOth_curr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPayOth_curr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalPayOth_curr', '����� ����� ������ (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPayOth_curr');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalReturn_curr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalReturn_curr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalReturn_curr', '����� ����� �������� �� ������� (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalReturn_curr');

CREATE OR REPLACE FUNCTION zc_MIFloat_TotalPayReturn_curr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPayReturn_curr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TotalPayReturn_curr', '����� ����� �������� ������ (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TotalPayReturn_curr');

CREATE OR REPLACE FUNCTION zc_MIFloat_OperPriceList_curr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceList_curr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_OperPriceList_curr', '���� ����� (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceList_curr');

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 13.05.20         * zc_MIFloat_SummChangePercent_curr
                    zc_MIFloat_TotalChangePercent_curr
                    zc_MIFloat_TotalChangePercentPay_curr
                    zc_MIFloat_TotalPay_curr
                    zc_MIFloat_TotalPayOth_curr
                    zc_MIFloat_TotalReturn_curr
                    zc_MIFloat_TotalPayReturn_curr
 05.02.19         * zc_MIFloat_PriceJur
 25.05.17                                                          *
 08.05.17         * zc_MIFloat_AmountSecondRemains
*/
