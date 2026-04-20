/*
  Создание 
    - таблица Object_Employees_effie
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/
-- drop table Object_Employees_effie;
-- truncate table Object_Employees_effie;
-- 
CREATE TABLE Object_Employees_effie(
   MemberId               Integer   NOT NULL, 
   isNew                  Boolean   NOT NULL, 
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Object_Employees_effie_MemberId ON Object_Employees_effie (MemberId); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.26                                        *
*/
