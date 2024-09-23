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
  
CREATE OR REPLACE FUNCTION zc_MovementDate_StartWeighing() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartWeighing'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_StartWeighing', '�������� ������ �����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartWeighing');
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
  
CREATE OR REPLACE FUNCTION zc_MovementDate_StartBegin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartBegin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_StartBegin', '�������� ����/����� ������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartBegin');

CREATE OR REPLACE FUNCTION zc_MovementDate_EndBegin() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndBegin'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_EndBegin', '�������� ����/����� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndBegin');

CREATE OR REPLACE FUNCTION zc_MovementDate_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Insert', '����/����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Insert');

CREATE OR REPLACE FUNCTION zc_MovementDate_StatusInsert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StatusInsert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_StatusInsert', '����/����� ������� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StatusInsert');


CREATE OR REPLACE FUNCTION zc_MovementDate_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Update', '����/����� �������������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Update');

CREATE OR REPLACE FUNCTION zc_MovementDate_NPP_calc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_NPP_calc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_NPP_calc', '����/����� ������������ ��/�' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_NPP_calc');

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
    
CREATE OR REPLACE FUNCTION zc_MovementDate_UpdateMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_UpdateMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_UpdateMobile', '����/����� ���������� � ���������� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_UpdateMobile');

CREATE OR REPLACE FUNCTION zc_MovementDate_Check() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Check'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Check', '���� �������� �������������� �����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Check');

CREATE OR REPLACE FUNCTION zc_MovementDate_Month() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Month'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Month', '����� �����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Month');

CREATE OR REPLACE FUNCTION zc_MovementDate_AdjustingOurDate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_AdjustingOurDate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_AdjustingOurDate', '������������� ����� ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_AdjustingOurDate');

CREATE OR REPLACE FUNCTION zc_MovementDate_DatePayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_DatePayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_DatePayment', '���� ������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_DatePayment');

CREATE OR REPLACE FUNCTION zc_MovementDate_Checked() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Checked'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Checked', '���� ����� ����������/������ ����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Checked');

CREATE OR REPLACE FUNCTION zc_MovementDate_Union() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Union'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Union', '���� ����� ���������� ���.' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Union');

CREATE OR REPLACE FUNCTION zc_MovementDate_UserConfirmedKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_UserConfirmedKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_UserConfirmedKind', '���� ����� ����������/������ ����� �����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_UserConfirmedKind');

CREATE OR REPLACE FUNCTION zc_MovementDate_BeginDateStart() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_BeginDateStart'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_BeginDateStart', '��� ���� �������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_BeginDateStart');

CREATE OR REPLACE FUNCTION zc_MovementDate_BeginDateEnd() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_BeginDateEnd'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_BeginDateEnd', '������ ���� �������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_BeginDateEnd');

CREATE OR REPLACE FUNCTION zc_MovementDate_DateEndPUSH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_DateEndPUSH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_DateEndPUSH', '���� ����� ��������� ���������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_DateEndPUSH');

CREATE OR REPLACE FUNCTION zc_MovementDate_Delay() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Delay'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Delay', '���� ��������� ��������� ��� ������������� ���������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Delay');

CREATE OR REPLACE FUNCTION zc_MovementDate_Sent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Sent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Sent', '���� ��������� �������� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Sent');

CREATE OR REPLACE FUNCTION zc_MovementDate_Deferred() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Deferred'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Deferred', '���� ��������� �������� �������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Deferred');

CREATE OR REPLACE FUNCTION zc_MovementDate_Calculation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Calculation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Calculation', '���� �������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Calculation');

CREATE OR REPLACE FUNCTION zc_MovementDate_Compensation() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Compensation'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Compensation', '���� �����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Compensation');


CREATE OR REPLACE FUNCTION zc_MovementDate_StartStop() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartStop'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_StartStop', '����/����� ������ �������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_StartStop');

CREATE OR REPLACE FUNCTION zc_MovementDate_EndStop() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndStop'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_EndStop', '����/����� ��������� �������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_EndStop');

CREATE OR REPLACE FUNCTION zc_MovementDate_UserConfirmedKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_UserConfirmedKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_UserConfirmedKind', '����/����� �������������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_UserConfirmedKind');


CREATE OR REPLACE FUNCTION zc_MovementDate_CheckedHead() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_CheckedHead'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_CheckedHead', '����/����� �������� �������������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_CheckedHead');

CREATE OR REPLACE FUNCTION zc_MovementDate_CheckedPersonal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_CheckedPersonal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_CheckedPersonal', '����/����� �������� ����� ���������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_CheckedPersonal');

CREATE OR REPLACE FUNCTION zc_MovementDate_TimeClose() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_TimeClose'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_TimeClose', '����� ���� ��������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_TimeClose');

CREATE OR REPLACE FUNCTION zc_MovementDate_Conduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Conduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Conduct', '���� ���������� �� ����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Conduct');

CREATE OR REPLACE FUNCTION zc_MovementDate_GoodsReceipts() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_GoodsReceipts'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_GoodsReceipts', '���� ����������� ������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_GoodsReceipts');

CREATE OR REPLACE FUNCTION zc_MovementDate_AdoptedByNSZU() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_AdoptedByNSZU'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_AdoptedByNSZU', '������� ����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_AdoptedByNSZU');

CREATE OR REPLACE FUNCTION zc_MovementDate_CarInfo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_CarInfo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_CarInfo', '����/����� ��������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_CarInfo');

CREATE OR REPLACE FUNCTION zc_MovementDate_Coming() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Coming'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Coming', '���� �������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Coming');

CREATE OR REPLACE FUNCTION zc_MovementDate_Message() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Message'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Message', '���� ����� ���������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Message');

CREATE OR REPLACE FUNCTION zc_MovementDate_Order() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Order'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Order', '���� ������� � �����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Order');

CREATE OR REPLACE FUNCTION zc_MovementDate_SiteDateUpdate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_SiteDateUpdate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_SiteDateUpdate', '���� ��������� �� �����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_SiteDateUpdate');


CREATE OR REPLACE FUNCTION zc_MovementDate_SignConsignor() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_SignConsignor'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_SignConsignor', '���� ������� �����������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_SignConsignor');


CREATE OR REPLACE FUNCTION zc_MovementDate_SignCarrier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_SignCarrier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_SignCarrier', '���� ������� ����������������' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_SignCarrier');

CREATE OR REPLACE FUNCTION zc_MovementDate_OffsetVIP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OffsetVIP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_OffsetVIP', '���� ����� �����' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_OffsetVIP');

CREATE OR REPLACE FUNCTION zc_MovementDate_Pay_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Pay_1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Pay_1', '����� ������-1' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Pay_1');

CREATE OR REPLACE FUNCTION zc_MovementDate_Pay_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Pay_2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Pay_2', '����� ������-2' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Pay_2');

CREATE OR REPLACE FUNCTION zc_MovementDate_Return_1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Return_1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Return_1', '����� �������-1' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Return_1');

CREATE OR REPLACE FUNCTION zc_MovementDate_Return_2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Return_2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementDateDesc (Code, ItemName)
  SELECT 'zc_MovementDate_Return_2', '����� �������-2' WHERE NOT EXISTS (SELECT * FROM MovementDateDesc WHERE Code = 'zc_MovementDate_Return_2');




/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �. �.    ��������� �.�.   �������� �.�.   ������ �.�.
 23.09.24         * zc_MovementDate_Pay_1
                    zc_MovementDate_Pay_2  
                    zc_MovementDate_Return_1
                    zc_MovementDate_Return_2 
 02.07.23                                                                                                        * zc_MovementDate_OffsetVIP
 23.06.23                                                                                                        * zc_MovementDate_SignConsignor, zc_MovementDate_SignCarrier
 19.04.23         * zc_MovementDate_StatusInsert
 04.10.22                                                                                                        * zc_MovementDate_SiteDateUpdate
 09.08.22                                                                                                        * zc_MovementDate_Order
 30.06.22                                                                                                        * zc_MovementDate_Message
 15.06.22                                                                                                        * zc_MovementDate_Coming
 14.06.22         * zc_MovementDate_CarInfo
 13.04.22                                                                                                        * zc_MovementDate_AdoptedByNSZU
 16.12.21                                                                                                        * zc_MovementDate_GoodsReceipts
 05.11.21                                                                                                        * zc_MovementDate_Conduct
 10.08.21         * zc_MovementDate_TimeClose
 09.08.21         * zc_MovementDate_CheckedHead
                    zc_MovementDate_CheckedPersonal
 26.04.21         * zc_MovementDate_StartStop
                    zc_MovementDate_EndStop
                    zc_MovementDate_UserConfirmedKind
 15.04.21                                                                                                        * zc_MovementDate_Compensation
 19.03.21                                                                                                        * zc_MovementDate_Calculation
 26.05.20                                                                                                        * zc_MovementDate_Deferred
 07.08.19                                                                                                        * zc_MovementDate_Sent
 18.04.19                                                                                                        * zc_MovementDate_Delay
 11.03.19                                                                                                        * zc_MovementDate_DateEndPUSH
 12.10.18                                                                                                        * zc_MovementDate_UserConfirmedKind
 23.10.18         * zc_MovementDate_Union
 12.10.18                                                                                                        * zc_MovementDate_UserConfirmedKind
 11.10.18         * zc_MovementDate_Checked
 01.10.18                                                                                                        * zc_MovementDate_DatePayment
 28.05.18                                                                                                        * 
 25.07.17         * zc_MovementDate_Month
 08.06.17         * zc_MovementDate_Check
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
