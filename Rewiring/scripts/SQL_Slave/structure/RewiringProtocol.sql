/*
  Создание 
    - таблицы MovementProtocol (протокол)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.RewiringProtocol(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   MovementId            INTEGER,
   Step                  INTEGER,

   Transaction_Id        BIGINT,
   isErrorRewiring       Boolean NOT NULL DEFAULT FALSE,
   OperDate              TDateTime,

   isProcessed           Boolean NOT NULL DEFAULT FALSE,
   DateProcessed         TDateTime,

   ErrorData             TBlob, 

   CONSTRAINT fk_RewiringProtocol_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX IF NOT EXISTS idx_RewiringProtocol_MovementId ON _replica.RewiringProtocol (MovementId);


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Шаблий О.В.
 21.09.23                                          *   

*/
