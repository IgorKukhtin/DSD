/*
  Создание 
    - таблицы ObjectStringHistoryDesc (свойства классов oбъектов типа TString)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectHistoryStringDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectHistoryStringDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectHistoryDesc(Id) );

                                     

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



/*-------------------------------------------------------------------------------
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 29.06.13             * SERIAL
*/
