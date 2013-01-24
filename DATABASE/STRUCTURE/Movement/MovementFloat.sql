/*
  Создание 
    - таблицы MovementFloat (свойства перемещений типа TFloat)
    - связи
    - индексов
*/


      /* если есть такая таблица - удалить ее */
      IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MovementFloat')
      DROP TABLE MovementFloat

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementFloat(
   Id           INTEGER NOT NULL PRIMARY KEY NONCLUSTERED IDENTITY (1,1),
   DescId       INTEGER NOT NULL,
   MovementId   INTEGER NOT NULL,
   ValueData    TFloat,

   CONSTRAINT MovementFloat_DescId_MovementFloatDesc FOREIGN KEY(DescId) REFERENCES MovementFloatDesc(Id),
   CONSTRAINT MovementFloat_MovementId_Movement FOREIGN KEY(MovementId) REFERENCES Movement(Id) )

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE NONCLUSTERED INDEX MovementFloat_DescId ON MovementFloat(DescId) 
CREATE NONCLUSTERED INDEX MovementFloat_MovementId ON MovementFloat(MovementId) 


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Тараненко А.Е.   Беленогов С.Б.
18.06.02                                              *
*/
