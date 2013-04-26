/*
  Создание 
    - таблицы MovementFloat (свойства oбъектов типа TFloat)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementFloat(
   DescId     INTEGER NOT NULL,
   MovementId   INTEGER NOT NULL,
   ValueData  TFloat,

   CONSTRAINT pk_MovementFloat          PRIMARY KEY (MovementId, DescId),
   CONSTRAINT fk_MovementFloat_DescId   FOREIGN KEY(DescId)   REFERENCES MovementFloatDesc(Id),
   CONSTRAINT fk_MovementFloat_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE INDEX idx_MovementFloat_MovementId_DescId_ValueData ON MovementFloat(MovementId, DescId, ValueData); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В. 
14.06.02                                       
*/