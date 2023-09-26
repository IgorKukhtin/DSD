unit UnitConst;

interface

uses Winapi.Messages;

const
  cExceptionMsg        = '[%s] %s';

  cSQLInfoDB           = 'select datname, pg_encoding_to_char(encoding) AS Encodings, version() AS Version, EXISTS(SELECT 1 FROM pg_catalog.pg_namespace AS C WHERE C.nspname = ''_replica'') AS isCatalogReplica from pg_database where datname ILIKE ''%s''';


  // Создаем (обновляем) на мастере функцию загрузки HistoryCost
  cSQLpg_Master_LoadHistoryCost  = '\SQL_Master\gpInsertUpdate_Master_LoadHistoryCost.sql';
  // Создаем (обновляем) на мастере функцию загрузки перепроведенных документов
  cSQLpg_Master_LoadMovement  = '\SQL_Master\gpRewiring_Master_LoadMovement.sql';
  // Создаем (обновляем) на мастере функцию с пареметрами подключения к базе
  cSQLSP_Master_Connect  = '\SQL_Master\gpSelect_ReplicaConnectParams.sql';

  // Создаем (обновляем) на слейве таблицу RewiringProtocol
  cSQL_RewiringProtocol  = '\SQL_Slave\STRUCTURE\RewiringProtocol.sql';
  // Создаем (обновляем) на слейве таблицу Container_branch_Rewiring
  cSQL_Slave_Container_branch_Rewiring  = '\SQL_Slave\STRUCTURE\Container_branch_Rewiring.sql';
  // Создаем (обновляем) на слейве таблицу HistoryCost_Rewiring
  cSQL_Slave_HistoryCost_Rewiring  = '\SQL_Slave\STRUCTURE\HistoryCost_Rewiring.sql';
  // Создаем (обновляем) на слейве таблицу MovementItemContainer_Rewiring
  cSQL_Slave_MovementItemContainer_Rewiring  = '\SQL_Slave\STRUCTURE\MovementItemContainer_Rewiring.sql';
  // Создаем (обновляем) на слейве таблицу MovementProtocol_Rewiring
  cSQL_MovementProtocol_Rewiring  = '\SQL_Slave\STRUCTURE\MovementProtocol_Rewiring.sql';

  // Создаем (обновляем) на слейве функцию расчета HistoryCost
  cSQLpg_Slave_HistoryCost_Rewiring  = '\SQL_Slave\gpInsertUpdate_HistoryCost_Rewiring.sql';
  // Создаем (обновляем) на слейве функцию расчета HistoryCost на мастере
  cSQLpg_Slave_HistoryCost_Master  = '\SQL_Slave\gpInsertUpdate_HistoryCost_Master.sql';
  // Создаем (обновляем) на слейве функцию отправки и обновления HistoryCost
  cSQLpg_Slave_SendHistoryCost  = '\SQL_Slave\gpInsertUpdate_Slave_SendHistoryCost.sql';
  // Создаем (обновляем) на слейве функцию отправки документа
  cSQLpg_Slave_SendMovement  = '\SQL_Slave\gpRewiring_Slave_SendMovement.sql';
  // Создаем (обновляем) на слейве функцию что отправить надо
  cSQLpg_Slave_RewiringProtocol  = '\SQL_Slave\gpSelect_Slave_RewiringProtocol.sql';
  // Создаем (обновляем) на слейве функцию данных для перепроведения
  cSQLpg_Slave_RewiringParams  = '\SQL_Slave\gpSelect_Slave_RewiringParams.sql';
  // Создаем (обновляем) на слейве функцию перепроводки документа
  cSQLpg_Slave_MovementId  = '\SQL_Slave\gpRewiring_Slave_MovementId.sql';
  // Создаем (обновляем) на слейве функцию получения изменившихся свойств
  cSQLpg_Slave_MovementProperties  = '\SQL_Slave\gpSelect_Slave_MovementProperties.sql';
  // Создаем (обновляем) на слейве функцию для проверки HistoryCost
  cSQLSP_Slave_CheckingHistoryCost  = '\SQL_Slave\gpSelect_CheckingHistoryCost.sql';
  // Создаем (обновляем) на слейве функцию с пареметрами подключения к базе
  cSQLSP_Slave_Connect  = '\SQL_Slave\gpSelect_MasterConnectParams.sql';

  // Создаем (обновляем) на слейве функцию определения что под ролью для перепроведения
  cSQLzc_isUserRewiring  = '\SQL_Slave\zc_isUserRewiring.sql';

  // Создаем (обновляем) на слейве тригерную функцию notice_changed_data
  cSQLTR_Data  = '\SQL_Slave\_trg\notice_changed_data.sql';
  // Создаем (обновляем) на слейве тригерную функцию notice_changed_data_container
  cSQLTR_Data_container  = '\SQL_Slave\_trg\notice_changed_data_container.sql';
  // Создаем (обновляем) на слейве тригерную функцию notice_changed_data_movement
  cSQLTR_Data_movement  = '\SQL_Slave\_trg\notice_changed_data_movement.sql';
  // Создаем (обновляем) на слейве тригерную функцию notice_changed_data_movementitemcontainer
  cSQLTR_Data_movementitemcontainer  = '\SQL_Slave\_trg\notice_changed_data_movementitemcontainer.sql';

  // Создаем (обновляем) на слейве функцию lpInsertFind_Container
  cSQLlpInsertFind_Container  = '\SQL_Slave\_lp\lpInsertFind_Container.sql';
  // Создаем (обновляем) на слейве функцию lpInsertFind_Object_PartionGoods - Asset
  cSQLlpInsertFind_Object_PartionGoods_Asset  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - Asset.sql';
  // Создаем (обновляем) на слейве функцию lpInsertFind_Object_PartionGoods - InvNumber
  cSQLlpInsertFind_Object_PartionGoods_InvNumber  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - InvNumber.sql';
  // Создаем (обновляем) на слейве функцию lpInsertFind_Object_PartionGoods - OS
  cSQLlpInsertFind_Object_PartionGoods_OS  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - OS.sql';
  // Создаем (обновляем) на слейве функцию lpInsertFind_Object_PartionGoods - PartionDate
  cSQLlpInsertFind_Object_PartionGoods_PartionDate  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - PartionDate.sql';
  // Создаем (обновляем) на слейве функцию lpInsertFind_Object_PartionGoods - PartionDate - NEW
  cSQLlpInsertFind_Object_PartionGoods_PartionDate_NEW  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - PartionDate - NEW.sql';
  // Создаем (обновляем) на слейве функцию lpInsertFind_Object_PartionGoods - PartionString
  cSQLlpInsertFind_Object_PartionGoods_PartionString  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - PartionString.sql';
  // Создаем (обновляем) на слейве функцию lpInsertFind_Object_PartionGoods - PartionString_20202
  cSQLlpInsertFind_Object_PartionGoods_PartionString_20202  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionGoods - PartionString_20202.sql';
  // Создаем (обновляем) на слейве функцию lpInsertFind_Object_PartionMovement
  cSQLlpInsertFind_Object_PartionMovement  = '\SQL_Slave\_lp\lpInsertFind_Object_PartionMovement.sql';
  // Создаем (обновляем) на слейве функцию lpInsertUpdate_MovementItemContainer
  cSQLlpInsertUpdate_MovementItemContainer  = '\SQL_Slave\_lp\lpInsertUpdate_MovementItemContainer.sql';
  // Создаем (обновляем) на слейве функцию lpInsertUpdate_MovementItemContainer_byTable
  cSQLlpInsertUpdate_MovementItemContainer_byTable  = '\SQL_Slave\_lp\lpInsertUpdate_MovementItemContainer_byTable_PROJECT.sql';
  // Создаем (обновляем) на слейве функцию lpDelete_MovementItemContainer
  cSQLlpDelete_MovementItemContainer  = '\SQL_Slave\_lp\lpDelete_MovementItemContainer.sql';
  // Создаем (обновляем) на слейве функцию lpInsert_MovementProtocol
  cSQLlpInsert_MovementProtocol  = '\SQL_Slave\_lp\lpInsert_MovementProtocol.sql';
  // Cоздаем (обновляем) на слейве функцию Подсчитываем количество обновляемых функций
  cSQLSPCalcFunctionMaster = '\SQL_Slave\gpRewiring_Replication_CalcFunctionMaster.sql';
  // Cоздаем (обновляем) на слейве функцию Копирование функций
  cSQLSPReplication_Function = '\SQL_Slave\gpRewiring_Replication_Function.sql';

  // Получить дату закрытия периода
  cSQL_StartDate_Auto_PrimeCost  =
      'SELECT OD.ValueData AS StartDate ' +
      'FROM ObjectDate AS OD ' +
      'WHERE OD.ObjectId = zc_Enum_GlobalConst_StartDate_Auto_PrimeCost() ' +
      '                     AND OD.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()';
  // Получить сессию подьзователя
  cSQL_Session  =
      'SELECT Object_User.Id AS Session ' +
      'FROM Object AS Object_User ' +
      'WHERE Object_User.ValueData ILIKE ''%s'' ' +
      '  AND Object_User.isErased = FALSE ' +
      '  AND Object_User.DescId = zc_Object_User()';

  // Получить необходимость перерасчета цен
  cSQL_HistoryCost_Branch  =
      'SELECT StartDate, EndDate, BranchId, BranchCode, BranchName ' +
      'FROM gpSelect_HistoryCost_Branch (inStartDate:= ''%s'', inEndDate:= ''%s'', inSession:= ''%s'') ' +
      'UNION ALL ' +
      'SELECT ''%s''::TDateTime, ''%s''::TDateTime, 0::Integer, 0::Integer, Null::TVarChar ' +
      'ORDER BY 4, 1';

  // Получить параметры перепроведения
  cSQL_RewiringParams_Branch  =
      'SELECT GroupId, isSale, GroupName ' +
      'FROM _replica.gpSelect_Slave_RewiringParams (inSession:= ''%s'') ' +
      'ORDER BY 1';

  // Перерасчета цен на слейве
  cSQL_HistoryCost_Calc  =
      'SELECT RewiringUUId FROM _replica.gpInsertUpdate_HistoryCost_Rewiring (:inStartDate, :inEndDate, :inBranchId, :inItearationCount, :inDiffSumm, :inSession)';

  // Получение перечня документов
  cSQL_Rewiring_Calc  =
      'SELECT Q.* FROM gpComplete_Selectall_sybase (:inStartDate, :inEndDate, :inIsSale, :inIsBefoHistoryCost, :inGroupId) AS Q ' +
      '  LEFT JOIN _replica.RewiringProtocol ON RewiringProtocol.MovementId = Q.MovementId ' +
      '                                     AND RewiringProtocol.isErrorRewiring = FALSE ' +
      '                                     AND RewiringProtocol.isProcessed = False ' +
      'WHERE COALESCE(RewiringProtocol.MovementId, 0) = 0 ' +
      'ORDER BY MovementId';

  // Процедура перепроведения
  cSQL_Rewiring_MovementId  =
      'SELECT * FROM _replica.gpRewiring_Slave_MovementId (:inMovementId, :inIsNoHistoryCost, :inSession)';

  // Отправка HistoryCost на мастер и возврат на слейв
  cSQL_HistoryCost_Send  =
      'SELECT * FROM _replica.gpInsertUpdate_Slave_SendHistoryCost (:inRewiringUUId, :inStartDate, :inEndDate, :inBranchId, :inSession)';

  // Создание роли
  cSQLCreateUser       = 'CREATE USER "%s" WITH PASSWORD ''%s'';'#13#10 +
                         'GRANT "%s" TO postgres;'#13#10 +
                         'ALTER ROLE "%s" SUPERUSER CREATEDB;';

  // Отправка документа на мастер
  cSQL_Slave_SendMovement  =
      'SELECT * FROM _replica.gpRewiring_Slave_SendMovement (:inId, :inSession)';

  // Что отправить надо
  cSQL_Slave_RewiringProtocol  =
      'SELECT * FROM _replica.gpSelect_Slave_RewiringProtocol (:inSession)';

  // Подсчитываем количество обновляемых функций
  cSQLCalcFunctionMaster =
      'select * from _replica.gpRewiring_Replication_CalcFunctionMaster(:inSession);';

  // Копирование функций
  cSQLReplication_Function =
      'select * from _replica.gpRewiring_Replication_Function(:inOffset, :inRecordCount, :inSession);';

  // Отчет проверки HistoryCost
  cSQLSelect_CheckingHistoryCost =
      'select * from _replica.gpSelect_CheckingHistoryCost(:inMasterUUId, :inSlaveUUId, :inSession);';

const
  WM_THREAD_COUNTER = WM_USER + 1000;


implementation

end.
