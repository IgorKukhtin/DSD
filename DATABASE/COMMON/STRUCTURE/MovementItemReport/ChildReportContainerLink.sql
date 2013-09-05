/*
  Создание 
    - таблицы ChildReportContainerLink (Аналитики сущности "Проводки для отчета")
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ChildReportContainerLink(
   Id                     SERIAL NOT NULL, 
   ChildReportContainerId Integer NOT NULL,
   ContainerId            Integer NOT NULL,
   AccountId              Integer NOT NULL,
   AccountKindId          Integer NOT NULL,

   CONSTRAINT pk_ChildReportContainerLink               PRIMARY KEY (ContainerId, ChildReportContainerId, AccountKindId),
   CONSTRAINT fk_ChildReportContainerLink_ContainerId   FOREIGN KEY (ContainerId) REFERENCES Container (Id),
   CONSTRAINT fk_ChildReportContainerLink_AccountId     FOREIGN KEY (AccountId) REFERENCES Object (Id),
   CONSTRAINT fk_ChildReportContainerLink_AccountKindId FOREIGN KEY (AccountKindId) REFERENCES Object (Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE INDEX idx_ChildReportContainerLink_ChildReportContainerId ON ChildReportContainerLink (ChildReportContainerId);
CREATE INDEX idx_ChildReportContainerLink_AccountId_AccountKindId ON ChildReportContainerLink (AccountId, AccountKindId);
CREATE INDEX idx_ChildReportContainerLink_ContainerId_AccountKindId ON ChildReportContainerLink (ContainerId, AccountKindId);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.09.13                                        *
*/
