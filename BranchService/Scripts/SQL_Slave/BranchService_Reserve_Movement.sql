/*
  Создание 
    - таблицы _replica.BranchService_Reserve_Movement (Резерв ID и InvNumber для таблицы Movement)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.BranchService_Reserve_Movement(
   DescId     integer   NOT NULL, -- DesecId - для InvNumber 
                                  --       0 - Movement
                                  --      -1 - MovementItem

   Id         INTEGER NOT NULL, 
   
   
   isUsed     boolean   NOT NULL DEFAULT False,  -- Использовано
   isSend     boolean   NOT NULL DEFAULT False,  -- Документ отправлен

   CONSTRAINT pk_BranchService_Reserve_Movement  PRIMARY KEY (DescId, Id)
   );

CREATE INDEX IF NOT EXISTS idx_BranchService_Reserve_Movement_Used_DescId_Id ON _replica.BranchService_Reserve_Movement (isUsed, DescId, Id); 

/*-------------------------------------------------------------------------------*/

-- Добавление полей
DO $$
BEGIN


  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_Reserve_Movement' AND c.column_name ILIKE 'DescId')
  THEN
    ALTER TABLE _replica.BranchService_Reserve_Movement ADD DescId  integer   NOT NULL;
  END IF;

END $$; 

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Шаблий О.В.
 10.04.23                                          * 
*/