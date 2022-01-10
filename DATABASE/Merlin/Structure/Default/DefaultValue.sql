/*
  Создание 
    - таблицы DefaultValue (протокол)
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE DefaultValue(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DefaultKeyId          INTEGER,
   UserKeyId             INTEGER,
   DefaultValue          TBlob, 

   CONSTRAINT fk_DefaultValue_DefaultKeyId FOREIGN KEY(DefaultKeyId) REFERENCES DefaultKeys(Id),
   CONSTRAINT fk_DefaultValue_UserKeyId FOREIGN KEY(UserKeyId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_DefaultValue_DefaultKeyId_UserId ON DefaultValue (DefaultKeyId, UserKeyId);


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
26.09.13                              *                         
*/
