/*
  ALTER
    - таблица Employees_new
    - Создание индексов
*/


/*-------------------------------------------------------------------------------*/
CREATE TABLE Employees_new(
   ExtId     Character Varying(100) NOT NULL, 
   isNew     Boolean NOT NULL 
   );

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Employees_new_ExtId_isNew ON Employees_new (ExtId, isNew);
CREATE UNIQUE INDEX idx_Employees_new_isNew_ExtId ON Employees_new (isNew, ExtId);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.26                                        *
*/
