/*
  Создание 
    - таблицы MovementItemString (свойства объектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemString(
   DescId                INTEGER NOT NULL,
   MovementItemId              INTEGER NOT NULL,
   ValueData             TVarChar,

   CONSTRAINT pk_MovementItemString          PRIMARY KEY (MovementItemId, DescId),
   CONSTRAINT fk_MovementItemString_DescId   FOREIGN KEY(DescId) REFERENCES MovementItemStringDesc(Id),
   CONSTRAINT fk_MovementItemString_MovementItemId FOREIGN KEY(MovementItemId) REFERENCES MovementItem(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE UNIQUE INDEX idx_MovementItemString_MovementItemId_DescId ON MovementItemString (MovementItemId, DescId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
14.06.02
*/