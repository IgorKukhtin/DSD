/*
  Создание 
    - таблицы ReportContainerLink (Аналитики сущности "Проводки для отчета")
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ReportContainerLink(
   Id                    SERIAL NOT NULL, 
   ReportContainerId     Integer NOT NULL,
   ContainerId           Integer NOT NULL,
   AccountId             Integer NOT NULL,
   AccountKindId         Integer NOT NULL,

   CONSTRAINT pk_ReportContainerLink               PRIMARY KEY (ContainerId, ReportContainerId, AccountKindId),
   CONSTRAINT fk_ReportContainerLink_ContainerId   FOREIGN KEY (ContainerId) REFERENCES Container (Id),
   CONSTRAINT fk_ReportContainerLink_AccountId     FOREIGN KEY (AccountId) REFERENCES Object (Id),
   CONSTRAINT fk_ReportContainerLink_AccountKindId FOREIGN KEY (AccountKindId) REFERENCES Object (Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
-- CREATE INDEX idx_ReportContainerLink_ReportContainerId  ON ReportContainerLink (ReportContainerId);
-- CREATE INDEX idx_ReportContainerLink_AccountId_AccountKindId ON ReportContainerLink (AccountId, AccountKindId);

CREATE INDEX idx_ReportContainerLink_ContainerId_AccountKindId_ReportContainerId  ON ReportContainerLink (ContainerId, AccountKindId, ReportContainerId);
CREATE INDEX idx_ReportContainerLink_ReportContainerId_ContainerId_AccountKindId  ON ReportContainerLink (ReportContainerId, ContainerId, AccountKindId);
CREATE INDEX idx_ReportContainerLink_AccountId ON ReportContainerLink (AccountId); -- констрейнт
CREATE INDEX idx_ReportContainerLink_AccountKindId ON ReportContainerLink (AccountKindId); -- констрейнт
CREATE INDEX idx_ReportContainerLink_MasterkeyValue_ChildkeyValue ON ReportContainerLink (MasterkeyValue,ChildkeyValue); -- констрейнт

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
10.05.15                                         *
03.09.13                         *               -- констрейнт
19.09.02                                         * chage index
03.09.13                                         *
*/
