/*
  Создание 
    - таблицы _replica.MovementProtocol_Rewiring (Данные для перепроводки по MovementItemContainer)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.MovementProtocol_Rewiring(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Transaction_Id        BIGINT,

   MovementId            INTEGER,
   UserId                INTEGER,
   OperDate              TDateTime,
   ProtocolData          TBlob, 
   isInsert              Boolean,

   CONSTRAINT fk_MovementProtocol_Rewiring_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementProtocol_Rewiring_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX IF NOT EXISTS idx_MovementProtocol_Rewiring_MovementId ON _replica.MovementProtocol_Rewiring (MovementId);
CREATE INDEX IF NOT EXISTS idx_MovementProtocol_Rewiring_Transaction_Id ON _replica.MovementProtocol_Rewiring (Transaction_Id);


/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Шаблий О.В.
 19.09.23                                          * 
*/