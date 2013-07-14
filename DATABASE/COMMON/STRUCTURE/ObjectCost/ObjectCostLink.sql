/*
  Создание 
    - таблицы ObjectCostLink (Аналитики сущности "элемент с/с.")
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectCostLink(
   DescId                INTEGER NOT NULL,
   ObjectCostDescId      INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,
   ObjectCostId          INTEGER NOT NULL,

   CONSTRAINT pk_ObjectCostLink                    PRIMARY KEY (ObjectCostId, ObjectId, DescId, ObjectCostDescId),
   CONSTRAINT fk_ObjectCostLink_DescId             FOREIGN KEY(DescId) REFERENCES ObjectCostLinkDesc(Id),
   CONSTRAINT fk_ObjectCostLink_ObjectCostDescId   FOREIGN KEY(ObjectCostDescId) REFERENCES ObjectCostDesc(Id));
--   CONSTRAINT fk_ObjectCostLink_ObjectId           FOREIGN KEY(ObjectId) REFERENCES Object(Id));
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_ObjectCostLink_ObjectId_DescId  ON ObjectCostLink(ObjectId, DescId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
14.07.13              * rem fk_ObjectCostLink_ObjectId
11.07.13                               *       
*/
