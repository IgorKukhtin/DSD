/*
  Создание 
    - таблицы MovementDate (свойства перемещений типа TDateTime)
    - связей
    - индексов
*/


      /* если есть такая таблица - удалить ее */
      IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MovementDate')
      DROP TABLE MovementDate


/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementDate(
   Id           INTEGER NOT NULL PRIMARY KEY NONCLUSTERED IDENTITY (1,1),
   DescId       INTEGER NOT NULL,
   MovementId   INTEGER NOT NULL,
   ValueData    TDateTime,
               
   CONSTRAINT MovementDate_DescId_MovementDateDesc FOREIGN KEY(DescId) REFERENCES MovementDateDesc(Id),
   CONSTRAINT MovementDate_MovementId_Movement FOREIGN KEY(MovementId) REFERENCES Movement(Id) )


/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE NONCLUSTERED INDEX MovementDate_DescId ON MovementDate(DescId) 
CREATE NONCLUSTERED INDEX MovementDate_MovementId ON MovementDate(MovementId) 


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Тараненко А.Е.   Беленогов С.Б.
18.06.02                                               *                
*/
