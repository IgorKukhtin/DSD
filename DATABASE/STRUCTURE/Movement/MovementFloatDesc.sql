/*
  Создание 
    - таблицы MovementFloatDesc (свойства классов перемещений типа TFloat)
    - связей
    - индексов
*/

        /* если есть такая таблица - удалить ее */
	IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MovementFloatDesc')
	DROP TABLE MovementFloatDesc


/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementFloatDesc(
   Id              INTEGER NOT NULL PRIMARY KEY NONCLUSTERED IDENTITY (1,1),
   MovementDescId  INTEGER,
   Code            TVarChar NOT NULL UNIQUE,
   ItemName        TVarChar,

   CONSTRAINT MovementFloatDesc_MovementDescId_MovementDesc FOREIGN KEY(MovementDescId) REFERENCES MovementDesc(Id) )


/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */



CREATE UNIQUE CLUSTERED INDEX MovementFloatDesc_Code ON MovementFloatDesc(Code) 


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Тараненко А.Е.   Беленогов С.Б.
18.06.02                                               *               
*/
