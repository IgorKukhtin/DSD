/*
  Создание 
    - таблицы MovementItemDesc (классы перемещений)
    - cвязей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar);


/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX MovementItemDesc_Code ON MovementItemDesc(Code);
CLUSTER MovementItemDesc_Code ON MovementItemDesc;  



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.  
18.06.02                                        
19.09.02                                        
*/
