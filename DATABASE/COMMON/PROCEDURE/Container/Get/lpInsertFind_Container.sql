-- Function: lpInsertFind_Container 

-- DROP FUNCTION lpInsertFind_Container (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

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
BEGIN
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

     -- находим
     BEGIN
          IF inParentId IS NOT NULL AND inContainerDescId = zc_Container_Summ()
          THEN
              -- Это Суммовой учет для Товаров
              IF inDescId_1 IS NOT NULL
              THEN
                   -- первый
                   vbIs_tmp1:= TRUE;
                   DELETE FROM _tmp1___;
                   INSERT INTO _tmp1___ (Id)
                      SELECT Container.Id
                      FROM Container
                           JOIN ContainerLinkObject AS ContainerLinkObject_1 ON ContainerLinkObject_1.ObjectId    = inObjectId_1
                                                                            AND ContainerLinkObject_1.DescId      = inDescId_1
                                                                            AND ContainerLinkObject_1.ContainerId = Container.Id
                      WHERE Container.ParentId = inParentId
                        AND Container.ObjectId = inObjectId
                        AND Container.DescId   = inContainerDescId;
              ELSE 
                   -- первый
                   vbIs_tmp1:= TRUE;
                   DELETE FROM _tmp1___;
                   INSERT INTO _tmp1___ (Id)
                      SELECT Container.Id
                      FROM Container
                      WHERE Container.ParentId = inParentId
                        AND Container.ObjectId = inObjectId
                        AND Container.DescId   = inContainerDescId;
              END IF;

          ELSE -- else if inParentId IS NOT NULL AND inContainerDescId = zc_Container_Summ()

          
          IF  inContainerDescId = zc_Container_Count()
           OR inContainerDescId = zc_Container_CountSupplier()
          THEN
              -- Это Количественный учет для Товаров
              IF inDescId_1 IS NOT NULL
              THEN
                   -- первый
                   vbIs_tmp1:= TRUE;
                   DELETE FROM _tmp1___;
                   INSERT INTO _tmp1___ (Id)
                      SELECT Container.Id
                      FROM Container
                           JOIN ContainerLinkObject AS ContainerLinkObject_1 ON ContainerLinkObject_1.ObjectId    = inObjectId_1
                                                                            AND ContainerLinkObject_1.DescId      = inDescId_1
                                                                            AND ContainerLinkObject_1.ContainerId = Container.Id
                      WHERE Container.ObjectId = inObjectId
                        AND Container.DescId   = inContainerDescId;
              ELSE 
                   -- первый
                   vbIs_tmp1:= TRUE;
                   DELETE FROM _tmp1___;
                   INSERT INTO _tmp1___ (Id)
                      SELECT Container.Id
                      FROM Container
                      WHERE Container.ObjectId = inObjectId
                        AND Container.DescId   = inContainerDescId;
              END IF;

          ELSE -- else if inParentId IS NOT NULL AND inContainerDescId = zc_Container_Summ() !!!AND!!! else if inContainerDescId = zc_Container_Count ()

              -- Это Суммовой учет для !!!НЕ!!! для Товаров
              IF inDescId_1 IS NOT NULL
              THEN
                   -- первый
                   vbIs_tmp1:= TRUE;
                   DELETE FROM _tmp1___;
                   INSERT INTO _tmp1___ (Id)
                      SELECT ContainerLinkObject_1.ContainerId
                      FROM ContainerLinkObject AS ContainerLinkObject_1
                      WHERE ContainerLinkObject_1.ObjectId = inObjectId_1
                        AND ContainerLinkObject_1.DescId = inDescId_1;
              ELSE 
                   RAISE EXCEPTION 'Не определены аналитики : vbContainerId = "%", inContainerDescId = "%", inParentId = "%", inObjectId = "%", inJuridicalId_basis = "%", inBusinessId = "%", inObjectCostDescId = "%", inObjectCostId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', vbContainerId, inContainerDescId, inParentId, inObjectId, inJuridicalId_basis, inBusinessId, inObjectCostDescId, inObjectCostId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
              END IF;

          END IF;
          END IF;


          -- !!!остальные условия одинаковые!!!
              IF inDescId_2 IS NOT NULL
              THEN
                   -- !!!2!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_2 ON ContainerLinkObject_2.ObjectId    = inObjectId_2
                                                                                 AND ContainerLinkObject_2.DescId      = inDescId_2
                                                                                 AND ContainerLinkObject_2.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_2 ON ContainerLinkObject_2.ObjectId    = inObjectId_2
                                                                                 AND ContainerLinkObject_2.DescId      = inDescId_2
                                                                                 AND ContainerLinkObject_2.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;

              IF inDescId_3 IS NOT NULL
              THEN
                   -- !!!3!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_3 ON ContainerLinkObject_3.ObjectId    = inObjectId_3
                                                                                 AND ContainerLinkObject_3.DescId      = inDescId_3
                                                                                 AND ContainerLinkObject_3.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_3 ON ContainerLinkObject_3.ObjectId    = inObjectId_3
                                                                                 AND ContainerLinkObject_3.DescId      = inDescId_3
                                                                                 AND ContainerLinkObject_3.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;

              IF inDescId_4 IS NOT NULL
              THEN
                   -- !!!4!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_4 ON ContainerLinkObject_4.ObjectId    = inObjectId_4
                                                                                 AND ContainerLinkObject_4.DescId      = inDescId_4
                                                                                 AND ContainerLinkObject_4.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_4 ON ContainerLinkObject_4.ObjectId    = inObjectId_4
                                                                                 AND ContainerLinkObject_4.DescId      = inDescId_4
                                                                                 AND ContainerLinkObject_4.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;

              IF inDescId_5 IS NOT NULL
              THEN
                   -- !!!5!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_5 ON ContainerLinkObject_5.ObjectId    = inObjectId_5
                                                                                 AND ContainerLinkObject_5.DescId      = inDescId_5
                                                                                 AND ContainerLinkObject_5.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_5 ON ContainerLinkObject_5.ObjectId    = inObjectId_5
                                                                                 AND ContainerLinkObject_5.DescId      = inDescId_5
                                                                                 AND ContainerLinkObject_5.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;

              IF inDescId_6 IS NOT NULL
              THEN
                   -- !!!6!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_6 ON ContainerLinkObject_6.ObjectId    = inObjectId_6
                                                                                 AND ContainerLinkObject_6.DescId      = inDescId_6
                                                                                 AND ContainerLinkObject_6.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_6 ON ContainerLinkObject_6.ObjectId    = inObjectId_6
                                                                                 AND ContainerLinkObject_6.DescId      = inDescId_6
                                                                                 AND ContainerLinkObject_6.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;

              IF inDescId_7 IS NOT NULL
              THEN
                   -- !!!7!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_7 ON ContainerLinkObject_7.ObjectId    = inObjectId_7
                                                                                 AND ContainerLinkObject_7.DescId      = inDescId_7
                                                                                 AND ContainerLinkObject_7.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_7 ON ContainerLinkObject_7.ObjectId    = inObjectId_7
                                                                                 AND ContainerLinkObject_7.DescId      = inDescId_7
                                                                                 AND ContainerLinkObject_7.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;

              IF inDescId_8 IS NOT NULL
              THEN
                   -- !!!8!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_8 ON ContainerLinkObject_8.ObjectId    = inObjectId_8
                                                                                 AND ContainerLinkObject_8.DescId      = inDescId_8
                                                                                 AND ContainerLinkObject_8.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_8 ON ContainerLinkObject_8.ObjectId    = inObjectId_8
                                                                                 AND ContainerLinkObject_8.DescId      = inDescId_8
                                                                                 AND ContainerLinkObject_8.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;

              IF inDescId_9 IS NOT NULL
              THEN
                   -- !!!9!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_9 ON ContainerLinkObject_9.ObjectId    = inObjectId_9
                                                                                 AND ContainerLinkObject_9.DescId      = inDescId_9
                                                                                 AND ContainerLinkObject_9.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_9 ON ContainerLinkObject_9.ObjectId    = inObjectId_9
                                                                                 AND ContainerLinkObject_9.DescId      = inDescId_9
                                                                                 AND ContainerLinkObject_9.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;


              IF inDescId_10 IS NOT NULL
              THEN
                   -- !!!10!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_10 ON ContainerLinkObject_10.ObjectId    = inObjectId_10
                                                                                  AND ContainerLinkObject_10.DescId      = inDescId_10
                                                                                  AND ContainerLinkObject_10.ContainerId = Container.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS Container
                                JOIN ContainerLinkObject AS ContainerLinkObject_10 ON ContainerLinkObject_10.ObjectId    = inObjectId_10
                                                                                  AND ContainerLinkObject_10.DescId      = inDescId_10
                                                                                  AND ContainerLinkObject_10.ContainerId = Container.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;

          -- !!!по второму кругу в последний раз!!!
          IF  inContainerDescId = zc_Container_Count()
           OR inContainerDescId = zc_Container_CountSupplier()
          THEN
              -- Это Количественный учет для Товаров
              -- Результат
              IF vbIs_tmp1 = TRUE
              THEN
                   vbContainerId := (SELECT Container.Id FROM _tmp1___ AS Container);
              ELSE
                   vbContainerId := (SELECT Container.Id FROM _tmp2___ AS Container);
              END IF;

          ELSE -- else if inContainerDescId = zc_Container_Count() OR inContainerDescId = zc_Container_CountSupplier()

              -- Это Суммовой учет для Товаров
              --   и Суммовой учет для !!!НЕ!!! для Товаров

              -- еще по одной аналитике если Суммовой учет для !!!НЕ!!! для Товаров
              IF inParentId IS NULL OR inContainerDescId <> zc_Container_Summ()
              THEN
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT Container.Id
                           FROM _tmp1___ AS ContainerLinkObject_1
                                JOIN Container ON Container.Id       = ContainerLinkObject_1.Id
                                              AND Container.ObjectId = inObjectId
                                              AND Container.DescId   = inContainerDescId;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT Container.Id
                           FROM _tmp2___ AS ContainerLinkObject_1
                                JOIN Container ON Container.Id       = ContainerLinkObject_1.Id
                                              AND Container.ObjectId = inObjectId
                                              AND Container.DescId   = inContainerDescId;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;


              -- !!!Предпоследний!!! - есть всегда
              IF vbIs_tmp1 = TRUE
              THEN
                   DELETE FROM _tmp2___;
                   INSERT INTO _tmp2___ (Id)
                      SELECT Container.Id
                      FROM _tmp1___ AS Container
                           JOIN ContainerLinkObject AS ContainerLinkObject_12 ON ContainerLinkObject_12.ObjectId    = inJuridicalId_basis
                                                                             AND ContainerLinkObject_12.DescId      = zc_ContainerLinkObject_JuridicalBasis()
                                                                             AND ContainerLinkObject_12.ContainerId = Container.Id;
              ELSE
                   DELETE FROM _tmp1___;
                   INSERT INTO _tmp1___ (Id)
                      SELECT Container.Id
                      FROM _tmp2___ AS Container
                           JOIN ContainerLinkObject AS ContainerLinkObject_12 ON ContainerLinkObject_12.ObjectId    = inJuridicalId_basis
                                                                             AND ContainerLinkObject_12.DescId      = zc_ContainerLinkObject_JuridicalBasis()
                                                                             AND ContainerLinkObject_12.ContainerId = Container.Id;
              END IF;
              -- устанавливаем обратно
              vbIs_tmp1:= NOT vbIs_tmp1;

              -- Результат с !!!Последним!!! - есть всегда
              IF vbIs_tmp1 = TRUE
              THEN
                   vbContainerId := (SELECT Container.Id
                                     FROM _tmp1___ AS Container
                                          JOIN ContainerLinkObject AS ContainerLinkObject_11 ON ContainerLinkObject_11.ObjectId    = inBusinessId
                                                                                            AND ContainerLinkObject_11.DescId      = zc_ContainerLinkObject_Business()
                                                                                            AND ContainerLinkObject_11.ContainerId = Container.Id);
              ELSE
                   vbContainerId := (SELECT Container.Id
                                     FROM _tmp2___ AS Container
                                          JOIN ContainerLinkObject AS ContainerLinkObject_11 ON ContainerLinkObject_11.ObjectId    = inBusinessId
                                                                                            AND ContainerLinkObject_11.DescId      = zc_ContainerLinkObject_Business()
                                                                                            AND ContainerLinkObject_11.ContainerId = Container.Id);
              END IF;

          END IF;

     EXCEPTION
              WHEN invalid_row_count_in_limit_clause
              THEN RAISE EXCEPTION 'Счет не уникален : vbContainerId = "%", inContainerDescId = "%", inParentId = "%", inObjectId = "%", inJuridicalId_basis = "%", inBusinessId = "%", inObjectCostDescId = "%", inObjectCostId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', vbContainerId, inContainerDescId, inParentId, inObjectId, inJuridicalId_basis, inBusinessId, inObjectCostDescId, inObjectCostId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
     END;
          

     /*IF COALESCE (vbContainerId, 0) = 0
     THEN
         RAISE EXCEPTION 'Счет не уникален : inContainerDescId = "%", inParentId = "%", inObjectId = "%", inJuridicalId_basis = "%", inBusinessId = "%", inObjectCostDescId = "%", inObjectCostId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', inContainerDescId, inParentId, inObjectId, inJuridicalId_basis, inBusinessId, inObjectCostDescId, inObjectCostId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
     END IF;*/


     -- Если не нашли, добавляем
     IF COALESCE (vbContainerId, 0) = 0
     THEN
         -- добавили Остаток
         INSERT INTO Container (DescId, ObjectId, ParentId, Amount)
                        VALUES (inContainerDescId, inObjectId, CASE WHEN inParentId = 0 THEN NULL ELSE inParentId END, 0)
            RETURNING Id INTO vbContainerId;

         -- добавили Аналитики
         INSERT INTO ContainerLinkObject (DescId, ContainerId, ObjectId)
            SELECT zc_ContainerLinkObject_JuridicalBasis(), vbContainerId, inJuridicalId_basis WHERE inContainerDescId = zc_Container_Summ()
           UNION ALL
            SELECT zc_ContainerLinkObject_Business(), vbContainerId, inBusinessId WHERE inContainerDescId = zc_Container_Summ()
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
         -- update !!!only!! Parent
         UPDATE Container SET ParentId = CASE WHEN COALESCE (inParentId, 0) = 0 THEN NULL ELSE inParentId END
         WHERE Id = vbContainerId AND COALESCE (ParentId, 0) <> COALESCE (inParentId, 0);
     END IF;  

     -- если есть Аналитики <элемент с/с.>
     IF COALESCE (inObjectCostDescId, 0) <> 0
     THEN
         -- Устанавливаем новое значение
         UPDATE ContainerObjectCost SET ObjectCostId = inObjectCostId WHERE ContainerId = vbContainerId AND ObjectCostDescId = inObjectCostDescId;
         -- Если не нашли, добавляем
         IF NOT FOUND
         THEN
             INSERT INTO ContainerObjectCost (ObjectCostDescId, ContainerId, ObjectCostId)
                                      VALUES (inObjectCostDescId, vbContainerId, inObjectCostId);
         END IF;  
     END IF;  


--if vbContainerId <> 5632 and inContainerDescId <> 1 then
--RAISE EXCEPTION 'vbContainerId = % : inContainerDescId = "%", inParentId = "%", inObjectId = "%", inJuridicalId_basis = "%", inBusinessId = "%", inObjectCostDescId = "%", inObjectCostId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', vbContainerId, inContainerDescId, inParentId, inObjectId, inJuridicalId_basis, inBusinessId, inObjectCostDescId, inObjectCostId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
--end if;


     -- Возвращаем значение
     RETURN (vbContainerId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Container (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 28.03.14                                        * удаление из таблицы - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 27.01.14                                        * !!!пока не понятно с проводками по Бизнесу, кроме счета Прибыль, поэтому учитывать по этой аналитике не будем, т.е. обнуляем значение!!!
 19.09.13                                        * optimize
 18.09.13                        *  Чуть ускорил
 02.09.13                                        * add Проверка
 11.07.13                                        * add inObjectCostDescId and inObjectCostId
 11.07.13                                        * add inParentId
 09.07.13                                        * !!! finich !!!
 08.07.13                                        * optimize
 04.07.13                                        * rename AccountId to ObjectId
 04.07.13                                        * Amount
 03.07.13                                        * то что здорово, работает не правильно :)))
 02.07.13                                        * А здорово получилось
*/

-- тест
/*
CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;
SELECT * FROM lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                    , inParentId:= 0
                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId:= zc_Enum_AccountGroup_20000() -- 20000; "Запасы" -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                              , inAccountDirectionId:= 23581
                                                                              , inInfoMoneyDestinationId:= zc_Enum_InfoMoneyDestination_10100()
                                                                              , inInfoMoneyId:= NULL
                                                                              , inUserId:= 2
                                                                               )
                                    , inJuridicalId_basis:= 23966
                                    , inBusinessId       := 21709
                                    , inObjectCostDescId := NULL
                                    , inObjectCostId     := NULL
                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                    , inObjectId_1 := 21720
                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                    , inObjectId_2 := 4341
                                    , inDescId_3   := NULL
                                    , inObjectId_3 := NULL
                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                    , inObjectId_4 := 23463
                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                    , inObjectId_5 := 23463
                                    , inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                     )
*/
