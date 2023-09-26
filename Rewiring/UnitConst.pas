unit UnitConst;

interface

uses Winapi.Messages;

const
  cExceptionMsg        = '[%s] %s';

  cSQLInfoDB           = 'select datname, pg_encoding_to_char(encoding) AS Encodings, version() AS Version, EXISTS(SELECT 1 FROM pg_catalog.pg_namespace AS C WHERE C.nspname = ''_replica'') AS isCatalogReplica from pg_database where datname ILIKE ''%s''';


  // ������� (���������) �� ������� ������� �������� HistoryCost
  cSQLpg_Master_LoadHistoryCost  = '\SQL_Master\gpInsertUpdate_Master_LoadHistoryCost.sql';
  // ������� (���������) �� ������� ������� �������� ��������������� ����������
  cSQLpg_Master_LoadMovement  = '\SQL_Master\gpRewiring_Master_LoadMovement.sql';
  // ������� (���������) �� ������� ������� � ����������� ����������� � ����
  cSQLSP_Master_Connect  = '\SQL_Master\gpSelect_ReplicaConnectParams.sql';

  // ������� (���������) �� ������ ������� RewiringProtocol
  cSQL_RewiringProtocol  = '\SQL_Slave\STRUCTURE\RewiringProtocol.sql';
  // ������� (���������) �� ������ ������� Container_branch_Rewiring
  cSQL_Slave_Container_branch_Rewiring  = '\SQL_Slave\STRUCTURE\Container_branch_Rewiring.sql';
  // ������� (���������) �� ������ ������� HistoryCost_Rewiring
  cSQL_Slave_HistoryCost_Rewiring  = '\SQL_Slave\STRUCTURE\HistoryCost_Rewiring.sql';
  // ������� (���������) �� ������ ������� MovementItemContainer_Rewiring
  cSQL_Slave_MovementItemContainer_Rewiring  = '\SQL_Slave\STRUCTURE\MovementItemContainer_Rewiring.sql';
  // ������� (���������) �� ������ ������� MovementProtocol_Rewiring
  cSQL_MovementProtocol_Rewiring  = '\SQL_Slave\STRUCTURE\MovementProtocol_Rewiring.sql';

  // ������� (���������) �� ������ ������� ������� HistoryCost
  cSQLpg_Slave_HistoryCost_Rewiring  = '\SQL_Slave\gpInsertUpdate_HistoryCost_Rewiring.sql';
  // ������� (���������) �� ������ ������� ������� HistoryCost �� �������
  cSQLpg_Slave_HistoryCost_Master  = '\SQL_Slave\gpInsertUpdate_HistoryCost_Master.sql';
  // ������� (���������) �� ������ ������� �������� � ���������� HistoryCost
  cSQLpg_Slave_SendHistoryCost  = '\SQL_Slave\gpInsertUpdate_Slave_SendHistoryCost.sql';
  // ������� (���������) �� ������ ������� �������� ���������
  cSQLpg_Slave_SendMovement  = '\SQL_Slave\gpRewiring_Slave_SendMovement.sql';
  // ������� (���������) �� ������ ������� ��� ��������� ����
  cSQLpg_Slave_RewiringProtocol  = '\SQL_Slave\gpSelect_Slave_RewiringProtocol.sql';
  // ������� (���������) �� ������ ������� ������ ��� ��������������
  cSQLpg_Slave_RewiringParams  = '\SQL_Slave\gpSelect_Slave_RewiringParams.sql';
  // ������� (���������) �� ������ ������� ������������ ���������
  cSQLpg_Slave_MovementId  = '\SQL_Slave\gpRewiring_Slave_MovementId.sql';
  // ������� (���������) �� ������ ������� ��������� ������������ �������
  cSQLpg_Slave_MovementProperties  = '\SQL_Slave\gpSelect_Slave_MovementProperties.sql';
  // ������� (���������) �� ������ ������� ��� �������� HistoryCost
  cSQLSP_Slave_CheckingHistoryCost  = '\SQL_Slave\gpSelect_CheckingHistoryCost.sql';
  // ������� (���������) �� ������ ������� � ����������� ����������� � ����
  cSQLSP_Slave_Connect  = '\SQL_Slave\gpSelect_MasterConnectParams.sql';

  // ������� (���������) �� ������ ������� ����������� ��� ��� ����� ��� ��������������
  cSQLzc_isUserRewiring  = '\SQL_Slave\zc_isUserRewiring.sql';

  // ������� (���������) �� ������ ��������� ������� notice_changed_data
  cSQLTR_Data  = '\SQL_Slave\_trg\notice_changed_data.sql';
  // ������� (���������) �� ������ ��������� ������� notice_changed_data_container
  cSQLTR_Data_container  = '\SQL_Slave\_trg\notice_changed_data_container.sql';
  // ������� (���������) �� ������ ��������� ������� notice_changed_data_movement
  cSQLTR_Data_movement  = '\SQL_Slave\_trg\notice_changed_data_movement.sql';
  // ������� (���������) �� ������ ��������� ������� notice_changed_data_movementitemcontainer
  cSQLTR_Data_movementitemcontainer  = '\SQL_Slave\_trg\notice_changed_data_movementitemcontainer.sql';

  // ������� (���������) �� ������ ������� lpInsertFind_Container
  cSQLlpInsertFind_Container  = '\SQL_Slave\_lp\lpInsertFind_Container.sql';
  // ������� (���������) �� ������ ������� lpInsertFind_Object_PartionGoods - Asset
  cSQLlpInsertFind_Object_PartionGoods_Asset  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - Asset.sql';
  // ������� (���������) �� ������ ������� lpInsertFind_Object_PartionGoods - InvNumber
  cSQLlpInsertFind_Object_PartionGoods_InvNumber  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - InvNumber.sql';
  // ������� (���������) �� ������ ������� lpInsertFind_Object_PartionGoods - OS
  cSQLlpInsertFind_Object_PartionGoods_OS  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - OS.sql';
  // ������� (���������) �� ������ ������� lpInsertFind_Object_PartionGoods - PartionDate
  cSQLlpInsertFind_Object_PartionGoods_PartionDate  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - PartionDate.sql';
  // ������� (���������) �� ������ ������� lpInsertFind_Object_PartionGoods - PartionDate - NEW
  cSQLlpInsertFind_Object_PartionGoods_PartionDate_NEW  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - PartionDate - NEW.sql';
  // ������� (���������) �� ������ ������� lpInsertFind_Object_PartionGoods - PartionString
  cSQLlpInsertFind_Object_PartionGoods_PartionString  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - PartionString.sql';
  // ������� (���������) �� ������ ������� lpInsertFind_Object_PartionGoods - PartionString_20202
  cSQLlpInsertFind_Object_PartionGoods_PartionString_20202  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - PartionString_20202.sql';
  // ������� (���������) �� ������ ������� lpInsertFind_Object_PartionMovement
  cSQLlpInsertFind_Object_PartionMovement  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionMovement.sql';
  // ������� (���������) �� ������ ������� lpInsertUpdate_MovementItemContainer
  cSQLlpInsertUpdate_MovementItemContainer  = '\SQL_Slave\_lp\lpInsertUpdate_MovementItemContainer.sql';
  // ������� (���������) �� ������ ������� lpInsertUpdate_MovementItemContainer_byTable
  cSQLlpInsertUpdate_MovementItemContainer_byTable  = '\SQL_Slave\_lp\lpInsertUpdate_MovementItemContainer_byTable_PROJECT.sql';
  // ������� (���������) �� ������ ������� lpDelete_MovementItemContainer
  cSQLlpDelete_MovementItemContainer  = '\SQL_Slave\_lp\lpDelete_MovementItemContainer.sql';
  // ������� (���������) �� ������ ������� lpInsert_MovementProtocol
  cSQLlpInsert_MovementProtocol  = '\SQL_Slave\_lp\lpInsert_MovementProtocol.sql';
  // C������ (���������) �� ������ ������� ������������ ���������� ����������� �������
  cSQLSPCalcFunctionMaster = '\SQL_Slave\gpRewiring_Replication_CalcFunctionMaster.sql';
  // C������ (���������) �� ������ ������� ����������� �������
  cSQLSPReplication_Function = '\SQL_Slave\gpRewiring_Replication_Function.sql';

  // �������� ���� �������� �������
  cSQL_StartDate_Auto_PrimeCost  =
      'SELECT OD.ValueData AS StartDate ' +
      'FROM ObjectDate AS OD ' +
      'WHERE OD.ObjectId = zc_Enum_GlobalConst_StartDate_Auto_PrimeCost() ' +
      '                     AND OD.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()';
  // �������� ������ ������������
  cSQL_Session  =
      'SELECT Object_User.Id AS Session ' +
      'FROM Object AS Object_User ' +
      'WHERE Object_User.ValueData ILIKE ''%s'' ' +
      '  AND Object_User.isErased = FALSE ' +
      '  AND Object_User.DescId = zc_Object_User()';

  // �������� ������������� ����������� ���
  cSQL_HistoryCost_Branch  =
      'SELECT StartDate, EndDate, BranchId, BranchCode, BranchName ' +
      'FROM gpSelect_HistoryCost_Branch (inStartDate:= ''%s'', inEndDate:= ''%s'', inSession:= ''%s'') ' +
      'UNION ALL ' +
      'SELECT ''%s''::TDateTime, ''%s''::TDateTime, 0::Integer, 0::Integer, Null::TVarChar ' +
      'ORDER BY 4, 1';

  // �������� ��������� ��������������
  cSQL_RewiringParams_Branch  =
      'SELECT GroupId, isSale, GroupName ' +
      'FROM _replica.gpSelect_Slave_RewiringParams (inSession:= ''%s'') ' +
      'ORDER BY 1';

  // ����������� ��� �� ������
  cSQL_HistoryCost_Calc  =
      'SELECT RewiringUUId FROM _replica.gpInsertUpdate_HistoryCost_Rewiring (:inStartDate, :inEndDate, :inBranchId, :inItearationCount, :inDiffSumm, :inSession)';

  // ��������� ������� ����������
  cSQL_Rewiring_Calc  =
      'SELECT Q.* FROM gpComplete_Selectall_sybase (:inStartDate, :inEndDate, :inIsSale, :inIsBefoHistoryCost, :inGroupId) AS Q ' +
      '  LEFT JOIN _replica.RewiringProtocol ON RewiringProtocol.MovementId = Q.MovementId ' +
      '                                     AND RewiringProtocol.isErrorRewiring = FALSE ' +
      '                                     AND RewiringProtocol.isProcessed = False ' +
      'WHERE COALESCE(RewiringProtocol.MovementId, 0) = 0 ' +
      'ORDER BY MovementId';

  // ��������� ��������������
  cSQL_Rewiring_MovementId  =
      'SELECT * FROM _replica.gpRewiring_Slave_MovementId (:inMovementId, :inIsNoHistoryCost, :inSession)';

  // �������� HistoryCost �� ������ � ������� �� �����
  cSQL_HistoryCost_Send  =
      'SELECT * FROM _replica.gpInsertUpdate_Slave_SendHistoryCost (:inRewiringUUId, :inStartDate, :inEndDate, :inBranchId, :inSession)';

  // �������� ����
  cSQLCreateUser       = 'CREATE USER "%s" WITH PASSWORD ''%s'';'#13#10 +
                         'GRANT "%s" TO postgres;'#13#10 +
                         'ALTER ROLE "%s" SUPERUSER CREATEDB;';

  // �������� ��������� �� ������
  cSQL_Slave_SendMovement  =
      'SELECT * FROM _replica.gpRewiring_Slave_SendMovement (:inId, :inSession)';

  // ��� ��������� ����
  cSQL_Slave_RewiringProtocol  =
      'SELECT * FROM _replica.gpSelect_Slave_RewiringProtocol (:inSession)';

  // ������������ ���������� ����������� �������
  cSQLCalcFunctionMaster =
      'select * from _replica.gpRewiring_Replication_CalcFunctionMaster(:inSession);';

  // ����������� �������
  cSQLReplication_Function =
      'select * from _replica.gpRewiring_Replication_Function(:inOffset, :inRecordCount, :inSession);';

  // ����� �������� HistoryCost
  cSQLSelect_CheckingHistoryCost =
      'select * from _replica.gpSelect_CheckingHistoryCost(:inMasterUUId, :inSlaveUUId, :inSession);';

const
  WM_THREAD_COUNTER = WM_USER + 1000;


implementation

end.
