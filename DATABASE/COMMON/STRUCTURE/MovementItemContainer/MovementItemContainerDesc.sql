/*
  Создание 
    - таблицы MovementItemContainerDesc (классы перемещений)
    - cвязей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemContainerDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar);


/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX MovementItemContainerDesc_Code ON MovementItemContainerDesc(Code);
CLUSTER MovementItemContainerDesc_Code ON MovementItemContainerDesc;  



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.  
18.06.02                                        
19.09.02                                        
*/
