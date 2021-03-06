-- Создание - таблицы MovementItemContainer + связей + индексов

-------------------------------------------------------------------------------

CREATE TABLE MovementItemContainer(
   Id             BIGSERIAL NOT NULL PRIMARY KEY, 
   DescId         Integer   NOT NULL,
   MovementId     Integer   NOT NULL,
   ContainerId    Integer   NOT NULL,
   Amount         TFloat    NOT NULL,
   OperDate       TDateTime NOT NULL,
   MovementItemId Integer       NULL,
   ParentId       BigInt        NULL,
   isActive       Boolean   NOT NULL,

   MovementDescId          Integer NOT NULL, -- Вид документа
   AnalyzerId              Integer     NULL, -- Типы аналитик (проводки)
   AccountId               Integer     NULL, -- Счет
   ObjectId_analyzer       Integer NOT NULL, -- MovementItem.ObjectId
   PartionId               Integer     NULL, -- MovementItem.PartionId
   WhereObjectId_analyzer  Integer     NULL, -- Место учета
   AccountId_analyzer      Integer     NULL, -- Счет - корреспондент

   ContainerId_analyzer    Integer     NULL, -- Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
   ContainerExtId_analyzer Integer     NULL, -- Контейнер - Корреспондент

   ObjectIntId_analyzer    Integer     NULL, -- Аналитический справочник (Размер, УП статья или что-то особенное - т.е. все то что не вписалось в аналитики выше)
   ObjectExtId_analyzer    Integer     NULL, -- Аналитический справочник (Подразделение - корреспондент, Подразделение ЗП, ФИО, Контрагент и т.д. - т.е. все то что не вписалось в аналитики выше)
   
   CONSTRAINT fk_MovementItemContainer_DescId            FOREIGN KEY (DescId)             REFERENCES MovementItemContainerDesc(Id),
   CONSTRAINT fk_MovementItemContainer_MovementDescId    FOREIGN KEY (MovementDescId)     REFERENCES MovementDesc(Id),
   CONSTRAINT fk_MovementItemContainer_MovementId        FOREIGN KEY (MovementId)         REFERENCES Movement(Id),
   CONSTRAINT fk_MovementItemContainer_MovementItemId    FOREIGN KEY (MovementItemId)     REFERENCES MovementItem(Id),
   CONSTRAINT fk_MovementItemContainer_ContainerId       FOREIGN KEY (ContainerId)        REFERENCES Container(Id),
   CONSTRAINT fk_MovementItemContainer_ParentId          FOREIGN KEY (ParentId)           REFERENCES MovementItemContainer(Id),
   CONSTRAINT fk_MovementItemContainer_ObjectId_analyzer FOREIGN KEY (ObjectId_analyzer)  REFERENCES Object(Id),
   CONSTRAINT fk_MovementItemContainer_PartionId         FOREIGN KEY (PartionId)          REFERENCES Object_PartionGoods(MovementItemId)
);

-------------------------------------------------------------------------------

-- Индексы
CREATE INDEX idx_MovementItemContainer_MovementId_DescId             ON MovementItemContainer (MovementId, DescId);
CREATE INDEX idx_MovementItemContainer_ContainerId                   ON MovementItemContainer (ContainerId);
CREATE INDEX idx_MovementItemContainer_ContainerId_OperDate          ON MovementItemContainer (ContainerId, OperDate);
CREATE INDEX idx_MovementItemContainer_ContainerId_Analyzer_OperDate ON MovementItemContainer (ContainerId_Analyzer, OperDate);
CREATE INDEX idx_MovementItemContainer_AnalyzerId_OperDate           ON MovementItemContainer (AnalyzerId, OperDate);
CREATE INDEX idx_MovementItemContainer_PartionId_OperDate            ON MovementItemContainer (PartionId, OperDate);

CREATE INDEX idx_MovementItemContainer_OperDate_DescId_MovementDescId_WhereObjectId_Analyzer ON MovementItemContainer (OperDate,DescId,MovementDescId,WhereObjectId_Analyzer);
-- !!! CREATE INDEX idx_MovementItemContainer_ContainerId_OperDate_DescId ON MovementItemContainer (ContainerId, OperDate, DescId);
-- !!! CREATE INDEX idx_MovementItemContainer_ContainerId_DescId_OperDate ON MovementItemContainer (ContainerId, DescId, OperDate);
-- CREATE INDEX idx_MovementItemContainer_ContainerId_DescId_OperDate_Amount ON MovementItemContainer (ContainerId, DescId, OperDate, Amount);
-- CREATE INDEX idx_MovementItemContainer_ObjectId_Analyzer_OperDate_AnalyzerId ON MovementItemContainer (ObjectId_Analyzer_OperDate, AnalyzerId);

CREATE INDEX idx_MovementItemContainer_MovementItemId    ON MovementItemContainer (MovementItemId);
CREATE INDEX idx_MovementItemContainer_ParentId          ON MovementItemContainer (ParentId);
CREATE INDEX idx_MovementItemContainer_PartionId         ON MovementItemContainer (PartionId);

-- CREATE INDEX idx_MovementItemContainer_ObjectId_analyzer ON MovementItemContainer (ObjectId_analyzer);
CREATE INDEX idx_MovementItemContainer_ObjectId_Analyzer_AnalyzerId ON MovementItemContainer (ObjectId_Analyzer, AnalyzerId);

-- 
-- !!!FARMACY!!!!
-- CREATE INDEX idx_MovementItemContainer_ObjectIntId_analyzer ON MovementItemContainer (ObjectIntId_analyzer);
-- !!!FARMACY!!!!
-- CREATE INDEX idx_MovementItemContainer_AnalyzerId ON MovementItemContainer (AnalyzerId);
-- 


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.15                                        * add idx_MovementItemContainer_OperDate_DescId_MovementDescId_WhereObjectId_Analyzer
 20.12.14                                        * add idx_MovementItemContainer_ContainerId_Analyzer_OperDate
 18.12.14                                        * add idx_MovementItemContainer_AnalyzerId_OperDate
 18.12.14                                        * add idx_MovementItemContainer_ContainerId_OperDate + del idx_MovementItemContainer_ContainerId_OperDate_DescId + del idx_MovementItemContainer_ContainerId_DescId_OperDate
 26.10.14                                        * add idx_MovementItemContainer_ContainerId_OperDate_DescId AND idx_MovementItemContainer_ContainerId_DescId_OperDate
 26.10.14                                        * add index ???idx_MovementItemContainer_MovementItemId???
 26.10.14                                        * drop index idx_movementitemcontainer_containerid_descid_operdate_amount
 30.08.13                                        * 1251Cyr
*/
