/*
  Создание 
    - таблицы MovementBoolean (свойства объектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementBoolean(
   DescId                INTEGER NOT NULL,
   MovementId            INTEGER NOT NULL,
   ValueData             Boolean,

   CONSTRAINT pk_MovementBoolean          PRIMARY KEY (MovementId, DescId),
   CONSTRAINT pk_MovementBoolean_DescId   FOREIGN KEY(DescId) REFERENCES MovementBooleanDesc(Id),
   CONSTRAINT pk_MovementBoolean_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE INDEX idx_MovementBoolean_MovementId_DescId_ValueData ON MovementBoolean (MovementId, DescId, ValueData);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
14.06.02
*/