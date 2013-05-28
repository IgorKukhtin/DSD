/*
  Создание 
    - таблицы Container ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE Container(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER, 
   AccountId             Integer, -- Счет
   Amount                TFloat,

   CONSTRAINT fk_Container_DescId_ContainerDesc FOREIGN KEY(DescId) REFERENCES ContainerDesc(Id),
   CONSTRAINT fk_Container_AccountId_Object FOREIGN KEY(AccountId) REFERENCES Object(Id)
);


/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE INDEX idx_Container_DescId ON Container(DescId); 
CREATE INDEX idx_Container_AccountId_DescId_Id ON Container(AccountId, DescId, Id); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
11.07.02                                         
*/
