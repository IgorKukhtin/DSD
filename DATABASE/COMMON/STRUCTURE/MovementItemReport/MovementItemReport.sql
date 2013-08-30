/*
  Создание 
    - таблицы MovementItemReport - "Проводки для отчета"
    - связей
    - индексов
*/
/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemReport(
   Id                 SERIAL NOT NULL PRIMARY KEY, 
   MovementId         Integer,
   MovementItemId     Integer,
   ReportContainerId  Integer,
   Amount             TFloat, 
   OperDate           TDateTime,

   CONSTRAINT fk_MovementItemReport_MovementId FOREIGN KEY (MovementId) REFERENCES Movement (Id),
   CONSTRAINT fk_MovementItemReport_MovementItemId FOREIGN KEY (MovementItemId) REFERENCES MovementItem (Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE INDEX Idx_MovementItemReport_MovementId ON MovementItemReport (MovementId);
CREATE INDEX Idx_MovementItemReport_ReportContainerId_OperDate_Amount ON MovementItemReport (ReportContainerId, OperDate, Amount);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.08.13                                        *
*/
