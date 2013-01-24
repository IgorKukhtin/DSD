/*
  Создание 
    - таблицы MovementLinkObjectDesc (классы связей между классами перемещений и классами объектов)
    - связей
    - индексов
*/


      /* если есть такая таблица - удалить ее */
      IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'MovementLinkObjectDesc')
      DROP TABLE MovementLinkObjectDesc
 
/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementLinkObjectDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY NONCLUSTERED IDENTITY (1,1), 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar,
   ParentMovementDescId  INTEGER,
   ChildObjectDescId     INTEGER,
 

   CONSTRAINT MovementLinkObjectDesc_ParentMovementDescId_MovementDesc FOREIGN KEY(ParentMovementDescId) REFERENCES MovementDesc(Id),
   CONSTRAINT MovementLinkObjectDesc_ChildObjectDescId_ObjectDesc FOREIGN KEY(ChildObjectDescId) REFERENCES ObjectDesc(Id))


/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



CREATE UNIQUE CLUSTERED INDEX MovementLinkObjectDesc_Code ON MovementLinkObjectDesc(Code) 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Тараненко А.Е.   Беленогов С.Б.
18.06.02                                              *
*/
