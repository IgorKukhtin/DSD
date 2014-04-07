-- Function: lpInsertFind_ObjectCost_OLD

-- DROP FUNCTION lpInsertFind_ObjectCost_OLD (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_ObjectCost_OLD(
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
BEGIN
     -- удаление из таблицы - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
     -- DELETE FROM _tmp___ ;

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


     BEGIN

     -- находим
     IF inDescId_10 IS NOT NULL
     THEN
         vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                      AND ObjectCostLink_5.DescId             = inDescId_5
                                                                      AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                      AND ObjectCostLink_6.DescId             = inDescId_6
                                                                      AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectId           = inObjectId_7
                                                                      AND ObjectCostLink_7.DescId             = inDescId_7
                                                                      AND ObjectCostLink_7.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_7.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_8 ON ObjectCostLink_8.ObjectId           = inObjectId_8
                                                                      AND ObjectCostLink_8.DescId             = inDescId_8
                                                                      AND ObjectCostLink_8.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_8.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_9 ON ObjectCostLink_9.ObjectId           = inObjectId_9
                                                                      AND ObjectCostLink_9.DescId             = inDescId_9
                                                                      AND ObjectCostLink_9.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_9.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_10 ON ObjectCostLink_10.ObjectId         = inObjectId_10
                                                                       AND ObjectCostLink_10.DescId           = inDescId_10
                                                                       AND ObjectCostLink_10.ObjectCostDescId = inObjectCostDescId
                                                                       AND ObjectCostLink_10.ObjectCostId     = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                          );
     ELSE
     IF inDescId_9  IS NOT NULL
     THEN
       vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                      AND ObjectCostLink_5.DescId             = inDescId_5
                                                                      AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                      AND ObjectCostLink_6.DescId             = inDescId_6
                                                                      AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectId           = inObjectId_7
                                                                      AND ObjectCostLink_7.DescId             = inDescId_7
                                                                      AND ObjectCostLink_7.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_7.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_8 ON ObjectCostLink_8.ObjectId           = inObjectId_8
                                                                      AND ObjectCostLink_8.DescId             = inDescId_8
                                                                      AND ObjectCostLink_8.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_8.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_9 ON ObjectCostLink_9.ObjectId           = inObjectId_9
                                                                      AND ObjectCostLink_9.DescId             = inDescId_9
                                                                      AND ObjectCostLink_9.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_9.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                          WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                            AND ObjectCostLink_1.DescId = inDescId_1
                            AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                         );
/*
                       -- !!!ОПТИМИЗАЦИЯ!!!
                       INSERT INTO _tmp___ (Id)
                          SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                      AND ObjectCostLink_5.DescId             = inDescId_5
                                                                      AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId;
         -- !!!ОПТИМИЗАЦИЯ!!!
         vbObjectCostId:=(SELECT ObjectCostLink_1.Id AS ObjectCostId
                          FROM _tmp___ AS ObjectCostLink_1
                               -- JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                               --                                        AND ObjectCostLink_2.DescId             = inDescId_2
                               --                                        AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                               --                                        AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.Id
                               -- JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                               --                                       AND ObjectCostLink_3.DescId             = inDescId_3
                               --                                       AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                               --                                       AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.Id
                               -- JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                               --                                        AND ObjectCostLink_4.DescId             = inDescId_4
                               --                                        AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                               --                                        AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.Id
                               -- JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                               --                                        AND ObjectCostLink_5.DescId             = inDescId_5
                               --                                        AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                               --                                        AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                      AND ObjectCostLink_6.DescId             = inDescId_6
                                                                      AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectId           = inObjectId_7
                                                                      AND ObjectCostLink_7.DescId             = inDescId_7
                                                                      AND ObjectCostLink_7.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_7.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_8 ON ObjectCostLink_8.ObjectId           = inObjectId_8
                                                                      AND ObjectCostLink_8.DescId             = inDescId_8
                                                                      AND ObjectCostLink_8.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_8.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_9 ON ObjectCostLink_9.ObjectId           = inObjectId_9
                                                                      AND ObjectCostLink_9.DescId             = inDescId_9
                                                                      AND ObjectCostLink_9.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_9.ObjectCostId       = ObjectCostLink_1.Id
                         );*/

     ELSE
     IF inDescId_8  IS NOT NULL
     THEN
       vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                      AND ObjectCostLink_5.DescId             = inDescId_5
                                                                      AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                      AND ObjectCostLink_6.DescId             = inDescId_6
                                                                      AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectId           = inObjectId_7
                                                                      AND ObjectCostLink_7.DescId             = inDescId_7
                                                                      AND ObjectCostLink_7.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_7.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_8 ON ObjectCostLink_8.ObjectId           = inObjectId_8
                                                                      AND ObjectCostLink_8.DescId             = inDescId_8
                                                                      AND ObjectCostLink_8.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_8.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                          WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                            AND ObjectCostLink_1.DescId = inDescId_1
                            AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                         );
/*
                       -- !!!ОПТИМИЗАЦИЯ!!!
                       INSERT INTO _tmp___ (Id)
                          SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId;
         -- !!!ОПТИМИЗАЦИЯ!!!
         vbObjectCostId:=(SELECT ObjectCostLink_1.Id AS ObjectCostId
                          FROM _tmp___ AS ObjectCostLink_1
                               -- JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                               --                                        AND ObjectCostLink_2.DescId             = inDescId_2
                               --                                        AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                               --                                        AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.Id
                               -- JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                               --                                       AND ObjectCostLink_3.DescId             = inDescId_3
                               --                                       AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                               --                                       AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                      AND ObjectCostLink_5.DescId             = inDescId_5
                                                                      AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                      AND ObjectCostLink_6.DescId             = inDescId_6
                                                                      AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectId           = inObjectId_7
                                                                      AND ObjectCostLink_7.DescId             = inDescId_7
                                                                      AND ObjectCostLink_7.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_7.ObjectCostId       = ObjectCostLink_1.Id
                               JOIN ObjectCostLink AS ObjectCostLink_8 ON ObjectCostLink_8.ObjectId           = inObjectId_8
                                                                      AND ObjectCostLink_8.DescId             = inDescId_8
                                                                      AND ObjectCostLink_8.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_8.ObjectCostId       = ObjectCostLink_1.Id
                         );*/
-- vbObjectCostId  := 796;
/*if vbObjectCostId  <> 796
then
               RAISE EXCEPTION 'vbObjectCostId % : inObjectCostDescId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', vbObjectCostId, inObjectCostDescId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
end if;*/
     ELSE
     IF inDescId_7  IS NOT NULL
     THEN
         vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                      AND ObjectCostLink_5.DescId             = inDescId_5
                                                                      AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                      AND ObjectCostLink_6.DescId             = inDescId_6
                                                                      AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectId           = inObjectId_7
                                                                      AND ObjectCostLink_7.DescId             = inDescId_7
                                                                      AND ObjectCostLink_7.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_7.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                          );
     ELSE
     IF inDescId_6  IS NOT NULL
     THEN
         vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                      AND ObjectCostLink_5.DescId             = inDescId_5
                                                                      AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectId           = inObjectId_6
                                                                      AND ObjectCostLink_6.DescId             = inDescId_6
                                                                      AND ObjectCostLink_6.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_6.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                          );
     ELSE
     IF inDescId_5  IS NOT NULL
     THEN
         vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectId           = inObjectId_5
                                                                      AND ObjectCostLink_5.DescId             = inDescId_5
                                                                      AND ObjectCostLink_5.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_5.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                          );
     ELSE
     IF inDescId_4  IS NOT NULL
     THEN
         vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectId           = inObjectId_4
                                                                      AND ObjectCostLink_4.DescId             = inDescId_4
                                                                      AND ObjectCostLink_4.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_4.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                          );
     ELSE
     IF inDescId_3  IS NOT NULL
     THEN
         vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                               JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectId           = inObjectId_3
                                                                      AND ObjectCostLink_3.DescId             = inDescId_3
                                                                      AND ObjectCostLink_3.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_3.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                          );
     ELSE
     IF inDescId_2  IS NOT NULL
     THEN
         vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                               JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectId           = inObjectId_2
                                                                      AND ObjectCostLink_2.DescId             = inDescId_2
                                                                      AND ObjectCostLink_2.ObjectCostDescId   = inObjectCostDescId
                                                                      AND ObjectCostLink_2.ObjectCostId       = ObjectCostLink_1.ObjectCostId
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                          );
     ELSE
     IF inDescId_1  IS NOT NULL
     THEN
         vbObjectCostId:=(SELECT ObjectCostLink_1.ObjectCostId
                          FROM ObjectCostLink AS ObjectCostLink_1
                           WHERE ObjectCostLink_1.ObjectId = inObjectId_1
                             AND ObjectCostLink_1.DescId = inDescId_1
                             AND ObjectCostLink_1.ObjectCostDescId = inObjectCostDescId
                           limit 1
                          );
     END IF; -- 1
     END IF; -- 2
     END IF; -- 3
     END IF; -- 4
     END IF; -- 5
     END IF; -- 6
     END IF; -- 7
     END IF; -- 8
     END IF; -- 9
     END IF; -- 10

     EXCEPTION
              WHEN invalid_row_count_in_limit_clause
              THEN RAISE EXCEPTION 'Ошибка lpInsertFind_ObjectCost_OLD : vbObjectCostId = "%", inObjectCostDescId = "%", inDescId_1 = "%", inObjectId_1 = "%", inDescId_2 = "%", inObjectId_2 = "%", inDescId_3 = "%", inObjectId_3 = "%", inDescId_4 = "%", inObjectId_4 = "%", inDescId_5 = "%", inObjectId_5 = "%", inDescId_6 = "%", inObjectId_6 = "%", inDescId_7 = "%", inObjectId_7 = "%", inDescId_8 = "%", inObjectId_8 = "%", inDescId_9 = "%", inObjectId_9 = "%", inDescId_10 = "%", inObjectId_10 = "%"', vbObjectCostId, inObjectCostDescId, inDescId_1, inObjectId_1, inDescId_2, inObjectId_2, inDescId_3, inObjectId_3, inDescId_4, inObjectId_4, inDescId_5, inObjectId_5, inDescId_6, inObjectId_6, inDescId_7, inObjectId_7, inDescId_8, inObjectId_8, inDescId_9, inObjectId_9, inDescId_10, inObjectId_10;
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

-- if vbObjectCostId <> 796 then
-- RAISE EXCEPTION 'lpInsertFind_ObjectCost_OLD';
-- end if;

     -- Возвращаем значение
     RETURN (vbObjectCostId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_ObjectCost_OLD (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.03.14                                        * удаление из таблицы - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 19.09.13                                        * optimize
 10.07.13                                        *
*/

-- тест
/*
SELECT * FROM lpInsertFind_ObjectCost_OLD (inObjectCostDescId:= zc_ObjectCost_Basis()
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
SELECT min (ObjectCostLink_1.ObjectCostId) as ObjectCostId1
      , max (ObjectCostLink_1.ObjectCostId) as ObjectCostId2
      , ObjectCostLink_1.DescId  , ObjectCostLink_1.ObjectId
      , ObjectCostLink_2.DescId  , ObjectCostLink_2.ObjectId
      , ObjectCostLink_3.DescId  , ObjectCostLink_3.ObjectId
      , ObjectCostLink_4.DescId  , ObjectCostLink_4.ObjectId
      , ObjectCostLink_5.DescId  , ObjectCostLink_5.ObjectId
      , ObjectCostLink_6.DescId  , ObjectCostLink_6.ObjectId
      , ObjectCostLink_7.DescId  , ObjectCostLink_7.ObjectId
      , ObjectCostLink_8.DescId  , ObjectCostLink_8.ObjectId
      , ObjectCostLink_9.DescId  , ObjectCostLink_9.ObjectId
      , ObjectCostLink_10.DescId  , ObjectCostLink_10.ObjectId
                          FROM (select * from(select ContainerObjectCost.ObjectCostId
                                     , min(ObjectCostLink1.DescId) as DescId1
                                     , min(ObjectCostLink2.DescId) as DescId2
                                     , min(ObjectCostLink3.DescId) as DescId3
                                     , min(ObjectCostLink4.DescId) as DescId4
                                     , min(ObjectCostLink5.DescId) as DescId5
                                     , min(ObjectCostLink6.DescId) as DescId6
                                     , min(ObjectCostLink7.DescId) as DescId7 
                                     , min(ObjectCostLink8.DescId) as DescId8
                                     , min(ObjectCostLink9.DescId) as DescId9
                                     , min(ObjectCostLink10.DescId) as DescId10
                                from ObjectCostLink as ContainerObjectCost
                                     left join ObjectCostLink as ObjectCostLink1 on ObjectCostLink1.ObjectCostId = ContainerObjectCost.ObjectCostId
                                     left join ObjectCostLink as ObjectCostLink2 on ObjectCostLink2.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink2.DescId > ObjectCostLink1.DescId
                                     left join ObjectCostLink as ObjectCostLink3 on ObjectCostLink3.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink3.DescId > ObjectCostLink2.DescId
                                     left join ObjectCostLink as ObjectCostLink4 on ObjectCostLink4.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink4.DescId > ObjectCostLink3.DescId
                                     left join ObjectCostLink as ObjectCostLink5 on ObjectCostLink5.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink5.DescId > ObjectCostLink4.DescId
                                     left join ObjectCostLink as ObjectCostLink6 on ObjectCostLink6.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink6.DescId > ObjectCostLink5.DescId
                                     left join ObjectCostLink as ObjectCostLink7 on ObjectCostLink7.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink7.DescId > ObjectCostLink6.DescId
                                     left join ObjectCostLink as ObjectCostLink8 on ObjectCostLink8.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink8.DescId > ObjectCostLink7.DescId
                                     left join ObjectCostLink as ObjectCostLink9 on ObjectCostLink9.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink9.DescId > ObjectCostLink8.DescId
                                     left join ObjectCostLink as ObjectCostLink10 on ObjectCostLink10.ObjectCostId = ContainerObjectCost.ObjectCostId and ObjectCostLink10.DescId > ObjectCostLink9.DescId
 -- where ContainerObjectCost.ObjectCostId in ( 928, 1252)
                                group by ContainerObjectCost.ObjectCostId
                               ) as tmp
                                -- where DescId10 is null and DescId9 is not null -- and DescId8 is not null
--                                  and DescId9 is null
--                                  and DescId9 is null
 
                              ) as ContainerObjectCost
                               left JOIN ObjectCostLink AS ObjectCostLink_1 ON ObjectCostLink_1.ObjectCostDescId   = 1
                                                                      AND ObjectCostLink_1.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                      AND ObjectCostLink_1.DescId             = ContainerObjectCost.DescId1
                               left JOIN ObjectCostLink AS ObjectCostLink_2 ON ObjectCostLink_2.ObjectCostDescId   = 1
                                                                      AND ObjectCostLink_2.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                      AND ObjectCostLink_2.DescId             = ContainerObjectCost.DescId2
                               left JOIN ObjectCostLink AS ObjectCostLink_3 ON ObjectCostLink_3.ObjectCostDescId   = 1
                                                                      AND ObjectCostLink_3.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                      AND ObjectCostLink_3.DescId             = ContainerObjectCost.DescId3
                               left JOIN ObjectCostLink AS ObjectCostLink_4 ON ObjectCostLink_4.ObjectCostDescId   = 1
                                                                      AND ObjectCostLink_4.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                      AND ObjectCostLink_4.DescId             = ContainerObjectCost.DescId4
                               left JOIN ObjectCostLink AS ObjectCostLink_5 ON ObjectCostLink_5.ObjectCostDescId   = 1
                                                                      AND ObjectCostLink_5.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                      AND ObjectCostLink_5.DescId             = ContainerObjectCost.DescId5
                               left JOIN ObjectCostLink AS ObjectCostLink_6 ON ObjectCostLink_6.ObjectCostDescId   = 1
                                                                      AND ObjectCostLink_6.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                      AND ObjectCostLink_6.DescId             = ContainerObjectCost.DescId6
                               left JOIN ObjectCostLink AS ObjectCostLink_7 ON ObjectCostLink_7.ObjectCostDescId   = 1
                                                                      AND ObjectCostLink_7.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                      AND ObjectCostLink_7.DescId             = ContainerObjectCost.DescId7
                               left JOIN ObjectCostLink AS ObjectCostLink_8 ON ObjectCostLink_8.ObjectCostDescId   = 1
                                                                      AND ObjectCostLink_8.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                      AND ObjectCostLink_8.DescId             = ContainerObjectCost.DescId8
                               left JOIN ObjectCostLink AS ObjectCostLink_9 ON ObjectCostLink_9.ObjectCostDescId   = 1
                                                                       AND ObjectCostLink_9.ObjectCostId       = ContainerObjectCost.ObjectCostId
                                                                       AND ObjectCostLink_9.DescId             = ContainerObjectCost.DescId9
                               left JOIN ObjectCostLink AS ObjectCostLink_10 ON ObjectCostLink_10.ObjectCostDescId = 1
                                                                        AND ObjectCostLink_10.ObjectCostId     = ContainerObjectCost.ObjectCostId
                                                                        AND ObjectCostLink_10.DescId             = ContainerObjectCost.DescId10
                           WHERE ObjectCostLink_1.ObjectCostDescId = 1
-- and ObjectCostLink_1.ObjectId = 0 
group by ObjectCostLink_1.DescId  , ObjectCostLink_1.ObjectId
      , ObjectCostLink_2.DescId  , ObjectCostLink_2.ObjectId
      , ObjectCostLink_3.DescId  , ObjectCostLink_3.ObjectId
      , ObjectCostLink_4.DescId  , ObjectCostLink_4.ObjectId
      , ObjectCostLink_5.DescId  , ObjectCostLink_5.ObjectId
      , ObjectCostLink_6.DescId  , ObjectCostLink_6.ObjectId
      , ObjectCostLink_7.DescId  , ObjectCostLink_7.ObjectId
      , ObjectCostLink_8.DescId  , ObjectCostLink_8.ObjectId
      , ObjectCostLink_9.DescId  , ObjectCostLink_9.ObjectId
      , ObjectCostLink_10.DescId  , ObjectCostLink_10.ObjectId
having count (*) > 1
 order by 1

-- select * from Object where id in (7949)
-- select ObjectCostId , descId from ObjectCostLink group by ObjectCostId , descId having count(*) >1 order by 1
*/
