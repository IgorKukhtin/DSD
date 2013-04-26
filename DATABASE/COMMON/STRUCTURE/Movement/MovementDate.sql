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


CREATE INDEX idx_MovementDate_MovementId_DescId_ValueData ON MovementDate(MovementId, DescId, ValueData); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В. 
14.06.02                                       
*/