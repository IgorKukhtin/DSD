/*
  Создание 
    - таблицы MovementDate (свойства oбъектов типа TDate)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementDate(
   DescId     INTEGER NOT NULL,
   MovementId   INTEGER NOT NULL,
   ValueData  TDateTime,

   CONSTRAINT pk_MovementDate          PRIMARY KEY (MovementId, DescId),
   CONSTRAINT fk_MovementDate_DescId   FOREIGN KEY(DescId)   REFERENCES MovementDateDesc(Id),
   CONSTRAINT fk_MovementDate_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_MovementDate_MovementId_DescId ON MovementDate (MovementId, DescId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.03.2015                                       * add idx_MovementBoolean_MovementId_DescId
14.06.2013                                       
*/