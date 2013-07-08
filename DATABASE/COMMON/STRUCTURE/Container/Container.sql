/*
  Создание 
    - таблицы Container ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE Container(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NOT NULL, 
   ObjectId              Integer NOT NULL, -- Счет
   Amount                TFloat  NOT NULL DEFAULT 0,

   CONSTRAINT fk_Container_DescId_ContainerDesc FOREIGN KEY(DescId) REFERENCES ContainerDesc(Id),
   CONSTRAINT fk_Container_ObjectId_Object FOREIGN KEY(ObjectId) REFERENCES Object(Id)
);


/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE INDEX idx_Container_DescId ON Container(DescId); 
CREATE INDEX idx_Container_ObjectId_DescId_Id ON Container(ObjectId, DescId, Id); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
11.07.02                                         
*/
