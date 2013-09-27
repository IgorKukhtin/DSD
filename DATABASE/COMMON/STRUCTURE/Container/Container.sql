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
   ParentId              Integer NULL,  

   CONSTRAINT fk_Container_DescId_ContainerDesc FOREIGN KEY(DescId) REFERENCES ContainerDesc(Id),
   CONSTRAINT fk_Container_ObjectId_Object FOREIGN KEY(ObjectId) REFERENCES Object(Id),
   CONSTRAINT fk_Container_ParentId_Container FOREIGN KEY(ParentId) REFERENCES Container(Id)
);


/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE INDEX idx_Container_ObjectId_DescId_Id ON Container (ObjectId, DescId, Id);
CREATE INDEX idx_Container_ParentId_ObjectId_DescId_Id ON Container (ParentId, ObjectId, DescId, Id); 
CREATE INDEX idx_Container_Id_ObjectId_DescId ON Container (Id, ObjectId, DescId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
19.09.02              * chage index
18.06.02                                         
11.07.02                                         
*/
