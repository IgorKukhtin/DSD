/*
  Создание 
    - таблицы MovementItemBoolean (свойства объектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemBoolean(
   DescId                INTEGER NOT NULL,
   MovementItemId            INTEGER NOT NULL,
   ValueData             Boolean,

   CONSTRAINT pk_MovementItemBoolean          PRIMARY KEY (MovementItemId, DescId),
   CONSTRAINT fk_MovementItemBoolean_DescId   FOREIGN KEY(DescId) REFERENCES MovementItemBooleanDesc(Id),
   CONSTRAINT fk_MovementItemBoolean_MovementItemId FOREIGN KEY(MovementItemId) REFERENCES MovementItem(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE UNIQUE INDEX idx_MovementItemBoolean_MovementItemId_DescId_ValueData ON MovementItemBoolean (MovementItemId, DescId, ValueData);
CREATE INDEX idx_MovementItemBoolean_ValueData_DescId ON MovementItemBoolean (ValueData, DescId);


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
14.06.02
*/