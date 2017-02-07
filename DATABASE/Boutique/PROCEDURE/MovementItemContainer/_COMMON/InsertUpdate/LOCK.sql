-- Function: lpInsertFind_Container 

DROP FUNCTION IF EXISTS lpInsertFind_Container (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Container(
    IN inContainerDescId         Integer  , -- DescId Остатка
    IN inParentId                Integer  , -- Главный Container
    IN inObjectId                Integer  , -- Объект (Счет или Товар или ...)
    IN inJuridicalId_basis       Integer  , -- Главное юридическое лицо
    IN inBusinessId              Integer  , -- Бизнесы
    IN inObjectCostDescId        Integer  , -- DescId для <элемент с/с>
    IN inObjectCostId            Integer  , -- <элемент с/с> - необычная аналитика счета 
    IN inDescId_1                Integer  DEFAULT NULL , -- DescId для 1-ой Аналитики
    IN inObjectId_1              Integer  DEFAULT NULL , -- ObjectId для 1-ой Аналитики
    IN inDescId_2                Integer  DEFAULT NULL , -- DescId для 2-ой Аналитики
    IN inObjectId_2              Integer  DEFAULT NULL , -- ObjectId для 2-ой Аналитики
    IN inDescId_3                Integer  DEFAULT NULL , -- DescId для 3-ей Аналитики
    IN inObjectId_3              Integer  DEFAULT NULL , -- ObjectId для 3-ей Аналитики
    IN inDescId_4                Integer  DEFAULT NULL , -- DescId для 4-ой Аналитики
    IN inObjectId_4              Integer  DEFAULT NULL , -- ObjectId для 4-ой Аналитики
    IN inDescId_5                Integer  DEFAULT NULL , -- DescId для 5-ой Аналитики
    IN inObjectId_5              Integer  DEFAULT NULL , -- ObjectId для 5-ой Аналитики
    IN inDescId_6                Integer  DEFAULT NULL , -- DescId для 6-ой Аналитики
    IN inObjectId_6              Integer  DEFAULT NULL , -- ObjectId для 6-ой Аналитики
    IN inDescId_7                Integer  DEFAULT NULL , -- DescId для 7-ой Аналитики
    IN inObjectId_7              Integer  DEFAULT NULL , -- ObjectId для 7-ой Аналитики
    IN inDescId_8                Integer  DEFAULT NULL , -- DescId для 8-ой Аналитики
    IN inObjectId_8              Integer  DEFAULT NULL , -- ObjectId для 8-ой Аналитики
    IN inDescId_9                Integer  DEFAULT NULL , -- DescId для 9-ой Аналитики
    IN inObjectId_9              Integer  DEFAULT NULL , -- ObjectId для 9-ой Аналитики
    IN inDescId_10               Integer  DEFAULT NULL , -- DescId для 10-ой Аналитики
    IN inObjectId_10             Integer  DEFAULT NULL   -- ObjectId для 10-ой Аналитики
)
RETURNS Integer AS
$BODY$
   DECLARE vbContainerId Integer;
   DECLARE vbRecordCount Integer;
   DECLARE vbIs_tmp1 Boolean;

   DECLARE vbKeyValue TVarChar;
   DECLARE vbMasterKeyValue BigInt;
   DECLARE vbChildKeyValue BigInt;
BEGIN
     --
     -- !!!добавляется аналитика юр лицам (долги)!!!
     IF EXISTS (SELECT 1
                FROM (SELECT inDescId_1 AS DescId UNION SELECT inDescId_2 AS DescId UNION SELECT inDescId_3 AS DescId UNION SELECT inDescId_4 AS DescId) AS tmpDescIn
                      INNER JOIN (SELECT zc_ContainerLinkObject_Juridical() AS DescId UNION SELECT zc_ContainerLinkObject_Contract() AS DescId UNION SELECT zc_ContainerLinkObject_InfoMoney() AS DescId UNION SELECT zc_ContainerLinkObject_PaidKind() AS DescId
                                 ) AS tmpDesc ON tmpDesc.DescId = tmpDescIn.DescId
                HAVING COUNT (*) = 4)
        AND COALESCE (inDescId_5, 0) <> zc_ContainerLinkObject_PartionMovement()
        AND COALESCE (inDescId_6, 0) <> zc_ContainerLinkObject_PartionMovement()
        AND COALESCE (inDescId_7, 0) <> zc_ContainerLinkObject_PartionMovement()
        AND COALESCE (inDescId_8, 0) <> zc_ContainerLinkObject_PartionMovement()
        AND COALESCE (inDescId_9, 0) <> zc_ContainerLinkObject_PartionMovement()
        AND COALESCE (inDescId_10, 0) <> zc_ContainerLinkObject_PartionMovement()
     THEN
         IF COALESCE (inDescId_5, 0) = 0 THEN inDescId_5:= zc_ContainerLinkObject_PartionMovement(); END IF;
         IF COALESCE (inDescId_6, 0) = 0 THEN inDescId_6:= zc_ContainerLinkObject_PartionMovement(); END IF;
         IF COALESCE (inDescId_7, 0) = 0 THEN inDescId_7:= zc_ContainerLinkObject_PartionMovement(); END IF;
         IF COALESCE (inDescId_8, 0) = 0 THEN inDescId_8:= zc_ContainerLinkObject_PartionMovement(); END IF;
         IF COALESCE (inDescId_9, 0) = 0 THEN inDescId_9:= zc_ContainerLinkObject_PartionMovement(); END IF;
         IF COALESCE (inDescId_10, 0) = 0 THEN inDescId_10:= zc_ContainerLinkObject_PartionMovement(); END IF;
     END IF;


     --
     --
     inContainerDescId   := COALESCE (inContainerDescId, 0);
     inObjectId          := COALESCE (inObjectId, 0);
     inJuridicalId_basis := COALESCE (inJuridicalId_basis, 0);
     inBusinessId        := COALESCE (inBusinessId, 0);
     inObjectCostDescId  := COALESCE (inObjectCostDescId, 0);
     inObjectCostId      := COALESCE (inObjectCostId, 0);
     inObjectId_1        := COALESCE (inObjectId_1, 0);
     inObjectId_2        := COALESCE (inObjectId_2, 0);
     inObjectId_3        := COALESCE (inObjectId_3, 0);
     inObjectId_4        := COALESCE (inObjectId_4, 0);
     inObjectId_5        := COALESCE (inObjectId_5, 0);
     inObjectId_6        := COALESCE (inObjectId_6, 0);
     inObjectId_7        := COALESCE (inObjectId_7, 0);
     inObjectId_8        := COALESCE (inObjectId_8, 0);
     inObjectId_9        := COALESCE (inObjectId_9, 0);
     inObjectId_10       := COALESCE (inObjectId_10, 0);

     -- !!!
     -- !!!пока не понятно с проводками по Бизнесу, кроме счета Прибыль, поэтому учитывать по этой аналитике не будем, т.е. обнуляем значение!!!
     IF inObjectId <> zc_Enum_Account_100301() -- 100301; "прибыль текущего периода"
     THEN
         inBusinessId:=0;
     END IF;
     -- !!!
     -- !!!


     -- !!!определяется КЛЮЧ!!!
     vbKeyValue = (SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                         FROM     (SELECT COALESCE (inContainerDescId, 0)         AS Value, 0 AS myOrder1, -1 AS myOrder2
                         UNION ALL SELECT COALESCE (inParentId, 0)                AS Value, 0 AS myOrder1, -2 AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId, 0)                AS Value, 0 AS myOrder1, -3 AS myOrder2

                         UNION ALL SELECT zc_ContainerLinkObject_JuridicalBasis() AS Value, 0 AS myOrder1, zc_ContainerLinkObject_JuridicalBasis() AS myOrder2
                         UNION ALL SELECT COALESCE (inJuridicalId_basis, 0)       AS Value, 1 AS myOrder1, zc_ContainerLinkObject_JuridicalBasis() AS myOrder2
                         UNION ALL SELECT zc_ContainerLinkObject_Business()       AS Value, 0 AS myOrder1, zc_ContainerLinkObject_Business() AS myOrder2
                         UNION ALL SELECT COALESCE (inBusinessId, 0)              AS Value, 1 AS myOrder1, zc_ContainerLinkObject_Business() AS myOrder2

                         UNION ALL SELECT COALESCE (inDescId_1, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_1, 1000000001)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_1, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_1, 1000000001)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_2, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_2, 1000000002)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_2, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_2, 1000000002)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_3, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_3, 1000000003)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_3, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_3, 1000000003)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_4, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_4, 1000000004)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_4, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_4, 1000000004)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_5, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_5, 1000000005)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_5, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_5, 1000000005)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_6, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_6, 1000000006)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_6, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_6, 1000000006)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_7, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_7, 1000000007)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_7, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_7, 1000000007)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_8, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_8, 1000000008)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_8, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_8, 1000000008)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_9, 0)    AS Value, 0 AS myOrder1, COALESCE (inDescId_9, 1000000009)  AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_9, 0)  AS Value, 1 AS myOrder1, COALESCE (inDescId_9, 1000000009)  AS myOrder2
                         UNION ALL SELECT COALESCE (inDescId_10, 0)   AS Value, 0 AS myOrder1, COALESCE (inDescId_10, 1000000010) AS myOrder2
                         UNION ALL SELECT COALESCE (inObjectId_10, 0) AS Value, 1 AS myOrder1, COALESCE (inDescId_10, 1000000010) AS myOrder2
                                  ) AS tmp
                         ORDER BY tmp.myOrder2, tmp.myOrder1
                        ) AS tmp
                  );
     -- !!!определяется еще первый КЛЮЧ!!!
     vbMasterKeyValue:= zfCalc_FromHex (SUBSTRING (md5 (vbKeyValue) FROM 1 FOR 8));
     -- !!!определяется еще второй КЛЮЧ!!!
     vbChildKeyValue:= zfCalc_FromHex (SUBSTRING (md5 (vbKeyValue) FROM 9 FOR 8));


     BEGIN
     -- !!!находим СРАЗУ по ключу!!!
     -- vbContainerId := (SELECT Id FROM Container WHERE KeyValue = vbKeyValue);

     -- !!!находим СРАЗУ по ДВУМ ключам!!!
     vbContainerId := (SELECT Id FROM Container WHERE MasterKeyValue = vbMasterKeyValue AND ChildKeyValue = vbChildKeyValue AND Id <> 7505);
     EXCEPTION
              WHEN invalid_row_count_in_limit_clause
              THEN RAISE EXCEPTION 'Счет не уникален : vbContainerId = "%", inContainerDescId = "%", inParentId = "%", inObjectId = "%", inJuridicalId_basis = "%", inBusinessId = "%", inObjectCostDescId = "%", inObjectCostId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', vbContainerId, inContainerDescId, inParentId, inObjectId, inJuridicalId_basis, inBusinessId, inObjectCostDescId, inObjectCostId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
     END;
          

     -- Если не нашли, добавляем
     IF COALESCE (vbContainerId, 0) = 0
     THEN
         IF zc_IsLockTable() = TRUE
         THEN
         -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
         LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
         END IF;

         -- добавили Остаток
         INSERT INTO Container (DescId, ObjectId, ParentId, Amount, KeyValue, MasterKeyValue, ChildKeyValue)
                        VALUES (inContainerDescId, inObjectId, CASE WHEN inParentId = 0 THEN NULL ELSE inParentId END, 0, vbKeyValue, vbMasterKeyValue, vbChildKeyValue)
            RETURNING Id INTO vbContainerId;

         -- добавили Аналитики
         INSERT INTO ContainerLinkObject (DescId, ContainerId, ObjectId)
            SELECT zc_ContainerLinkObject_JuridicalBasis(), vbContainerId, inJuridicalId_basis WHERE inContainerDescId IN (zc_Container_Summ(), zc_Container_SummCurrency())
           UNION ALL
            SELECT zc_ContainerLinkObject_Business(), vbContainerId, inBusinessId WHERE inContainerDescId IN (zc_Container_Summ(), zc_Container_SummCurrency())
           UNION ALL
            SELECT inDescId_1, vbContainerId, inObjectId_1 WHERE inDescId_1 <> 0
           UNION ALL
            SELECT inDescId_2, vbContainerId, inObjectId_2 WHERE inDescId_2 <> 0
           UNION ALL
            SELECT inDescId_3, vbContainerId, inObjectId_3 WHERE inDescId_3 <> 0
           UNION ALL
            SELECT inDescId_4, vbContainerId, inObjectId_4 WHERE inDescId_4 <> 0
           UNION ALL
            SELECT inDescId_5, vbContainerId, inObjectId_5 WHERE inDescId_5 <> 0
           UNION ALL
            SELECT inDescId_6, vbContainerId, inObjectId_6 WHERE inDescId_6 <> 0
           UNION ALL
            SELECT inDescId_7, vbContainerId, inObjectId_7 WHERE inDescId_7 <> 0
           UNION ALL
            SELECT inDescId_8, vbContainerId, inObjectId_8 WHERE inDescId_8 <> 0
           UNION ALL
            SELECT inDescId_9, vbContainerId, inObjectId_9 WHERE inDescId_9 <> 0
           UNION ALL
            SELECT inDescId_10, vbContainerId, inObjectId_10 WHERE inDescId_10 <> 0;
     ELSE
         IF zc_IsLockTable() = TRUE
         THEN
         -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
         LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;

         ELSE
             PERFORM Container.* FROM Container WHERE Container.Id = vbContainerId FOR UPDATE;
         END IF;


         -- update !!!only!! Parent
         UPDATE Container SET ParentId = CASE WHEN COALESCE (inParentId, 0) = 0 THEN NULL ELSE inParentId END
         WHERE Id = vbContainerId AND COALESCE (ParentId, 0) <> COALESCE (inParentId, 0);
     END IF;  


     -- Возвращаем значение
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;




-- Function: gpUnComplete_Movement()

CREATE OR REPLACE FUNCTION lpDelete_MovementItemContainer (IN inMovementId Integer)
  RETURNS void AS
$BODY$
  DECLARE vbLock Boolean;
BEGIN
    IF zc_IsLockTable() = TRUE
    THEN
    -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
    LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;

    ELSE
        PERFORM Container.* FROM Container INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id AND MovementItemContainer.MovementId = inMovementId FOR UPDATE;
        PERFORM MovementItemContainer.* FROM MovementItemContainer WHERE MovementItemContainer.MovementId = inMovementId FOR UPDATE;
    END IF;

    -- Изменить значение остатка
    UPDATE Container SET Amount = Container.Amount - _tmpMIContainer.Amount
    FROM (SELECT SUM (MIContainer.Amount) AS Amount
               , MIContainer.ContainerId
          FROM MovementItemContainer AS MIContainer
          WHERE MIContainer.MovementId = inMovementId
          GROUP BY MIContainer.ContainerId
         ) AS _tmpMIContainer
    WHERE Container.Id = _tmpMIContainer.ContainerId;

    -- Удалить все проводки
    DELETE FROM MovementItemContainer WHERE MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


-- Function: lpInsertUpdate_MovementItemContainer


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer(
 INOUT ioId                      Integer               ,
    IN inDescId                  Integer               ,
    IN inMovementDescId          Integer               ,
    IN inMovementId              Integer               ,
    IN inMovementItemId          Integer               ,
    IN inParentId                Integer               ,
    IN inContainerId             Integer               ,
    IN inAccountId               Integer               ,
    IN inAnalyzerId              Integer               ,
    IN inObjectId_Analyzer       Integer               ,
    IN inWhereObjectId_Analyzer  Integer               ,
    IN inContainerId_Analyzer    Integer               ,
    IN inObjectIntId_Analyzer    Integer               ,
    IN inObjectExtId_Analyzer    Integer               ,
    IN inAmount                  TFloat                ,
    IN inOperDate                TDateTime             ,
    IN inIsActive                Boolean
)
AS
$BODY$
  DECLARE vbLock Boolean;
BEGIN
    IF zc_IsLockTable() = TRUE
    THEN
    -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
    LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;

    ELSE
        PERFORM Container.* FROM Container WHERE Container.Id = inContainerId FOR UPDATE;
    END IF;

     -- меняем параметр
     IF inParentId = 0 THEN inParentId:= NULL; END IF;

     -- изменить значение остатка
     UPDATE Container SET Amount = Amount + COALESCE (inAmount, 0) WHERE Id = inContainerId;
     -- сохранили проводку
     INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                      , Amount, OperDate, IsActive)
                                VALUES (inDescId, inMovementDescId, inMovementId, inMovementItemId, inParentId, inContainerId
                                      , CASE WHEN inAccountId = 0 THEN NULL ELSE inAccountId END
                                      , CASE WHEN inAnalyzerId = 0 THEN NULL ELSE inAnalyzerId END
                                      , CASE WHEN inObjectId_Analyzer = 0 THEN NULL ELSE inObjectId_Analyzer END
                                      , CASE WHEN inWhereObjectId_Analyzer = 0 THEN NULL ELSE inWhereObjectId_Analyzer END
                                      , CASE WHEN inContainerId_Analyzer = 0 THEN NULL ELSE inContainerId_Analyzer END
                                      , CASE WHEN inObjectIntId_Analyzer = 0 THEN NULL ELSE inObjectIntId_Analyzer END
                                      , CASE WHEN inObjectExtId_Analyzer = 0 THEN NULL ELSE inObjectExtId_Analyzer END
                                      , COALESCE (inAmount, 0), inOperDate, inIsActive
                                       ) RETURNING Id INTO ioId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;




 -- Function: lpInsertUpdate_MovementItemContainer_byTable ()

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer_byTable ()
RETURNS VOID
AS
$BODY$
   DECLARE vbCount Integer;
   DECLARE vbLock Boolean;
BEGIN
    IF zc_IsLockTable() = TRUE
    THEN
    -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
    LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
    ELSE
          PERFORM Container.* FROM Container INNER JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.ContainerId = Container.Id FOR UPDATE;
    END IF;


     -- изменить значение остатка
     UPDATE Container SET Amount = Container.Amount + _tmpMIContainer.Amount
     FROM (SELECT ContainerId, SUM (COALESCE (_tmpMIContainer_insert.Amount, 0)) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId) AS _tmpMIContainer
     WHERE Container.Id = _tmpMIContainer.ContainerId;

     -- сохранили проводки
     INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                      , Amount, OperDate, IsActive)
        SELECT DescId, MovementDescId, MovementId
             , CASE WHEN MovementItemId = 0 THEN NULL ELSE MovementItemId END
             , CASE WHEN ParentId = 0 THEN NULL ELSE ParentId END
             , ContainerId
             , CASE WHEN AccountId = 0 THEN NULL ELSE AccountId END
             , CASE WHEN AnalyzerId = 0 THEN NULL ELSE AnalyzerId END
             , CASE WHEN ObjectId_Analyzer = 0 THEN NULL ELSE ObjectId_Analyzer END
             , CASE WHEN WhereObjectId_Analyzer = 0 THEN NULL ELSE WhereObjectId_Analyzer END
             , CASE WHEN ContainerId_Analyzer = 0 THEN NULL ELSE ContainerId_Analyzer END
             , CASE WHEN ObjectIntId_Analyzer = 0 THEN NULL ELSE ObjectIntId_Analyzer END
             , CASE WHEN ObjectExtId_Analyzer = 0 THEN NULL ELSE ObjectExtId_Analyzer END
             , COALESCE (Amount, 0)
             , OperDate
             , IsActive
        FROM _tmpMIContainer_insert;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
