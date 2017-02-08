-- Function: lpInsertUpdate_MIReport_byTable ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MIReport_byTable ();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MIReport_byTable(
)
  RETURNS void AS
$BODY$
BEGIN
     -- !!!�����, �.�. ������ �� �����!!!
     RETURN;


     -- ��������
     IF EXISTS (SELECT Amount FROM _tmpMIReport_insert WHERE Amount < 0)
     THEN
         RAISE EXCEPTION '���������� ������������ �������� ��� ������ � Amount<0';
     END IF;

     -- ��������
     IF EXISTS (SELECT ActiveAccountId FROM _tmpMIReport_insert WHERE ActiveAccountId = zc_Enum_Account_100301() AND PassiveAccountId = zc_Enum_Account_100301())
     THEN
         RAISE EXCEPTION '���������� ������������ �������� ��� ������ � ���������� ������ ����';
     END IF;

     -- ��������� "�������� ��� ������"
     INSERT INTO MovementItemReport (MovementDescId, MovementId, MovementItemId, ActiveContainerId, PassiveContainerId, ActiveAccountId, PassiveAccountId, ReportContainerId, ChildReportContainerId, Amount, OperDate)
        SELECT MovementDescId, MovementId, MovementItemId, ActiveContainerId, PassiveContainerId, ActiveAccountId, PassiveAccountId, ReportContainerId, ChildReportContainerId/*CASE WHEN ChildReportContainerId = 0 THEN NULL ELSE ChildReportContainerId END*/, COALESCE (Amount, 0), OperDate FROM _tmpMIReport_insert;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MIReport_byTable () OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.08.14                                        *
*/

-- ����
-- CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;
-- SELECT * FROM lpInsertUpdate_MIReport_byTable (inMovementId  := 1, inMovementItemId := 2, )
