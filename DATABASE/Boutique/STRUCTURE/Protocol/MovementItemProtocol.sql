/*
  Создание 
    - таблицы MovementItemProtocol (протокол)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemProtocol(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   MovementItemId        INTEGER,
   UserId                INTEGER,
   OperDate              TDateTime,
   ProtocolData          TBlob, 
   isInsert              Boolean,

   CONSTRAINT fk_MovementItemProtocol_MovementItemId FOREIGN KEY(MovementItemId) REFERENCES MovementItem(Id),
   CONSTRAINT fk_MovementItemProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_MovementItemProtocol_MovementItemId ON MovementItemProtocol (MovementItemId);
CREATE INDEX idx_MovementItemProtocol_UserId ON MovementItemProtocol (UserId);
CREATE INDEX idx_MovementItemProtocol_OperDate ON MovementItemProtocol (OperDate);


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   

*/
