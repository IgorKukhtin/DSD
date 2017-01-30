/*
  Создание 
    - таблицы MovementProtocol (протокол)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementProtocol(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   MovementId            INTEGER,
   UserId                INTEGER,
   OperDate              TDateTime,
   ProtocolData          TBlob, 
   isInsert              Boolean,

   CONSTRAINT fk_MovementProtocol_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_MovementProtocol_MovementId ON MovementProtocol (MovementId);
CREATE INDEX idx_MovementProtocol_UserId ON MovementProtocol (UserId);
CREATE INDEX idx_MovementProtocol_OperDate ON MovementProtocol (OperDate);


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   

*/
