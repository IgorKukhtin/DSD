
CREATE OR REPLACE FUNCTION zc_MovementFloat_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Amount', '����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountCurrency() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCurrency'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_AmountCurrency', '����� �������� (� ������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCurrency');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercent', '(-)% ������ (+)% �������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercent'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePercentPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePercentPartner', '(-)% ������ (+)% ������� ���������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePercentPartner'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_ChangePrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc (Code, ItemName)
  SELECT 'zc_MovementFloat_ChangePrice', '������ � ����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ChangePrice'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_CurrencyPartnerValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyPartnerValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CurrencyPartnerValue', '���� ��� ������� ����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyPartnerValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CurrencyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CurrencyValue', '���� ������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_DayCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DayCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DayCount', '���������� ���� �������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DayCount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_HoursAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_HoursAdd', '���-�� ����������� ������� �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_HoursWork() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursWork'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_HoursWork', '���-�� ������� �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_HoursWork');

CREATE OR REPLACE FUNCTION zc_MovementFloat_InvNumberTransport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_InvNumberTransport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_InvNumberTransport', '����� �������� �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_InvNumberTransport');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MedocCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MedocCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MedocCode', '��� � MEDOC' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MedocCode');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MovementDesc', '��� ���������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDesc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_MovementDescNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDescNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MovementDescNumber', '��� �������� (�����������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementDescNumber');


CREATE OR REPLACE FUNCTION zc_MovementFloat_ParValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ParValue', '�������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ParPartnerValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParPartnerValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ParPartnerValue', '������� ��� ������� ����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParPartnerValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_StartAmountTicketFuel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartAmountTicketFuel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_StartAmountTicketFuel', '��������� ������� ������� �� ������� ��������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartAmountTicketFuel');

CREATE OR REPLACE FUNCTION zc_MovementFloat_StartSummCash() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartSummCash'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_StartSummCash', '��������� ������� ����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_StartSummCash');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCount', '����� ����������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCount'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountChild', '����� ���������� (����������� ��������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountChild');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountKg() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountKg'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
 SELECT 'zc_MovementFloat_TotalCountKg', '����� ����������, ��' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountKg'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountPartner', '����� ���������� � �����������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountPartner'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountTare() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountTare'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountTare', '����� ����������, ����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountTare'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountSecond', ' ����� ���������� ������� ' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSecond'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountSh() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSh'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountSh', '����� ����������, ��' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountSh'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm', '����� ����� �� ��������� (� ������ ��� � ������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSale', '����� ����������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSale'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummService() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummService'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummService', '����� ����� ���������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummService'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCard() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCard'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCard', '����� ����� �� ��������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCard'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMinus() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinus'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMinus', '����� ����� ���������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMinus'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummAdd', '����� ����� ������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummAdd'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSocialIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSocialIn', '����� ����� ���.������� (� ��������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialIn'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSocialAdd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialAdd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSocialAdd', '����� ����� ���.������� (� ��������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSocialAdd');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCardRecalc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardRecalc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCardRecalc', '����� ����� �� �������� (��) ��� �������������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCardRecalc'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummToPay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummToPay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummToPay', '����� ����� � �������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummToPay'); 


CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummChild', '����� ����� �������� (���������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChild'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPacker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPacker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPacker', '����� ����� ������������ �� ��������� (� ������ ���)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPacker');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMVAT', '����� ����� �� ��������� (��� ���)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPVAT', '����� ����� �� ��������� (� ���)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummChange() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChange'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummChange', '����� ����� ������ �� ���������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummChange'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummSpending() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSpending'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummSpending', '����� ����� ������ �� ��������� (� ������ ���)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummSpending');

CREATE OR REPLACE FUNCTION zc_MovementFloat_VATPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_VATPercent', '% ���' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent'); 

CREATE OR REPLACE FUNCTION zc_MovementFloat_WeighingNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_WeighingNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_WeighingNumber', '����� �����������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_WeighingNumber');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDeficitSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDeficitSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDeficitSumm', '����� ����� ���������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDeficitSumm');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalProficitSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalProficitSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalProficitSumm', '����� ����� �������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalProficitSumm');
  
CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDiff() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiff'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDiff', '����� ������� � ����������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiff');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDiffSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiffSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDiffSumm', '����� ������� � �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiffSumm');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPrimeCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPrimeCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPrimeCost', '����� ����� ������������� (�������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPrimeCost');

CREATE OR REPLACE FUNCTION zc_MovementFloat_CostPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CostPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CostPromo', '��������� ������� � �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CostPromo');
  
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 31.10.15                                                                      *zc_MovementFloat_CostPromo
 02.07.15         * rename zc_MovementFloat_ChangePercentTo in zc_MovementFloat_ChangePercentPartner
 29.06.15         * add zc_MovementFloat_ChangePercentTo
 19.10.14                                        * add zc_MovementFloat_TotalCountSecond
 11.10.14                                        * add zc_MovementFloat_WeighingNumber
 23.07.14         * add CurrencyValue
 11.03.14         * add MovementDesc, InvNumberTransport
 19.10.13                                        * add zc_MovementFloat_ChangePrice
 15.10.13                                        * add zc_MovementFloat_StartSummCash and zc_MovementFloat_StartAmountTicketFuel
 30.09.13                                        * restore :-) zc_MovementFloat_Amount - ����� ��������
 29.09.13                                        * del zc_MovementFloat_Cold - ������� ������� �� ����������
 29.09.13                                        * del zc_MovementFloat_Norm - ����� ������� �������
 29.09.13                                        * del zc_MovementFloat_Amount - ����� ��������
 25.09.13         * rename MorningOdometr - StartOdometre, EveningOdometre - EndOdometre; add  HoursWork, HoursAdd             
 20.08.13         *  add zc_MovementFloat_MorningOdometre, zc_MovementFloat_EveningOdometre, zc_MovementFloat_Distance, zc_MovementFloat_Cold, zc_MovementFloat_Norm   
 13.08.13                                        * add zc_MovementFloat_TotalCountChild and zc_MovementFloat_TotalCountPartner
 10.07.13                                        * PLPGSQL
 08.07.13                                        * ����� �����2 - Create and Insert
 30.06.13                                        * ����� �����
*/
