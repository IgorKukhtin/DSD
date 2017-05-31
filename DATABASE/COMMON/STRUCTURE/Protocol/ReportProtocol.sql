/*
  Создание 
    - таблицы ReportProtocol (протокол)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ReportProtocol(
   Id                    SERIAL NOT NULL, 
   UserId                INTEGER,
   OperDate              TDateTime,
   ProtocolData          TBlob, 

   CONSTRAINT pk_ReportProtocol PRIMARY KEY (Id),
   CONSTRAINT fk_ReportProtocol_UserId FOREIGN KEY(UserId) REFERENCES Object (Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_ReportProtocol_UserId ON ReportProtocol (UserId);
CREATE INDEX idx_ReportProtocol_OperDate ON ReportProtocol (OperDate DESC);


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Ярошенко Р.Ф.
 31.05.17                                           *
*/
