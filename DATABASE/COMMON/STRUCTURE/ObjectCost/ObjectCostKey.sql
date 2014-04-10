/*
  Создание 
    - таблицы ObjectCostKey (Ключ для поиска себестоимости)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectCostKey(
   ObjectCostId          INTEGER  NOT NULL,
   Key                   TVarChar NOT NULL, 

   CONSTRAINT pk_ObjectCostKey                     PRIMARY KEY (ObjectCostId)
);
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_ObjectCostKey_Key_ObjectCostId  ON ObjectCostKey (Key, ObjectCostId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
08.04.14                               * 
*/
