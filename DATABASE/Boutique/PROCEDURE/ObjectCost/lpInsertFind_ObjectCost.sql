-- Function: lpInsertFind_ObjectCost

DROP FUNCTION IF EXISTS lpInsertFind_ObjectCost (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertFind_ObjectCost (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_ObjectCost(
    IN inContainerId             Integer               , -- 
    IN inObjectCostDescId        Integer               , -- DescId для <элемент с/с>
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
   DECLARE vbObjectCostId Integer;
   DECLARE vbIs_tmp1 Boolean;

   DECLARE vbKeyValue TVarChar;
   DECLARE vbMasterKeyValue BigInt;
   DECLARE vbChildKeyValue BigInt;
BEGIN
     RAISE EXCEPTION 'lpInsertFind_ObjectCost';
     --

     inObjectCostDescId := COALESCE (inObjectCostDescId, 0);
     inObjectId_1       := COALESCE (inObjectId_1, 0);
     inObjectId_2       := COALESCE (inObjectId_2, 0);
     inObjectId_3       := COALESCE (inObjectId_3, 0);
     inObjectId_4       := COALESCE (inObjectId_4, 0);
     inObjectId_5       := COALESCE (inObjectId_5, 0);
     inObjectId_6       := COALESCE (inObjectId_6, 0);
     inObjectId_7       := COALESCE (inObjectId_7, 0);
     inObjectId_8       := COALESCE (inObjectId_8, 0);
     inObjectId_9       := COALESCE (inObjectId_9, 0);
     inObjectId_10      := COALESCE (inObjectId_10, 0);


     -- !!!
     -- !!!пока не понятно с проводками по Бизнесу, кроме счета Прибыль, поэтому учитывать по этой аналитике не будем, т.е. обнуляем значение!!!
     IF inDescId_1 = zc_ObjectCostLink_Business() THEN inObjectId_1:= 0; END IF;
     IF inDescId_2 = zc_ObjectCostLink_Business() THEN inObjectId_2:= 0; END IF;
     IF inDescId_3 = zc_ObjectCostLink_Business() THEN inObjectId_3:= 0; END IF;
     IF inDescId_4 = zc_ObjectCostLink_Business() THEN inObjectId_4:= 0; END IF;
     IF inDescId_5 = zc_ObjectCostLink_Business() THEN inObjectId_5:= 0; END IF;
     IF inDescId_6 = zc_ObjectCostLink_Business() THEN inObjectId_6:= 0; END IF;
     IF inDescId_7 = zc_ObjectCostLink_Business() THEN inObjectId_7:= 0; END IF;
     IF inDescId_8 = zc_ObjectCostLink_Business() THEN inObjectId_8:= 0; END IF;
     IF inDescId_9 = zc_ObjectCostLink_Business() THEN inObjectId_9:= 0; END IF;
     IF inDescId_10 = zc_ObjectCostLink_Business() THEN inObjectId_10:= 0; END IF;
     -- !!!
     -- !!!


     -- !!!определяется КЛЮЧ!!!
     vbKeyValue = (SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                         FROM     (SELECT COALESCE (inObjectCostDescId, 0)        AS Value, 0 AS myOrder1, -1 AS myOrder2
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


     -- находим
     BEGIN
     -- !!!находим СРАЗУ по ключу!!!
     -- vbObjectCostId := (SELECT MAX (ObjectCostId) FROM ContainerObjectCost WHERE KeyValue = vbKeyValue);

     -- !!!находим СРАЗУ по ДВУМ ключам!!!
     -- vbObjectCostId := (SELECT MAX (ObjectCostId) FROM ContainerObjectCost WHERE MasterKeyValue = vbMasterKeyValue AND ChildKeyValue = vbChildKeyValue);

     -- !!!находим СРАЗУ по ContainerId!!!
     vbObjectCostId := (SELECT ObjectCostId FROM ContainerObjectCost WHERE ContainerId = inContainerId AND ObjectCostDescId = inObjectCostDescId);

/*
     -- Если не нашли, находим по старому алгоритму
     IF COALESCE (vbObjectCostId, 0) = 0
     THEN

              IF inDescId_1 IS NOT NULL
              THEN
                   -- первый
                   vbIs_tmp1:= TRUE;
                   DELETE FROM _tmp1___;
                   INSERT INTO _tmp1___ (Id)
                      SELECT ObjectCostLink_1.ObjectCostId
                      FROM ObjectCostLink AS ObjectCostLink_1
                      WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                        AND ObjectCostLink_1.DescId = inDescId_1
                        AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId;
              ELSE 
                   RAISE EXCEPTION 'Ошибка - Не определены аналитики lpInsertFind_ObjectCost : vbObjectCostId = "%", inObjectCostDescId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', vbObjectCostId, inObjectCostDescId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
              END IF;


              -- !!!остальные условия одинаковые!!!

              IF inDescId_2 IS NOT NULL
              THEN
                   -- !!!2!!!
                   IF vbIs_tmp1 = TRUE
                   THEN
                        DELETE FROM _tmp2___;
                        INSERT INTO _tmp2___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                       AND ObjectCostLink_2.DescId             = inDescId_2
                                                                       AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                       AND ObjectCostLink_2.DescId             = inDescId_2
                                                                       AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.Id;
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
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                       AND ObjectCostLink_3.DescId             = inDescId_3
                                                                       AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                       AND ObjectCostLink_3.DescId             = inDescId_3
                                                                       AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.Id;
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
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                       AND ObjectCostLink_4.DescId             = inDescId_4
                                                                       AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                       AND ObjectCostLink_4.DescId             = inDescId_4
                                                                       AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.Id;
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
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                       AND ObjectCostLink_5.DescId             = inDescId_5
                                                                       AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                       AND ObjectCostLink_5.DescId             = inDescId_5
                                                                       AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.Id;
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
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                       AND ObjectCostLink_6.DescId             = inDescId_6
                                                                       AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                       AND ObjectCostLink_6.DescId             = inDescId_6
                                                                       AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.Id;
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
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectId           = inObjectId_7
                                                                       AND ObjectCostLink_7.DescId             = inDescId_7
                                                                       AND ObjectCostLink_7.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_7.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectId           = inObjectId_7
                                                                       AND ObjectCostLink_7.DescId             = inDescId_7
                                                                       AND ObjectCostLink_7.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_7.ObjectCostId       = ObjectCostLink_1.Id;
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
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_8 ON ObjectCostLink_8.ObjectId           = inObjectId_8
                                                                       AND ObjectCostLink_8.DescId             = inDescId_8
                                                                       AND ObjectCostLink_8.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_8.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_8 ON ObjectCostLink_8.ObjectId           = inObjectId_8
                                                                       AND ObjectCostLink_8.DescId             = inDescId_8
                                                                       AND ObjectCostLink_8.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_8.ObjectCostId       = ObjectCostLink_1.Id;
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
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_9 ON ObjectCostLink_9.ObjectId           = inObjectId_9
                                                                       AND ObjectCostLink_9.DescId             = inDescId_9
                                                                       AND ObjectCostLink_9.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_9.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_9 ON ObjectCostLink_9.ObjectId           = inObjectId_9
                                                                       AND ObjectCostLink_9.DescId             = inDescId_9
                                                                       AND ObjectCostLink_9.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_9.ObjectCostId       = ObjectCostLink_1.Id;
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
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp1___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_10 ON ObjectCostLink_10.ObjectId           = inObjectId_10
                                                                       AND ObjectCostLink_10.DescId             = inDescId_10
                                                                       AND ObjectCostLink_10.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_10.ObjectCostId       = ObjectCostLink_1.Id;
                   ELSE
                        DELETE FROM _tmp1___;
                        INSERT INTO _tmp1___ (Id)
                           SELECT ObjectCostLink_1.Id AS ObjectCostId
                           FROM _tmp2___ AS ObjectCostLink_1
                                JOIN ObjectCostLink AS ObjectCostLink_10 ON ObjectCostLink_10.ObjectId           = inObjectId_10
                                                                       AND ObjectCostLink_10.DescId             = inDescId_10
                                                                       AND ObjectCostLink_10.ObjectCostDescId   = inObjectCostDescId
                                                                       AND ObjectCostLink_10.ObjectCostId       = ObjectCostLink_1.Id;
                   END IF;
                   -- устанавливаем обратно
                   vbIs_tmp1:= NOT vbIs_tmp1;
              END IF;


              -- Результат
              IF vbIs_tmp1 = TRUE
              THEN
                   vbObjectCostId := (SELECT Id FROM _tmp1___);
              ELSE
                   vbObjectCostId := (SELECT Id FROM _tmp2___);
              END IF;

     END IF; -- if Если не нашли, находим по старому алгоритму
*/
     EXCEPTION
              WHEN invalid_row_count_in_limit_clause
              THEN RAISE EXCEPTION 'Ошибка lpInsertFind_ObjectCost : vbObjectCostId = "%", inObjectCostDescId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', vbObjectCostId, inObjectCostDescId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
     END;

     -- Если не нашли, добавляем
     IF COALESCE (vbObjectCostId, 0) = 0
     THEN
         -- определяем новый ObjectCostId
         SELECT NEXTVAL ('objectcost_id_seq') INTO vbObjectCostId;

         -- добавили Аналитики
         INSERT INTO ObjectCostLink (DescId, ObjectCostDescId, ObjectCostId, ObjectId)
            SELECT inDescId_1, inObjectCostDescId, vbObjectCostId, inObjectId_1 WHERE inDescId_1 <> 0
           UNION ALL
            SELECT inDescId_2, inObjectCostDescId, vbObjectCostId, inObjectId_2 WHERE inDescId_2 <> 0
           UNION ALL
            SELECT inDescId_3, inObjectCostDescId, vbObjectCostId, inObjectId_3 WHERE inDescId_3 <> 0
           UNION ALL
            SELECT inDescId_4, inObjectCostDescId, vbObjectCostId, inObjectId_4 WHERE inDescId_4 <> 0
           UNION ALL
            SELECT inDescId_5, inObjectCostDescId, vbObjectCostId, inObjectId_5 WHERE inDescId_5 <> 0
           UNION ALL
            SELECT inDescId_6, inObjectCostDescId, vbObjectCostId, inObjectId_6 WHERE inDescId_6 <> 0
           UNION ALL
            SELECT inDescId_7, inObjectCostDescId, vbObjectCostId, inObjectId_7 WHERE inDescId_7 <> 0
           UNION ALL
            SELECT inDescId_8, inObjectCostDescId, vbObjectCostId, inObjectId_8 WHERE inDescId_8 <> 0
           UNION ALL
            SELECT inDescId_9, inObjectCostDescId, vbObjectCostId, inObjectId_9 WHERE inDescId_9 <> 0
           UNION ALL
            SELECT inDescId_10, inObjectCostDescId, vbObjectCostId, inObjectId_10 WHERE inDescId_10 <> 0;

     END IF;  


     -- Финиш - Связь с Container

     -- Устанавливаем новое значение
     UPDATE ContainerObjectCost SET ObjectCostId   = vbObjectCostId
                                  , KeyValue       = vbKeyValue
                                  , MasterKeyValue = vbMasterKeyValue
                                  , ChildKeyValue  = vbChildKeyValue
     WHERE ContainerId = inContainerId AND ObjectCostDescId = inObjectCostDescId;
     -- Если не нашли, добавляем
     IF NOT FOUND
     THEN
         INSERT INTO ContainerObjectCost (ObjectCostDescId, ContainerId, ObjectCostId, KeyValue, MasterKeyValue, ChildKeyValue)
                                  VALUES (inObjectCostDescId, inContainerId, vbObjectCostId, vbKeyValue, vbMasterKeyValue, vbChildKeyValue);
     END IF;  

-- if vbObjectCostId <> 796 then
-- RAISE EXCEPTION 'lpInsertFind_ObjectCost';
-- end if;

     -- Возвращаем значение
     RETURN (vbObjectCostId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_ObjectCost (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.14                                        * add RAISE EXCEPTION 'lpInsertFind_ObjectCost'
 07.08.14                                        * ALL
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 28.03.14                                        * удаление из таблицы - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 19.09.13                                        * optimize
 10.07.13                                        *
*/

-- тест
/*
SELECT * FROM lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                     , inDescId_1   := zc_ObjectCostLink_Unit()
                                     , inObjectId_1 := 21720
                                     , inDescId_2   := zc_ObjectCostLink_Goods()
                                     , inObjectId_2 := 4341
                                     , inDescId_3   := NULL
                                     , inObjectId_3 := NULL
                                     , inDescId_4   := zc_ObjectCostLink_InfoMoney()
                                     , inObjectId_4 := 23463
                                     , inDescId_5   := zc_ObjectCostLink_InfoMoneyDetail()
                                     , inObjectId_5 := 23463
                                     , inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                     )
*/

/*
-- !!!!!!!!!!!!!!!!!!!!!
-- !!!update KeyValue!!!
-- !!!!!!!!!!!!!!!!!!!!!

select  co, tmp.KeyValue, ContainerObjectCost.KeyValue, ContainerObjectCost.*

-- update ContainerObjectCost set KeyValue = tmp.KeyValue
from (
SELECT  STRING_AGG (tmp.Value, CASE WHEN tmp.myOrder1 = 0 THEN ';' ELSE ',' END)
 || case count(*) when 1 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 3 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 5 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 7 then ';0,0;0,0;0,0;0,0;0,0;0,0;0,0'
                  when 9 then ';0,0;0,0;0,0;0,0;0,0;0,0'
                  when 11 then ';0,0;0,0;0,0;0,0;0,0'
                  when 13 then ';0,0;0,0;0,0;0,0'
                  when 15 then ';0,0;0,0;0,0'
                  when 17 then ';0,0;0,0'
                  when 19 then ';0,0'
                          else ''
    end 
    as KeyValue

, tmp.ObjectCostId, count(*) as co
                   FROM (SELECT tmp.Value :: TVarChar AS Value
                              , tmp.myOrder1
                              , tmp.ObjectCostId
                         FROM     (SELECT Value, myOrder1, myOrder2, ObjectCostId FROM (SELECT ObjectCostDescId AS Value, 0 AS myOrder1, -1 AS myOrder2, ObjectCostId FROM ContainerObjectCost group by ObjectCostDescId, ObjectCostId) as tmp
                         UNION ALL SELECT COALESCE (DescId, 0)                  AS Value, 0 AS myOrder1, DescId AS myOrder2, ObjectCostId FROM ObjectCostLink
                         UNION ALL SELECT COALESCE (ObjectId, 0)                AS Value, 1 AS myOrder1, DescId AS myOrder2, ObjectCostId FROM ObjectCostLink

                                  ) AS tmp
--  join ContainerObjectCost on ContainerObjectCost.ObjectCostId = tmp.ObjectCostId and ContainerObjectCost.KeyValue <> ''
-- where ObjectCostId in (109108 , 141579) --
                         ORDER BY ObjectCostId, tmp.myOrder2, tmp.myOrder1
                        ) as tmp
group by tmp.ObjectCostId
) as tmp

 where ContainerObjectCost.ObjectCostId = tmp.ObjectCostId 

 left join ContainerObjectCost on ContainerObjectCost.ObjectCostId = tmp.ObjectCostId
 where ContainerObjectCost.KeyValue <> tmp.KeyValue


-- select * from ContainerObjectCost where coalesce (KeyValue, '') = ''
-- select KeyValue from (select ObjectCostId, KeyValue from ContainerObjectCost group by ObjectCostId, KeyValue) as tmp group by KeyValue having count (*) > 1


-- update ContainerObjectCost set MasterKeyValue = zfCalc_FromHex (SUBSTRING (md5 (KeyValue) FROM 1 FOR 8)), ChildKeyValue = zfCalc_FromHex (SUBSTRING (md5 (KeyValue) FROM 9 FOR 8))
-- select * from ContainerObjectCost where coalesce (MasterKeyValue, 0) = 0 or coalesce (ChildKeyValue, 0) = 0
-- select MasterKeyValue, ChildKeyValue from (select ObjectCostId, MasterKeyValue, ChildKeyValue from ContainerObjectCost group by ObjectCostId, MasterKeyValue, ChildKeyValue) as tmp group by MasterKeyValue, ChildKeyValue having count (*) > 1

*/