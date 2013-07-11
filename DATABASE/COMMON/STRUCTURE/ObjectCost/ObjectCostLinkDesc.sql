/*
  Создание 
    - таблицы ObjectCostLinkDesc (типы аналитик для расчета с\с)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectCostLinkDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar,
   ItemName              TVarChar,
   ObjectDescId          INTEGER NOT NULL,

   CONSTRAINT fk_ObjectCostDesc_ObjectDescId FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id)
);



/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



/*-------------------------------------------------------------------------------
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 11.07.13             
*/
