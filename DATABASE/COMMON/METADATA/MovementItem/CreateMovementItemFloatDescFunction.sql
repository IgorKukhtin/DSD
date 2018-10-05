CREATE OR REPLACE FUNCTION zc_MIFloat_AmountChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountChangePercent', '���������� c ������ % ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountChangePercent');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountColdHour() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountColdHour'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountColdHour', '�����, ���-�� ����� � ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountColdHour');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountColdDistance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountColdDistance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountColdDistance','�����, ���-�� ����� �� 100 ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountColdDistance');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountForecast() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountForecast'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountForecast', '�������(�������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountForecast');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountForecastOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountForecastOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountForecastOrder', '�������(������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountForecastOrder');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountForecastPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountForecastPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountForecastPromo', '�������(������� �����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountForecastPromo');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountForecastOrderPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountForecastOrderPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountForecastOrderPromo', '�������(������ �����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountForecastOrderPromo');


CREATE OR REPLACE FUNCTION zc_MIFloat_AmountFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountFuel','���-�� ����� �� 100 ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountFuel');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountNotice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountNotice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountNotice', '���������� � �����������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountNotice');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPacker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPacker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPacker', '���������� � ������������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPacker');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPartner', '���������� � �����������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartner');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPartnerPrior() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerPrior'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPartnerPrior', '����� ����������, ��������.'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerPrior');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPartnerPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPartnerPromo', '����� ���������� - �����, �������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerPromo');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPartnerPriorPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerPriorPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPartnerPriorPromo', '����� ���������� - �����, ��������.'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerPriorPromo');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPartnerNext() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerNext'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPartnerNext', '����� ���������� - ��� �����, ������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerNext');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPartnerNextPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerNextPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPartnerNextPromo', '����� ���������� - �����, ������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerNextPromo');
  
  
CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPack', '���-�� ���� ��� �������� (� �������, ����)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPack');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPackSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPackSecond', '���-�� ���� ��� �������� (� ������� � ��-��, ����)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPack_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPack_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPack_calc', '���-�� ���� ��� �������� (� �������, ������)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPack_calc');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPackSecond_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackSecond_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPackSecond_calc', '���-�� ���� ��� �������� (� ������� � ��-��, ������)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackSecond_calc');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountNext() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountNext'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountNext', '��-�� ����2 ������ � ���. �� ����'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountNext');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountNextSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountNextSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountNextSecond', '���-�� ����2 ������ � ���� �� ����'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountNextSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPackNext() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackNext'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPackNext', '��-�� ����2 ��� �������� (� �������, ����)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackNext');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPackNextSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackNextSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPackNextSecond', '���-�� ����2 ��� �������� (� ������� � ��-��, ����)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackNextSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPackNext_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackNext_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPackNext_calc', '���-�� ����2 ��� �������� (� �������, ������)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackNext_calc');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPackNextSecond_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackNextSecond_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPackNextSecond_calc', '���-�� ����2 ��� �������� (� ������� � ��-��, ������)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPackNextSecond_calc');


CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPartnerSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPartnerSecond', '���������� (��� ��������)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartnerSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountRemains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountRemains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountRemains', '��������� ������� �� ����� ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountRemains');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountReceipt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountReceipt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountReceipt', '���������� �� ��������� �� 1 �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountReceipt');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountSecond', '���������� ��������������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountManual() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountManual'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountManual', '����������, ������������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountManual');

CREATE OR REPLACE FUNCTION zc_MIFloat_BonusValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BonusValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_BonusValue', '% ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BonusValue');

CREATE OR REPLACE FUNCTION zc_MIFloat_BoxCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BoxCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_BoxCount','���������� ������ (�����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BoxCount');

CREATE OR REPLACE FUNCTION zc_MIFloat_BoxNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BoxNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_BoxNumber','����� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BoxNumber');

CREATE OR REPLACE FUNCTION zc_MIFloat_ChangePercentAmount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ChangePercentAmount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_ChangePercentAmount', '% ������ ��� ���-��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ChangePercentAmount');

CREATE OR REPLACE FUNCTION zc_MIFloat_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_ChangePercent', '(-)% ������ (+)% �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ChangePercent');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummChangePercent', '����� (-)������ (+)�������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChangePercent');

CREATE OR REPLACE FUNCTION zc_MIFloat_ContainerId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ContainerId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ContainerId', 'ContainerId' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ContainerId');

CREATE OR REPLACE FUNCTION zc_MIFloat_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_MovementId', 'MovementId' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MovementId');

CREATE OR REPLACE FUNCTION zc_MIFloat_MovementItemId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MovementItemId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_MovementItemId', 'MovementItemId' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MovementItemId');


CREATE OR REPLACE FUNCTION zc_MIFloat_ColdDistance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ColdDistance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ColdDistance', '�����, ���-�� ���� ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ColdDistance');

CREATE OR REPLACE FUNCTION zc_MIFloat_ColdHour() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ColdHour'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ColdHour', '�����, ���-�� ���� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ColdHour');

CREATE OR REPLACE FUNCTION zc_MIFloat_Count() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Count'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Count', '���������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Count');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CountPack', '���������� ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountPack');

CREATE OR REPLACE FUNCTION zc_MIFloat_CuterCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CuterCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CuterCount', '���������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CuterCount');

CREATE OR REPLACE FUNCTION zc_MIFloat_CuterWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CuterWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CuterWeight', '����������� ��� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CuterWeight');

CREATE OR REPLACE FUNCTION zc_MIFloat_CuterCountSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CuterCountSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CuterCountSecond', '���������� ������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CuterCountSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_TermProduction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TermProduction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_TermProduction', '���� ������������ � ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TermProduction');

CREATE OR REPLACE FUNCTION zc_MIFloat_NormInDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NormInDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_NormInDays', '����� ������ � ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NormInDays');

CREATE OR REPLACE FUNCTION zc_MIFloat_Koeff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Koeff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Koeff', '����������� ����������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Koeff');

CREATE OR REPLACE FUNCTION zc_MIFloat_StartProductionInDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_StartProductionInDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_StartProductionInDays', '����� ������� ���� ������ ������������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_StartProductionInDays');


CREATE OR REPLACE FUNCTION zc_MIFloat_CountForPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountForPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CountForPrice', '���� �� ����������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountForPrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountSkewer1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountSkewer1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CountSkewer1','���������� ������ ����1' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountSkewer1');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountSkewer2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountSkewer2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CountSkewer2','���������� ������ ����2' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountSkewer2');

CREATE OR REPLACE FUNCTION zc_MIFloat_DistanceFuelChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DistanceFuelChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_DistanceFuelChild','������, �� (�������������� ��� �������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DistanceFuelChild');

CREATE OR REPLACE FUNCTION zc_MIFloat_DistanceWeightTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DistanceWeightTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_DistanceWeightTransport','������, �� (� ������,����������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DistanceWeightTransport');

CREATE OR REPLACE FUNCTION zc_MIFloat_HeadCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_HeadCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_HeadCount', '���������� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_HeadCount');

CREATE OR REPLACE FUNCTION zc_MIFloat_LiveWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_LiveWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_LiveWeight', '����� ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_LiveWeight');

CREATE OR REPLACE FUNCTION zc_MIFloat_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Price', '����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Price');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceEDI() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceEDI'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_PriceEDI', '���� �� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceEDI');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_PriceSale', '����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceSale');

CREATE OR REPLACE FUNCTION zc_MIFloat_RealWeight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RealWeight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_RealWeight', '�������� ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RealWeight');

CREATE OR REPLACE FUNCTION zc_MIFloat_Remains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Remains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Remains', '�������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Remains');

CREATE OR REPLACE FUNCTION zc_MIFloat_Summ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Summ', '�����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Summ');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummFrom', '����� (����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummFrom');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummPriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummPriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummPriceList', '����� �� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummPriceList');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummService', '����� ���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummService');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummCard', '����� �� - 1�.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCard');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummCardRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCardRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummCardRecalc', '����� �� (����) - 1�.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCardRecalc');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummCardSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCardSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummCardSecond', '����� �� - 2�.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCardSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummCardSecondCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCardSecondCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummCardSecondCash', '����� �� (�����) - 2�.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCardSecondCash');
 
CREATE OR REPLACE FUNCTION zc_MIFloat_SummCardSecondRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCardSecondRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummCardSecondRecalc', '����� �� (����) - 2�.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummCardSecondRecalc');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummNalog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummNalog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummNalog', '������ - ��������� � ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummNalog');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummNalogRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummNalogRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummNalogRecalc', '������ - ��������� � �� (����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummNalogRecalc');
--
-- update MovementItemFloatDesc set  ItemName = '������ - ��������� � ��' where id = zc_MIFloat_SummNalog();
-- update MovementItemFloatDesc set  ItemName = '������ - ��������� � �� (����)' where id = zc_MIFloat_SummNalogRecalc();

CREATE OR REPLACE FUNCTION zc_MIFloat_SummNalogRet() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummNalogRet'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummNalogRet', '������ - ���������� � ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummNalogRet');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummNalogRetRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummNalogRetRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummNalogRetRecalc', '������ - ���������� � �� (����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummNalogRetRecalc');
--

CREATE OR REPLACE FUNCTION zc_MIFloat_SummChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummChild', '�������� - ���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChild');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummChildRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChildRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummChildRecalc', '�������� - ��������� (����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummChildRecalc');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummMinusExt() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummMinusExt'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummMinusExt', '��������� ������. ��.�.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummMinusExt');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummMinusExtRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummMinusExtRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummMinusExtRecalc', '��������� ������. ��.�. (����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummMinusExtRecalc');
  
CREATE OR REPLACE FUNCTION zc_MIFloat_SummMinus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummMinus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummMinus', '���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummMinus');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummAdd', '������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummAdd');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummAddOth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummAddOth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummAddOth', '������ (������������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummAddOth');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummAddOthRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummAddOthRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummAddOthRecalc', '������ (���� ��� �������������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummAddOthRecalc');


CREATE OR REPLACE FUNCTION zc_MIFloat_SummHoliday() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummHoliday'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummHoliday', '���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummHoliday');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummSocialIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummSocialIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummSocialIn', '��� ������� (� ��������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummSocialIn');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummSocialAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummSocialAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummSocialAdd', '��� ������� (� ��������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummSocialAdd');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummToPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummToPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummToPay', '����� � �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummToPay');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummTransport', '����� ��� (���������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTransport');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummPhone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummPhone', '����� ���.����� (���������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummPhone');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummTransportAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTransportAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummTransportAdd', '����� ��������������� (�������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTransportAdd');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummTransportAddLong() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTransportAddLong'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummTransportAddLong', '����� ������������ (�������, ���� ���������������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTransportAddLong');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummTransportTaxi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTransportTaxi'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummTransportTaxi', '����� �� ����� (�������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTransportTaxi');

CREATE OR REPLACE FUNCTION zc_MIFloat_StartOdometre() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_StartOdometre'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_StartOdometre', '��������� ��������� ���������, ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_StartOdometre');

CREATE OR REPLACE FUNCTION zc_MIFloat_EndOdometre() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_EndOdometre'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_EndOdometre', '��������� �������� ���������, ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_EndOdometre');

CREATE OR REPLACE FUNCTION zc_MIFloat_Weight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Weight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Weight', '��� ����� (���������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Weight');

CREATE OR REPLACE FUNCTION zc_MIFloat_WeightTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_WeightTransport', '��� �����, �� (����������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightTransport');

CREATE OR REPLACE FUNCTION zc_MIFloat_HoursWork() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_HoursWork'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_HoursWork','���������� ����� � �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_HoursWork');

CREATE OR REPLACE FUNCTION zc_MIFloat_RateFuelKindTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RateFuelKindTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_RateFuelKindTax','% ��������������� ������� � ����� � �������/������������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RateFuelKindTax');

CREATE OR REPLACE FUNCTION zc_MIFloat_Number() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Number'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Number','� �� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Number');

CREATE OR REPLACE FUNCTION zc_MIFloat_StartAmountFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_StartAmountFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_StartAmountFuel','��������� ������� ������� � ����������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_StartAmountFuel');

CREATE OR REPLACE FUNCTION zc_MIFloat_Distance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Distance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Distance','������ ����, ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Distance');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountPoint() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountPoint'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CountPoint','���-�� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountPoint');

CREATE OR REPLACE FUNCTION zc_MIFloat_TrevelTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TrevelTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TrevelTime','����� � ����, �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TrevelTime');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CountTare','���������� ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountTare');

CREATE OR REPLACE FUNCTION zc_MIFloat_WeightTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_WeightTare','��� ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightTare');

CREATE OR REPLACE FUNCTION zc_MIFloat_WeightSkewer1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightSkewer1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_WeightSkewer1','��� ������ ����1' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightSkewer1');

CREATE OR REPLACE FUNCTION zc_MIFloat_WeightSkewer2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightSkewer2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_WeightSkewer2',' 	��� ������ ����2' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightSkewer2');

CREATE OR REPLACE FUNCTION zc_MIFloat_WeightOther() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightOther'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_WeightOther','���, ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightOther');

CREATE OR REPLACE FUNCTION zc_MIFloat_WeightTotal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightTotal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_WeightTotal','��� 1 ��. ��������� + ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightTotal');

CREATE OR REPLACE FUNCTION zc_MIFloat_WeightPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_WeightPack','��� �������� ��� 1-�� ��. ���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightPack');

CREATE OR REPLACE FUNCTION zc_MIFloat_LevelNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_LevelNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_LevelNumber', '����� ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_LevelNumber');

CREATE OR REPLACE FUNCTION zc_MIFloat_ParValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ParValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ParValue', '������� ������ ��� ������� �������� ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ParValue');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceWithOutVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceWithOutVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceWithOutVAT', '���� �������� ��� ����� ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceWithOutVAT');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceWithVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceWithVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceWithVAT', '���� �������� � ������ ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceWithVAT');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountReal', '����� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountReal');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPlanMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPlanMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountPlanMin', '������� ������������ ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPlanMin');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPlanMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPlanMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountPlanMax', '�������� ������������ ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPlanMax');


CREATE OR REPLACE FUNCTION zc_MIFloat_PromoMovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PromoMovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PromoMovementId', 'MovementId-�����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PromoMovementId');


CREATE OR REPLACE FUNCTION zc_MIFloat_AmountOrder() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountOrder'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountOrder', '���-�� ������ (����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountOrder');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountOut', '���-�� ���������� (����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountOut');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountIn', '���-�� ������� (����)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountIn');

CREATE OR REPLACE FUNCTION zc_MIFloat_WeightTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_WeightTransport', '����� ����, ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_WeightTransport');

CREATE OR REPLACE FUNCTION zc_MIFloat_CorrBonus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CorrBonus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CorrBonus', '����� ������������� ����� �� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CorrBonus');

CREATE OR REPLACE FUNCTION zc_MIFloat_CorrReturnOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CorrReturnOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CorrReturnOut', '����� ������������� ����� �� ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CorrReturnOut');

CREATE OR REPLACE FUNCTION zc_MIFloat_CorrOther() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CorrOther'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CorrOther', '����� ������������� ����� �� ������ ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CorrOther');

CREATE OR REPLACE FUNCTION zc_MIFloat_NPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_NPP', '� �/� ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NPP');


CREATE OR REPLACE FUNCTION zc_MIFloat_NPP_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NPP_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_NPP_calc', '� �/� ��-����.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NPP_calc');

CREATE OR REPLACE FUNCTION zc_MIFloat_NPPTax_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NPPTax_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_NPPTax_calc', '� �/� ��-����.(�����.)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NPPTax_calc');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountTax_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountTax_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountTax_calc', '���-�� ��� ��-����.(�����.)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountTax_calc');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummTaxDiff_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTaxDiff_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummTaxDiff_calc', '����� ������������� ��� ��-����.(�����.)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummTaxDiff_calc');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceTax_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceTax_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_PriceTax_calc', '���� ��� ��-����.����(�����.)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceTax_calc');


CREATE OR REPLACE FUNCTION zc_MIFloat_RateSumma() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RateSumma'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_RateSumma', '����� ����������������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RateSumma');

CREATE OR REPLACE FUNCTION zc_MIFloat_RateSummaAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RateSummaAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_RateSummaAdd', '����� ������� (������������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RateSummaAdd');

CREATE OR REPLACE FUNCTION zc_MIFloat_RatePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RatePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_RatePrice', '������ ���/�� (������������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_RatePrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_Taxi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Taxi'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Taxi', '����� �� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Taxi');

CREATE OR REPLACE FUNCTION zc_MIFloat_TaxiMore() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TaxiMore'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TaxiMore', '����� �� ����� (��������, ��������������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TaxiMore');

CREATE OR REPLACE FUNCTION zc_MIFloat_TimePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TimePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_TimePrice', '������ ���/� ����������������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_TimePrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_MemberCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MemberCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_MemberCount', '���-�� ������� (���)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MemberCount');

CREATE OR REPLACE FUNCTION zc_MIFloat_DayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_DayCount', '�����. ��. 1 ��� (���.)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DayCount');

CREATE OR REPLACE FUNCTION zc_MIFloat_worktimehoursone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_worktimehoursone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_worktimehoursone', '�����. ����� 1 ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_worktimehoursone');

CREATE OR REPLACE FUNCTION zc_MIFloat_worktimehours() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_worktimehours'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_worktimehours', '�����. ����� (���)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_worktimehours');

CREATE OR REPLACE FUNCTION zc_MIFloat_HoursPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_HoursPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_HoursPlan', '����� ���� ����� � ����� �� ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_HoursPlan');

CREATE OR REPLACE FUNCTION zc_MIFloat_HoursDay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_HoursDay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_HoursDay', '������� ���� ����� �� ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_HoursDay');

CREATE OR REPLACE FUNCTION zc_MIFloat_PersonalCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PersonalCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PersonalCount', '���������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PersonalCount');

CREATE OR REPLACE FUNCTION zc_MIFloat_GrossOne() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_GrossOne'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_GrossOne', '���� �� 1-�� ���, ���-��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_GrossOne');

CREATE OR REPLACE FUNCTION zc_MIFloat_contractvalue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_contractvalue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_contractvalue', '�������� �� ������� ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_contractvalue');

CREATE OR REPLACE FUNCTION zc_MIFloat_ContractValueAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ContractValueAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ContractValueAdd', '���. �������� �� ������� ��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ContractValueAdd');

--
CREATE OR REPLACE FUNCTION zc_MIFloat_CurrMonthly() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CurrMonthly'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CurrMonthly', '���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CurrMonthly');

CREATE OR REPLACE FUNCTION zc_MIFloat_CurrNavigator() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CurrNavigator'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CurrNavigator', '���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CurrNavigator');

CREATE OR REPLACE FUNCTION zc_MIFloat_PrevNavigator() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PrevNavigator'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PrevNavigator', '����. ���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PrevNavigator');

CREATE OR REPLACE FUNCTION zc_MIFloat_Limit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Limit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Limit', '�����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Limit');

CREATE OR REPLACE FUNCTION zc_MIFloat_PrevLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PrevLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PrevLimit', '����.�����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PrevLimit');

CREATE OR REPLACE FUNCTION zc_MIFloat_DutyLimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DutyLimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_DutyLimit', '��������� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DutyLimit');

CREATE OR REPLACE FUNCTION zc_MIFloat_Overlimit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Overlimit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Overlimit', '���������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Overlimit');

CREATE OR REPLACE FUNCTION zc_MIFloat_PrevMonthly() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PrevMonthly'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PrevMonthly', '����.��������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PrevMonthly');

CREATE OR REPLACE FUNCTION zc_MIFloat_BalanceStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BalanceStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_BalanceStart', '���. ������� � ������������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BalanceStart');

CREATE OR REPLACE FUNCTION zc_MIFloat_BalanceEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BalanceEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_BalanceEnd', '������. ������� � ������������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BalanceEnd');

CREATE OR REPLACE FUNCTION zc_MIFloat_CurrencyPartnerValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CurrencyPartnerValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CurrencyPartnerValue', '���� ��� ������� ����� �������� � ���'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CurrencyPartnerValue');

CREATE OR REPLACE FUNCTION zc_MIFloat_ParPartnerValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ParPartnerValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_ParPartnerValue', '������� ��� ������� ����� �������� � ���'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ParPartnerValue');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountCurrency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountCurrency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountCurrency', '����� �������� (� ������)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountCurrency');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountRetIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountRetIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountRetIn', '���-�� ������� (�� ������)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountRetIn');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceIn1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceIn1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceIn1', '���-�� - 1 ����, ���/��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceIn1');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceIn2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceIn2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceIn2', '���-�� - 2 ����, ���/��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceIn2');

CREATE OR REPLACE FUNCTION zc_MIFloat_ContractCondition() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ContractCondition'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ContractCondition', '����� ����, %' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ContractCondition');

CREATE OR REPLACE FUNCTION zc_MIFloat_Plan1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Plan1', '���-�� ���� �������� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan1');

CREATE OR REPLACE FUNCTION zc_MIFloat_Plan2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Plan2', '���-�� ���� �������� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan2');

CREATE OR REPLACE FUNCTION zc_MIFloat_Plan3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Plan3', '���-�� ���� �������� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan3');

CREATE OR REPLACE FUNCTION zc_MIFloat_Plan4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Plan4', '���-�� ���� �������� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan4');

CREATE OR REPLACE FUNCTION zc_MIFloat_Plan5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Plan5', '���-�� ���� �������� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan5');

CREATE OR REPLACE FUNCTION zc_MIFloat_Plan6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Plan6', '���-�� ���� �������� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan6');

CREATE OR REPLACE FUNCTION zc_MIFloat_Plan7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Plan7', '���-�� ���� �������� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Plan7');

CREATE OR REPLACE FUNCTION zc_MIFloat_Promo1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Promo1', '���-�� ���� ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo1');

CREATE OR REPLACE FUNCTION zc_MIFloat_Promo2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Promo2', '���-�� ���� ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo2');

CREATE OR REPLACE FUNCTION zc_MIFloat_Promo3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Promo3', '���-�� ���� ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo3');

CREATE OR REPLACE FUNCTION zc_MIFloat_Promo4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Promo4', '���-�� ���� ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo4');

CREATE OR REPLACE FUNCTION zc_MIFloat_Promo5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Promo5', '���-�� ���� ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo5');

CREATE OR REPLACE FUNCTION zc_MIFloat_Promo6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Promo6', '���-�� ���� ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo6');

CREATE OR REPLACE FUNCTION zc_MIFloat_Promo7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Promo7', '���-�� ���� ����� �� ��.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Promo7');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceTender() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceTender'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceTender', '���� ������ ��� ����� ���, � ������ ������, ���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceTender');

----!!!!!!Farmacy

CREATE OR REPLACE FUNCTION zc_MIFloat_JuridicalPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_JuridicalPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_JuridicalPrice', '���� ����������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_JuridicalPrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_JuridicalPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_JuridicalPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_JuridicalPercent', '% ������������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_JuridicalPercent');

CREATE OR REPLACE FUNCTION zc_MIFloat_ContractPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ContractPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ContractPercent', '% ������������� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ContractPercent');


CREATE OR REPLACE FUNCTION zc_MIFloat_PriceFrom() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceFrom'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceFrom', '���� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceFrom');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceTo', '���� �������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceTo');

CREATE OR REPLACE FUNCTION zc_MIFloat_MCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MCS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_MCS', '���' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MCS');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_PriceMax', '����. ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceMax');

--
CREATE OR REPLACE FUNCTION zc_MIFloat_PartionGoods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PartionGoods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_PartionGoods', '���� ��������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PartionGoods');

CREATE OR REPLACE FUNCTION zc_MIFloat_MinimumLot() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MinimumLot'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_MinimumLot', '���. ������.'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MinimumLot');

CREATE OR REPLACE FUNCTION zc_MIFloat_MCS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MCS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_MCS', '���'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MCS');

CREATE OR REPLACE FUNCTION zc_MIFloat_Remains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Remains'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Remains', '�������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Remains');

CREATE OR REPLACE FUNCTION zc_MIFloat_Income() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Income'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Income', '������� �������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Income');

CREATE OR REPLACE FUNCTION zc_MIFloat_Check() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Check'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Check', '������� �� ���.����'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Check');

CREATE OR REPLACE FUNCTION zc_MIFloat_Reserved() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Reserved'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Reserved', '���-�� � ���������� �����'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Reserved');

CREATE OR REPLACE FUNCTION zc_MIFloat_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Send'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Send', '��������������� ������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Send');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountDeferred() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountDeferred'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountDeferred', '����� �������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountDeferred');

CREATE OR REPLACE FUNCTION zc_MIFloat_PrintCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PrintCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_PrintCount', '���-�� ���������� ��������'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PrintCount');

CREATE OR REPLACE FUNCTION zc_MIFloat_GPSN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_GPSN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_GPSN', 'GPS ���������� (������)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_GPSN');

CREATE OR REPLACE FUNCTION zc_MIFloat_GPSE() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_GPSE'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_GPSE', 'GPS ���������� (�������)'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_GPSE');

CREATE OR REPLACE FUNCTION zc_MIFloat_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Amount', '���-�� ������ �� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Amount');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountMin', '��� ���-�� ������ �� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountMin');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_AmountMax', '���� ���-�� ������ �� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountMax');

CREATE OR REPLACE FUNCTION zc_MIFloat_NumberMin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NumberMin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_NumberMin', '� ������� ������ � ���. ���-��� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NumberMin');

CREATE OR REPLACE FUNCTION zc_MIFloat_NumberMax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NumberMax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_NumberMax', '� ������� ������ � ����. ���-��� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_NumberMax');

-- GoodsSP
CREATE OR REPLACE FUNCTION zc_MIFloat_ColSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ColSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_ColSP', '� �.�.(���. ������)(1)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_ColSP');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_CountSP', 'ʳ������ ������� ���������� ������ � ��������� �������� (���. ������)(6)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountSP');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceOptSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceOptSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceOptSP', '������-�������� ���� �� ��������, ���(���. ������)(11)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceOptSP');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceRetSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceRetSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceRetSP', '�������� ���� �� ��������, ���(���. ������)(12)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceRetSP');

CREATE OR REPLACE FUNCTION zc_MIFloat_DailyNormSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DailyNormSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_DailyNormSP', '������ ���� ���������� ������, ������������� ����(���. ������)(13)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DailyNormSP');

CREATE OR REPLACE FUNCTION zc_MIFloat_DailyCompensationSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DailyCompensationSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_DailyCompensationSP', '����� ������������ ������ ���� ���������� ������, ���(���. ������)(14)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DailyCompensationSP');

CREATE OR REPLACE FUNCTION zc_MIFloat_PriceSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PriceSP', '����� ������������ �� ��������(���. ������)(15)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceSP');

CREATE OR REPLACE FUNCTION zc_MIFloat_PaymentSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PaymentSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_PaymentSP', '���� ������� �� ��������, ���(���. ������)(16)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PaymentSP');

CREATE OR REPLACE FUNCTION zc_MIFloat_GroupSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_GroupSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_GroupSP', '����� �������-����� � � ��� ��' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_GroupSP');
--
CREATE OR REPLACE FUNCTION zc_MIFloat_PriceSample() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceSample'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_PriceSample', '���� �����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_PriceSample');

CREATE OR REPLACE FUNCTION zc_MIFloat_FactOfManDays() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_FactOfManDays'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_FactOfManDays', '���������� ����' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_FactOfManDays');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountTheFineTab() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountTheFineTab'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountTheFineTab', '����� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountTheFineTab');

CREATE OR REPLACE FUNCTION zc_MIFloat_BonusAmountTab() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BonusAmountTab'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_BonusAmountTab', '����� ������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BonusAmountTab');

CREATE OR REPLACE FUNCTION zc_MIFloat_MarkRatio() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MarkRatio'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_MarkRatio', '����������� �� ���������� ����� �� ����������' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MarkRatio');



/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.  �������� �.�.   ������ �.�.
 05.10.18                                                                                                     * zc_MIFloat_PriceSample
 24.09.18         * zc_MIFloat_PriceSample
 11.09.18         * zc_MIFloat_PriceMax
 31.08.18         * zc_MIFloat_Reserved
 13.08.18         * for GoodsSP
 25.06.18         * zc_MIFloat_SummAddOth
                    zc_MIFloat_SummAddOthRecalc
 12.04.18         * zc_MIFloat_PriceTax_calc
 24.01.18         * zc_MIFloat_PriceTender
 05.01.18         * zc_MIFloat_SummNalogRet
                    zc_MIFloat_SummNalogRetRecalc
 20.11.17         * zc_MIFloat_AmountMin
                    zc_MIFloat_AmountMax
                    zc_MIFloat_NumberMin
                    zc_MIFloat_NumberMax
 19.11.17         * zc_MIFloat_Amount
 17.11.17         * zc_MIFloat_AmountNext, ....
 27.10.17         * zc_MIFloat_AmountPartnerPromo
                    zc_MIFloat_AmountPartnerPriorPromo
                    zc_MIFloat_AmountForecastPromo
                    zc_MIFloat_AmountForecastOrderPromo
 24.10.17         * zc_MIFloat_RateSummaAdd
 03.08.17         * zc_MIFloat_AmountRetIn
                    zc_MIFloat_PriceIn1
                    zc_MIFloat_PriceIn2
                    zc_MIFloat_ContractCondition
 31.07.17         * zc_MIFloat_CurrencyPartnerValue
                    zc_MIFloat_ParPartnerValue
                    zc_MIFloat_AmountCurrency
 20.06.17         * zc_MIFloat_SummCardSecondCash
 20.04.17                                                                                    * zc_MIFloat_GPSN, zc_MIFloat_GPSE
 27.01.17         * zc_MIFloat_PrintCount
 22.12.16         *
 14.07.16         *
 04.07.16         *
 20.06.16         *
 20.04.16         *
 17.02.16         *
 16.12.15         * add zc_MIFloat_WeightTransport
 31.10.15                                                                        *zc_MIFloat_PriceWithOutVAT, zc_MIFloat_PriceWithVAT, zc_MIFloat_AmountReal, zc_MIFloat_AmountPlanMin, zc_MIFloat_AmountPlanMax
 11.02.15         * add zc_MIFloat_AmountRemains
                        zc_MIFloat_AmountPartner
                        zc_MIFloat_AmountForecast
 02.12.14                                        * add zc_MIFloat_ContainerId
 10.11.14                                        * add zc_MIFloat_ParValue
 19.10.14                                        * add zc_MIFloat_AmountNotice
 15.10.14                                        * add zc_MIFloat_BoxNumber and zc_MIFloat_LevelNumber
 09.10.14                                                       * add zc_MIFloat_BoxCount
 23.12.13         * add zc_MIFloat_Distance, zc_MIFloat_CountPoint, zc_MIFloat_TrevelTime
 10.12.13         * add DistanceWeightTransport
 15.10.13                                        * add zc_MIFloat_StartAmountFuel
 07.10.13                                        * add zc_MIFloat_DistanceFuelChild
 01.10.13                                        * add zc_MIFloat_RateFuelKindTax and zc_MIFloat_Number
 29.09.13                                        * add by transport
 08.09.13                                        * add zc_MIFloat_AmountChangePercent
 02.09.13                                        * add zc_MIFloat_ChangePercentAmount
 01.08.13         * add zc_MIFloat_AmountSecond
 12.07.13                                        * ����� �����2
 30.06.13                                        * rename zc_MI...
 29.06.13                                        * ����� �����
 29.06.13                                        * zc_MIFloat_AmountPacker
*/
