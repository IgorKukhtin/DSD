/*
  Создание 
    - таблицы ObjectEnumDesc (связи классов объектов с классами перечислимых типов)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectEnumDesc(
   Id                 INTEGER NOT NULL PRIMARY KEY,
   Code               TVarChar NOT NULL UNIQUE,
   ItemName           TVarChar,
   ObjectDescId       Integer NOT NULL,
   EnumDescId         Integer NOT NULL,
   isManyEnum         TVarChar,

   CONSTRAINT ObjectEnumDesc_ObjectDescId_ObjectDesc FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id),
   CONSTRAINT ObjectEnumDesc_EnumDescId_EnumDesc FOREIGN KEY(EnumDescId) REFERENCES EnumDesc(Id));

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE UNIQUE INDEX ObjectEnumDesc_Code ON ObjectEnumDesc(Code);
CREATE INDEX ObjectEnumDesc_ObjectDescId ON ObjectEnumDesc(ObjectDescId); 
CREATE INDEX ObjectEnumDesc_EnumDescId ON ObjectEnumDesc(EnumDescId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.  
14.06.02                                        
*/
