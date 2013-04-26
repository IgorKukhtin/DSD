/*
  Создание 
    - таблицы MovementString (свойства объектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementString(
   DescId                INTEGER NOT NULL,
   MovementId              INTEGER NOT NULL,
   ValueData             TVarChar,

   CONSTRAINT pk_MovementString          PRIMARY KEY (MovementId, DescId),
   CONSTRAINT pk_MovementString_DescId   FOREIGN KEY(DescId) REFERENCES MovementStringDesc(Id),
   CONSTRAINT pk_MovementString_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE INDEX idx_MovementString_MovementId_DescId_ValueData ON MovementString (MovementId, DescId, ValueData);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
14.06.02
*/