/*
  Создание 
    - таблицы Movement (перемещения)
    - связей
    - индексов
*/


      /* если есть такая таблица - удалить ее */
      IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Movement')
      DROP TABLE Movement


/*-------------------------------------------------------------------------------*/

CREATE TABLE Movement(
   Id           INTEGER NOT NULL PRIMARY KEY NONCLUSTERED  IDENTITY (1,1), 
   InvNumber    INTEGER,
   OperDate     TDateTime, 
   DescId       INTEGER,
   Status       INTEGER,
   InsertUserId INTEGER,
   InsertDate   TDateTime,
   UpdateUserId INTEGER,
   UpdateDate   TDateTime,
   ParentId     Integer,
   isErased     TVarChar,


   CONSTRAINT Movement_DescId_MovementDesc FOREIGN KEY(DescId) REFERENCES MovementDesc(Id),
   CONSTRAINT Movement_Status_Enum FOREIGN KEY(Status) REFERENCES Enum(Id),
   CONSTRAINT Movement_InsertUserId_Object FOREIGN KEY(InsertUserId) REFERENCES Object(Id),
   CONSTRAINT Movement_UpdateUserId_Object FOREIGN KEY(UpdateUserId) REFERENCES Object(Id),
   CONSTRAINT Movement_ParentId_Movement FOREIGN KEY(ParentId) REFERENCES Movement(Id))

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



CREATE NONCLUSTERED INDEX Movement_DescId ON Movement(DescId)
CREATE NONCLUSTERED INDEX Movement_OperDate ON Movement(OperDate)
CREATE NONCLUSTERED INDEX Movement_Status ON Movement(Status)
CREATE NONCLUSTERED INDEX Movement_InsertUserId ON Movement(InsertUserId)
CREATE NONCLUSTERED INDEX Movement_UpdateUserId ON Movement(UpdateUserId)
CREATE NONCLUSTERED INDEX Movement_isErased ON Movement(isErased)
CREATE NONCLUSTERED INDEX Movement_DescId_OperDate_Status ON Movement(DescId, OperDate, Status)


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Тараненко А.Е.   Беленогов С.Б.
18.06.02                                              *  
19.09.02                                              *              
*/
