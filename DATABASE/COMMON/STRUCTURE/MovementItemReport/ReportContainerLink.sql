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
   isActive              Boolean NOT NULL,

   CONSTRAINT pk_ReportContainerLink              PRIMARY KEY (ContainerId, ReportContainerId, isActive),
   CONSTRAINT fk_ReportContainerLink_ContainerId  FOREIGN KEY (ContainerId) REFERENCES Container (Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE INDEX idx_ReportContainerLink_ReportContainerId  ON ReportContainerLink (ReportContainerId);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.08.13                                        *
*/
