unit UnitConst;

interface

uses Winapi.Messages;

const
  cExceptionMsg        = '[%s] %s';
  cTableLogStart       = 'Начало обработки таблицы - %s';
  cTableLogStartSize   = 'Начало обработки таблицы - %s; записей - %s';
  cTableLogFinishSize  = '   обработана таблицы - %s; загружено записей - %s';
  cTableLogFinish      = 'Обработано таблиц - %s; загружено записей - %s';
  cTableLogResult      = 'Обработка таблицы - %s завершена. Строк: %s';
  cTableProcessing     = 'Обработка таблицы - %s строк %s из %s';
  cFunctionResult      = 'Обновление функций завершена. Функций: %s';
  cFunctionProcessing  = 'Обновление функций - %s из %s';
  cIndexProcessing     = 'Создание индексов - %s из %s; Таблица %s';
  cIndexResult         = 'Создание индексов завершено. Обработано таблиц: %s индексов: %s';
  cEqualizatioProcessing = 'Уравнивание данных c Мастера';
  cEqualizationResult  = 'Уравнивание завершено. Обработано таблиц: %s записей: %s';

  cSQLCreatedblink     = 'CREATE EXTENSION IF NOT EXISTS dblink';
  cSQLInfoDB           = 'select datname, pg_encoding_to_char(encoding) AS Encodings, version() AS Version, EXISTS(SELECT 1 FROM pg_catalog.pg_namespace AS C WHERE C.nspname = ''_replica'') AS isCatalogReplica from pg_database where datname ILIKE ''%s''';
  cSQLCreateDB         = 'CREATE DATABASE "%s" WITH OWNER = "%s" ENCODING = ''%s'' TABLESPACE = pg_default';
  cSQLCreateUser       = 'CREATE USER "%s" WITH PASSWORD ''%s'';'#13#10 +
                         'GRANT "%s" TO postgres;'#13#10 +
                         'ALTER ROLE "%s" SUPERUSER CREATEDB;';
  cSQLSchema           = 'CREATE SCHEMA "_replica"';
  cSQLInfoDomains      = 'select domain_name from information_schema.domains AS ISD where ISD.domain_schema = ''public''';
  cSQLTableList        = 'select Table_Name from information_schema.tables AS ISD where ISD.table_schema = ''public''';
  cSQLProcCount        = 'select count(*) AS ProcCount from pg_proc AS ISD where ISD.proname ILIKE ''zc_movement_%''';
  cSQLNewTable         = 'select outIsError, outText from _replica.gpBranchService_Create_NewTable(''%s'', ''0'')';
  cSQLCalculateTableMaster = 'select * from _replica.gpBranchService_Replication_CalcTableMaster(''%s'', ''0'');';
  cSQLReplication_Table = 'select * from _replica.gpBranchService_Replication_Table(:inTableName, :inOffset, :inRecordCount, ''0'');';
  cSQLCalcFunctionMaster = 'select * from _replica.gpBranchService_Replication_CalcFunctionMaster(''%s'', ''0'');';
  cSQLReplication_Function = 'select * from _replica.gpBranchService_Replication_Function(:inFunctionFilter, :inOffset, :inRecordCount, ''0'');';
  cSQLReplication_View = 'select * from _replica.gpBranchService_Replication_View(''0'');';
  cSQLReplication_Sequence = 'select * from _replica.gpBranchService_Replication_Sequence(''0'');';
  cSQLReplication_Index = 'select * from _replica.gpBranchService_Replication_IndexProcessing(:inTableName, ''0'');';
  cSQLEqualizationTableMaster = 'select * from _replica.BranchService_Table_Equalization ORDER BY Id';
  cSQLEqualization_UpdateDataLog = 'select * from _replica.gpBranchService_Replication_UpdateDataLog(''0'');';
  cSQLSELECT_CLOCK_TIMESTAMP = 'SELECT timezone(CAST(''utc'' AS text), CLOCK_TIMESTAMP()) - CAST((CAST((' +
                               'SELECT BranchService_Settings.OffsetTimeEnd FROM _replica.BranchService_Settings ' +
                               'WHERE BranchService_Settings.Id = 1) AS TEXT)||'' MIN'') AS INTERVAL) AS CurrDate';

  cSQLEqualization_MasterStep = 'select * from _replica.gpBranchService_Equalization_MasterStep(''0'');';

  cSQLReserveAllId = 'select * from _replica.gpBranchService_ReserveAllId(''0'');';

  cSQLGetReplServer = 'SELECT * FROM _replica.gpSelect_Object_ReplServer (zfCalc_UserAdmin()) WHERE HOST = :HOST AND UserName = :UserName AND Password = :Password AND Port = :Port and DataBaseName = :DataBaseName';

  cSQLOpenBranchService_SettingsSmoll  = 'select BS.* from _replica.BranchService_Settings AS BS;';
  cSQLOpenBranchService_Settings  = 'select BS.*, Object.ObjectCode AS ReplServerCode, Object.ValueData AS ReplServerName ' +
                                   'from _replica.BranchService_Settings AS BS LEFT JOIN Object ON Object.ID = BS.ReplServerId;';
  cSQLInsertReplServer  = 'SELECT gpInsertUpdate_Object_ReplServer(0, 0, :inName, :inHost, :inUser, :inPassword, :inPort, :inDataBase, zfCalc_UserAdmin()) AS ID';
  cSQLCreateTriggerBanChanges  = 'DROP TRIGGER IF EXISTS Trigger_Ban_Changes_%s ON  public.%s;'#13#10 +
                                 'CREATE TRIGGER Trigger_Ban_Changes_%s ' +
                                 '  BEFORE INSERT OR UPDATE OR DELETE ' +
                                 '  ON public.%s ' +
                                 ' ' +
                                 'FOR EACH ROW ' +
                                 '  EXECUTE PROCEDURE _replica.gpBranchService_Ban_Changes_Trigger();';
  cSQLClear_DescId_Movement  = 'UPDATE _replica.BranchService_DescId_Movement SET isEqualization = False, isInsert = False';
  cSQLInsert_DescId_Movement_Equalization  = 'INSERT INTO _replica.BranchService_DescId_Movement (DescId, isEqualization) ' +
                                             'VALUES (%s, True) ON CONFLICT (DescId) DO UPDATE SET isEqualization = True';
  cSQLInsert_DescId_Movement_Insert  = 'INSERT INTO _replica.BranchService_DescId_Movement (DescId, isInsert) ' +
                                       'VALUES (%s, True) ON CONFLICT (DescId) DO UPDATE SET isInsert = True';

  cSQLDelete_Table_Equalization  = 'DELETE FROM _replica.BranchService_Table_Equalization';
  cSQLInsert_Table_Equalization  = 'INSERT INTO _replica.BranchService_Table_Equalization (Id, TableName) ' +
                                       'VALUES (%s, ''%s'')';

  cSQLCreateDomains    = '\SQL_Slave\Create_Domains.sql';
  cSQLBranchService_Settings = '\SQL_Slave\BranchService_Settings.sql';
  cSQLBranchService_Reserve_Movement = '\SQL_Slave\BranchService_Reserve_Movement.sql';
  cSQLBranchService_DescId_Movement = '\SQL_Slave\BranchService_DescId_Movement.sql';
  cSQLBranchService_Table_Equalization = '\SQL_Slave\BranchService_Table_Equalization.sql';

  // На мастере
  cSQLTable_Equalization_ObjectId = '\SQL_Master\BranchService_Equalization_Id.sql';
  cSQLEqualizationPrepareId = '\SQL_Master\gpBranchService_EqualizationPrepareId.sql';
  cSQLEqualizationForMovement = '\SQL_Master\BranchService_DescId_ForMovement.sql';

  cSQLDelete_DescId_ForMovement  = 'DELETE FROM _replica.BranchService_DescId_ForMovement';
  cSQLInsert_DescId_Movement_ForMovement  = 'DO $$ ' +
                                            'BEGIN ' +
                                            '  IF NOT EXISTS(SELECT * FROM _replica.BranchService_DescId_ForMovement AS DFM WHERE DFM.DescId = %s) ' +
                                            '  THEN ' +
                                            '    INSERT INTO _replica.BranchService_DescId_ForMovement (DescId) VALUES (%s); ' +
                                            '  END IF; ' +
                                            'END $$;';

  // На слейве
  cSQLpg_get_tabledef  = '\SQL_Master\pg_get_tabledef.sql';
  cSQLSPMasterConnect  = '\SQL_Slave\gpBranchService_Select_MasterConnectParams.sql';
  cSQLSPNewTable       = '\SQL_Slave\gpBranchService_Create_NewTable.sql';
  cSQLSPCalculateTableMaster = '\SQL_Slave\gpBranchService_Replication_CalcTableMaster.sql';
  cSQLSPReplication_Table = '\SQL_Slave\gpBranchService_Replication_Table.sql';
  cSQLSPReplication_Table_IdList = '\SQL_Slave\gpBranchService_Replication_Table_IdList.sql';
  cSQLSPReplication_Table_Movement = '\SQL_Slave\gpBranchService_Replication_Table_Movement.sql';
  cSQLSPReplication_Table_Simple = '\SQL_Slave\gpBranchService_Replication_Table_Simple.sql';
  cSQLSPCalcFunctionMaster = '\SQL_Slave\gpBranchService_Replication_CalcFunctionMaster.sql';
  cSQLSPReplication_Function = '\SQL_Slave\gpBranchService_Replication_Function.sql';
  cSQLSPCalcViewMaster = '\SQL_Slave\gpBranchService_Replication_CalcViewMaster.sql';
  cSQLSPReplication_View = '\SQL_Slave\gpBranchService_Replication_View.sql';
  cSQLSPReplication_Sequence = '\SQL_Slave\gpBranchService_Replication_Sequence.sql';
  cSQLSPReplication_Index = '\SQL_Slave\gpBranchService_Replication_IndexProcessing.sql';
  cSQLSPReplication_UpdateDataLog = '\SQL_Slave\gpBranchService_Replication_UpdateDataLog.sql';

  cSQLSPEqualization_MasterStep = '\SQL_Slave\gpBranchService_Equalization_MasterStep.sql';
  cSQLSPEqualization_UpdateTableData = '\SQL_Slave\gpBranchService_Equalization_UpdateTableData.sql';

  cSQLSPBan_Changes_Trigger = '\SQL_Slave\gpBranchService_Ban_Changes_Trigger.sql';

  cSQLSPGet_MovementId = '\SQL_Slave\lpBranchService_Get_MovementId.sql';
  cSQLSPGet_MovementItemId = '\SQL_Slave\lpBranchService_Get_MovementItemId.sql';
  cSQLSReserveAllId = '\SQL_Slave\gpBranchService_ReserveAllId.sql';

  cSQLUpdateDateSnapshot = 'UPDATE _replica.BranchService_Settings SET DateSnapshot = :Date;';
  cSQLUpdateDateEqualization = 'UPDATE _replica.BranchService_Settings SET DateEqualization = :Date, EqualizationLastId = 0;';
  cSQLUpdateDateSendDocument = 'UPDATE _replica.BranchService_Settings SET DateSendDocument = :Date, SendLastId = 0;';
  cSQLUpdateReplServer  = 'UPDATE _replica.BranchService_Settings SET ReplServerId = :ReplServerId;';
  cSQLUpdateRecordStep  = 'UPDATE _replica.BranchService_Settings SET RecordStep = :RecordStep;';
  cSQLUpdateOffsetTimeEnd  = 'UPDATE _replica.BranchService_Settings SET OffsetTimeEnd = :OffsetTimeEnd;';

  cTableListAll             = '\List\TableListAll.txt';
  cTableEqualizationList    = '\List\EqualizationList.txt';
  cMovementEqualizationDesc = '\List\EqualizationMovementDesc.txt';
  cMovementInsertDesc       = '\List\InsertMovementDesc.txt';
  cReplicationList          = '\List\ReplicationList.txt';
  cFunctionFilter           = '\List\FunctionFilter.txt';

const
  WM_THREAD_COUNTER = WM_USER + 1000;


implementation

end.
