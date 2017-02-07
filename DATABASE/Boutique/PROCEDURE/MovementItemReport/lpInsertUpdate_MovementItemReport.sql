-- Function: lpInsertUpdate_MovementItemReport(Integer, Integer, Integer, TFloat, TDateTime)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemReport (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemReport(
    IN inMovementDescId          Integer               ,
    IN inMovementId              Integer               , -- ���� ���������
    IN inMovementItemId          Integer               ,
    IN inActiveContainerId       Integer               ,
    IN inPassiveContainerId      Integer               ,
    IN inActiveAccountId         Integer               ,
    IN inPassiveAccountId        Integer               ,
    IN inReportContainerId       Integer               ,
    IN inChildReportContainerId  Integer               ,
    IN inAmount                  TFloat                ,
    IN inOperDate                TDateTime
)
  RETURNS void AS
$BODY$
BEGIN
     -- !!!�����, �.�. ������ �� �����!!!
     RETURN;


     -- ������ ��������
     IF inChildReportContainerId = 0 THEN inChildReportContainerId := NULL; END IF;
     -- ������ ��������
     inAmount := COALESCE (inAmount, 0);

     -- ��������
     IF inAmount < 0 
     THEN
         RAISE EXCEPTION '���������� ������������ �������� ��� ������ � inAmount<0 : "%", "%", "%", "%", "%", "%", "%", "%", "%", "%"', inMovementId, inMovementItemId, inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId, inReportContainerId, inChildReportContainerId, inAmount, inOperDate;
     END IF;

     -- ��������
     IF inActiveAccountId = zc_Enum_Account_100301() AND inPassiveAccountId = zc_Enum_Account_100301()
     THEN
         RAISE EXCEPTION '���������� ������������ �������� ��� ������ � ���������� ������ ���� : "%", "%", "%", "%", "%", "%", "%", "%", "%", "%"', inMovementId, inMovementItemId, inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId, inReportContainerId, inChildReportContainerId, inAmount, inOperDate;
     END IF;

     -- ��������� "�������� ��� ������"
     INSERT INTO MovementItemReport (MovementDescId, MovementId, MovementItemId, ActiveContainerId, PassiveContainerId, ActiveAccountId, PassiveAccountId, ReportContainerId, ChildReportContainerId, Amount, OperDate)
                             VALUES (inMovementDescId, inMovementId, inMovementItemId, inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId, inReportContainerId, inChildReportContainerId, inAmount, inOperDate);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemReport (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.08.14                                        * add inMovementDescId
 03.11.13                                        * add zc_Enum_Account_100301
 29.08.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItemReport (inMovementId  := 1, inMovementItemId := 2, )
