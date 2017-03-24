--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! ����� ����� !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE FUNCTION zc_MovementDate_Branch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Branch', '���� ��������� ��� �����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Branch');

CREATE OR REPLACE FUNCTION zc_MovementDate_DateRegistered() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_DateRegistered'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_DateRegistered', '���� �����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_DateRegistered');

CREATE OR REPLACE FUNCTION zc_MovementDate_EndRun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndRun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_EndRun', '����/����� ����������� ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndRun');

CREATE OR REPLACE FUNCTION zc_MovementDate_COMDOC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_COMDOC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_COMDOC', '���� COMDOC' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_COMDOC');

CREATE OR REPLACE FUNCTION zc_MovementDate_EndRunPlan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndRunPlan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_EndRunPlan', '����/����� ����������� ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndRunPlan');

CREATE OR REPLACE FUNCTION zc_MovementDate_EndWeighing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndWeighing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_EndWeighing', '�������� ��������� �����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndWeighing');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateMark() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateMark', '���� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateMark');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateMark'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateMark', '���� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateMark');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDatePartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDatePartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDatePartner', '���� ��������� � �����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDatePartner');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateSaleLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateSaleLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateSaleLink', '���� ��������� ������� ����������� (�������� ��������)' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateSaleLink');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateTax', '���� ��������� ���������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateTax');

CREATE OR REPLACE FUNCTION zc_MovementDate_Payment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Payment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Payment', '���� �������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Payment');

CREATE OR REPLACE FUNCTION zc_MovementDate_ServiceDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_ServiceDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_ServiceDate', '����� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_ServiceDate');

CREATE OR REPLACE FUNCTION zc_MovementDate_StartRun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartRun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_StartRun', '����/����� ������ ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartRun');
CREATE OR REPLACE FUNCTION zc_MovementDate_EndRun() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndRun'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;

CREATE OR REPLACE FUNCTION zc_MovementDate_startweighing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_startweighing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_startweighing', '�������� ������ �����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_startweighing');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateCertificate', '����������� �������� ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateCertificate');
  
CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateIn', '���� � ��� ������������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateIn');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateOut() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateOut'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateOut', '���� ������������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateOut');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateStart', '���� ������� (���.)' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateStart');

CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateEnd', '���� ������� (������.)' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateEnd');

CREATE OR REPLACE FUNCTION zc_MovementDate_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Insert', '����/����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert');

CREATE OR REPLACE FUNCTION zc_MovementDate_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Update', '����/����� �������������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update');

CREATE OR REPLACE FUNCTION zc_MovementDate_StartPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_StartPromo', '���� ������ �����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartPromo');
  
CREATE OR REPLACE FUNCTION zc_MovementDate_EndPromo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndPromo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_EndPromo', '���� ��������� �����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndPromo');

CREATE OR REPLACE FUNCTION zc_MovementDate_StartSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_StartSale', '���� ������ �������� �� ��������� ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartSale');
  
CREATE OR REPLACE FUNCTION zc_MovementDate_EndSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_EndSale', '���� ��������� �������� �� ��������� ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndSale');

CREATE OR REPLACE FUNCTION zc_MovementDate_EndReturn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndReturn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_EndReturn', '���� ��������� ��������� �� ��������� ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndReturn');
  
CREATE OR REPLACE FUNCTION zc_MovementDate_OperDateSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OperDateSP', '���� ������� (���. ������)' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OperDateSP');

CREATE OR REPLACE FUNCTION zc_MovementDate_InsertMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_InsertMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_InsertMobile', '����/����� �������� �� ��������� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_InsertMobile');
    
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �. �.    ��������� �.�.   �������� �.�.
 24.03.17                                                                                          * zc_MovementDate_InsertMobile
 22.12.16         * zc_MovementDate_OperDateSP
 31.10.15                                                                         *zc_MovementDate_StartPromo, zc_MovementDate_EndPromo, zc_MovementDate_StartSale, zc_MovementDate_EndSale
 04.05.15         				 * add zc_MovementDate_Insert and zc_MovementDate_Update
 09.02.15         						*
 19.07.14                                        * del zc_MovementDate_SaleOperDate
 11.03.14         * add startweighing, EndWeighing
 09.02.14                                                           * add  zc_MovementDate_DateRegistered
 25.09.13         * del zc_MovementDate_WorkTime; add  StartRunPlan, EndRunPlan, StartRun, EndRun
 20.08.13         * add zc_MovementDate_WorkTime
 12.08.13         * add zc_MovementDate_ServiceDate
 01.08.13         * add zc_MovementDate_OperDateMark
 08.07.13                                        * ����� ����� - Create and Insert
 30.06.13                                        * ����� �����
*/
