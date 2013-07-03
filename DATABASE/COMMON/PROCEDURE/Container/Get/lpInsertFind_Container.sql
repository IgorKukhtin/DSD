-- Function: lpInsertFind_Container (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

-- DROP FUNCTION lpInsertFind_Container (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Container(
    IN inContainerDescId         Integer  , -- DescId Остатка
    IN inObjectId                Integer  , -- Счета 
    IN inJuridicalId_basis       Integer  , -- Главное юридическое лицо
    IN inBusinessId              Integer  , -- Бизнесы
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
BEGIN

   -- таблица - Аналитики остатка
   -- CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;

   DELETE FROM _tmpContainer;

   -- заполняем
   INSERT INTO _tmpContainer (DescId, ObjectId)
      SELECT zc_ContainerLinkObject_JuridicalBasis(), inJuridicalId_basis WHERE inContainerDescId = zc_Container_Summ()
     UNION ALL
      SELECT zc_ContainerLinkObject_Business(), inBusinessId WHERE inContainerDescId = zc_Container_Summ()

     UNION ALL
      SELECT inDescId_1, COALESCE (inObjectId_1, 0) WHERE inDescId_1 <> 0
     UNION ALL
      SELECT inDescId_2, COALESCE (inObjectId_2, 0) WHERE inDescId_2 <> 0
     UNION ALL
      SELECT inDescId_3, COALESCE (inObjectId_3, 0) WHERE inDescId_3 <> 0
     UNION ALL
      SELECT inDescId_4, COALESCE (inObjectId_4, 0) WHERE inDescId_4 <> 0
     UNION ALL
      SELECT inDescId_5, COALESCE (inObjectId_5, 0) WHERE inDescId_5 <> 0
     UNION ALL
      SELECT inDescId_6, COALESCE (inObjectId_6, 0) WHERE inDescId_6 <> 0
     UNION ALL
      SELECT inDescId_7, COALESCE (inObjectId_7, 0) WHERE inDescId_7 <> 0
     UNION ALL
      SELECT inDescId_8, COALESCE (inObjectId_8, 0) WHERE inDescId_8 <> 0
     UNION ALL
      SELECT inDescId_9, COALESCE (inObjectId_9, 0) WHERE inDescId_9 <> 0
     UNION ALL
      SELECT inDescId_10, COALESCE (inObjectId_10, 0) WHERE inDescId_10 <> 0
      ;


   -- находим
   SELECT Container.Id INTO vbContainerId
   FROM Container
        JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
        JOIN _tmpContainer ON _tmpContainer.ObjectId = COALESCE (ContainerLinkObject.ObjectId, 0)
                          AND _tmpContainer.DescId = ContainerLinkObject.DescId
   WHERE Container.AccountId = inObjectId
     AND Container.DescId = inContainerDescId;

   -- Если не нашли, добавляем
   IF NOT FOUND
   THEN
       -- добавили Остаток
       INSERT INTO Container (DescId, AccountId)
           VALUES (inContainerDescId, inObjectId) RETURNING Id INTO  vbContainerId;

       -- добавили Аналитики
       INSERT INTO ContainerLinkObject (DescId, ContainerId, ObjectId)
          SELECT DescId, vbContainerId, CASE WHEN ObjectId = 0 THEN NULL ELSE ObjectId END FROM _tmpContainer;

   END IF;  

   -- Возвращаем значение
   RETURN (vbContainerId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

ALTER FUNCTION lpInsertFind_Container (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

 02.07.13                                        * А здорово получилось
*/

-- тест
/*
SELECT * FROM lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                    , inObjectId:= lpInsertFind_Account (inAccountGroupId:= zc_Enum_AccountGroup_20000() -- 20000; "Запасы" -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                       , inAccountDirectionId:= 23581
                                                                       , inInfoMoneyDestinationId:= zc_Enum_InfoMoneyDestination_10100()
                                                                       , inInfoMoneyId:= NULL
                                                                       , inUserId:= 2
                                                                        )
                                    , inJuridicalId_basis:= 23966
                                    , inBusinessId       := 21709
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