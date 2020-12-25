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
   CONSTRAINT fk_MovementString_DescId   FOREIGN KEY(DescId) REFERENCES MovementStringDesc(Id),
   CONSTRAINT fk_MovementString_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE UNIQUE INDEX idx_MovementString_MovementId_DescId ON MovementString (MovementId, DescId);
CREATE INDEX idx_MovementString_ValueData_DescId ON MovementString (ValueData, DescId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
14.06.2013
*/