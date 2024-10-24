
CREATE OR REPLACE FUNCTION zc_MovementFloat_CurrencyValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_CurrencyValue', '���� ������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_CurrencyValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_ParValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_ParValue', '�������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_ParValue');

CREATE OR REPLACE FUNCTION zc_MovementFloat_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Amount', '�����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Amount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_OperPrice_load() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_OperPrice_load'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_OperPrice_load', '���� � ����� (Basis+options)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_OperPrice_load');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TransportSumm_load() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TransportSumm_load'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TransportSumm_load', '����� ��������� � �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TransportSumm_load');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TransportSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TransportSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TransportSumm', '����� ���������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TransportSumm');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCount', '����� ����������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCount');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm', '����� ����� �� ��������� (��� ��� � � ������ ���� �������� � ������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm');

CREATE OR REPLACE FUNCTION zc_MovementFloat_VATPercent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_VATPercent', '% ���' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMVAT', '����� ����� �� ��������� (��� ���)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPVAT', '����� ����� �� ��������� (� ���)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT');

CREATE OR REPLACE FUNCTION zc_MovementFloat_DiscountNextTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiscountNextTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DiscountNextTax', '(-)% ������ (+)% ������� ��������������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiscountNextTax');

 CREATE OR REPLACE FUNCTION zc_MovementFloat_AmountCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_AmountCost', '����� ������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_AmountCost');

  CREATE OR REPLACE FUNCTION zc_MovementFloat_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_MovementId', '������ �� ��������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_MovementId');

  CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummCost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummCost', '����� ������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummCost');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalCountChild() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountChild'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalCountChild', '����� ���������� (������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalCountChild');


CREATE OR REPLACE FUNCTION zc_MovementFloat_DiscountTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiscountTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DiscountTax', '% ������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiscountTax');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummTaxPVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTaxPVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummTaxPVAT', '����� ������ � ���' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTaxPVAT');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummTaxMVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTaxMVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummTaxMVAT', '����� ������ ��� ���' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTaxMVAT');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummPost() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummPost'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummPost', '�������� �������, ��� ���' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummPost');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummPack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummPack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummPack', '�������� �������, ��� ���' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummPack');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummInsur() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummInsur'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummInsur', '��������� �������, ��� ���' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummInsur');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDiscountTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiscountTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDiscountTax', '% ������, �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiscountTax');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTaxPVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTaxPVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTaxPVAT', '����� ������ � ���, �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTaxPVAT');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTaxMVAT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTaxMVAT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTaxMVAT', '����� ������ ��� ���, �����' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTaxMVAT');



CREATE OR REPLACE FUNCTION zc_MovementFloat_DiscountTax_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiscountTax_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DiscountTax_calc', '% ������ (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiscountTax_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_DiscountNextTax_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiscountNextTax_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_DiscountNextTax_calc', '(-)% ������ (+)% ������� ��������������(����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_DiscountNextTax_calc');


CREATE OR REPLACE FUNCTION zc_MovementFloat_SummTaxPVAT_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTaxPVAT_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummTaxPVAT_calc', '����� ������ � ��� (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTaxPVAT_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummTaxMVAT_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTaxMVAT_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummTaxMVAT_calc', '����� ������ ��� ��� (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTaxMVAT_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummPost_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummPost_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummPost_calc', '�������� �������, ��� ��� (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummPost_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummPack_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummPack_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummPack_calc', '�������� �������, ��� ��� (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummPack_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummInsur_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummInsur_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummInsur_calc', '��������� �������, ��� ��� (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummInsur_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalDiscountTax_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiscountTax_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalDiscountTax_calc', '% ������, ����� (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalDiscountTax_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTaxPVAT_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTaxPVAT_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTaxPVAT_calc', '����� ������ � ���, ����� (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTaxPVAT_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummTaxMVAT_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTaxMVAT_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummTaxMVAT_calc', '����� ������ ��� ���, ����� (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummTaxMVAT_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSumm_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSumm_calc', '����� ����� �� ��������� (��� ���, � ������ ������, ��� ����������) (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSumm_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummPVAT_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummPVAT_calc', '����� ����� �� ��������� (� ������ ��� � ������, ��� ����������) (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummPVAT_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TotalSummMVAT_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TotalSummMVAT_calc', '����� ����� �� ��������� (��� ���, � ������ ������, ��� ����������) (����.)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TotalSummMVAT_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummTax_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTax_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummTax_calc', '����� ������ ������ (��� ���) (������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTax_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummReal_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummReal_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummReal_calc', '����� ����� ���� (��� ���, � ������ ������, ��� ����������)(������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummReal_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_Basis_summ_transport_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Basis_summ_transport_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_Basis_summ_transport_calc', '����� ����� �� ��������� (��� ���, � ������ ������, c �����������) (������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_Basis_summ_transport_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_BasisWVAT_summ_transport_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BasisWVAT_summ_transport_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_BasisWVAT_summ_transport_calc', '����� ����� �� ��������� (� ���, � ������ ������, c �����������) (������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_BasisWVAT_summ_transport_calc');


CREATE OR REPLACE FUNCTION zc_MovementFloat_TransportSumm_load_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TransportSumm_load_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TransportSumm_load_calc', '����� ����� �� ���������� � ����� (������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TransportSumm_load_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_TransportSumm_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TransportSumm_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_TransportSumm_calc', '����� ����� �� ���������� (������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_TransportSumm_calc');

CREATE OR REPLACE FUNCTION zc_MovementFloat_VATPercent_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_VATPercent_calc', '% ��� (������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_VATPercent_calc');
                    


CREATE OR REPLACE FUNCTION zc_MovementFloat_NPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_NPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_NPP', '����������� ������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_NPP');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummReal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummReal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummReal', '����� ����� ���� (��� ���, � ������ ������, ��� ����������)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummReal');

CREATE OR REPLACE FUNCTION zc_MovementFloat_SummTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_SummTax', '����� ������ ������ (��� ���)' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_SummTax');


CREATE OR REPLACE FUNCTION zc_MovementFloat_14() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_14'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementFloatDesc(Code, ItemName)
  SELECT 'zc_MovementFloat_14', '������ ����� ������������' WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Code = 'zc_MovementFloat_14');





/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.01.24         *
 15.05.23         * zc_MovementFloat_SummReal
                    zc_MovementFloat_SummTax
 04.02.23         * zc_MovementFloat_NPP
 13.10.21         *
 12.07.21         * zc_MovementFloat_TotalCountChild
 10.06.21         * zc_MovementFloat_TotalSummCost
 08.02.21         * zc_MovementFloat_TotalCount
 02.02.21         * zc_MovementFloat_Amount
 24.08.20                                        *
*/
