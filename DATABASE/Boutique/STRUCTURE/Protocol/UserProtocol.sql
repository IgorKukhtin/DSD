/*
  Создание 
    - таблицы UserProtocol (протокол)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE UserProtocol(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   UserId                INTEGER,
   OperDate              TDateTime,
   ProtocolData          TBlob, 

   CONSTRAINT fk_UserProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_UserProtocol_UserId ON UserProtocol (UserId);
CREATE INDEX idx_UserProtocol_OperDate ON UserProtocol (OperDate);


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
