/*
  Создание 
    - таблицы ObjectProtocol (протокол)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectProtocol(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   ObjectId              INTEGER,
   UserId                INTEGER,
   OperDate              TDateTime,
   ProtocolData          TBlob, 
   isInsert              Boolean,

   CONSTRAINT fk_ObjectProtocol_ObjectId FOREIGN KEY(ObjectId) REFERENCES Object(Id),
   CONSTRAINT fk_ObjectProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_ObjectProtocol_ObjectId ON ObjectProtocol (ObjectId);
CREATE INDEX idx_ObjectProtocol_UserId ON ObjectProtocol (UserId);
CREATE INDEX idx_ObjectProtocol_OperDate ON ObjectProtocol (OperDate);
CREATE INDEX idx_ObjectProtocol_ObjectId_OperDate ON ObjectProtocol (ObjectId, OperDate);


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                           
19.09.02                                                       
*/
