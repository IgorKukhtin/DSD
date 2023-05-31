/*
  Создание 
    - таблицы _replica.BranchService_DescId_Movement (Перечень документов для создания и уравнивания)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.BranchService_DescId_Movement(
   DescId               INTEGER NOT NULL PRIMARY KEY, 
   
   isEqualization       boolean   NOT NULL DEFAULT False,  -- Получать в базу документы
   isInsert             boolean   NOT NULL DEFAULT False,  -- Разрешено создавать

   MovementDescMax      Integer  NOT NULL DEFAULT 300,  -- Резервирование номеров документов под каждый DescId
   MovementDescMin      Integer  NOT NULL DEFAULT 100   -- Минимальное количество номеров под каждый DescId

   );

/*-------------------------------------------------------------------------------*/

-- Добавление полей
DO $$
BEGIN

  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_DescId_Movement' AND c.column_name ILIKE 'MovementDescMax')
  THEN
    ALTER TABLE _replica.BranchService_DescId_Movement ADD MovementDescMax Integer  NOT NULL DEFAULT 300;
  END IF;

  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_DescId_Movement' AND c.column_name ILIKE 'MovementDescMin')
  THEN
    ALTER TABLE _replica.BranchService_DescId_Movement ADD MovementDescMin  Integer  NOT NULL DEFAULT 100;
  END IF;
  
  IF NOT EXISTS (SELECT * FROM _replica.BranchService_DescId_Movement WHERE _replica.BranchService_DescId_Movement.DescId = 0)
  THEN
    INSERT INTO _replica.BranchService_DescId_Movement (DescId, MovementDescMax, MovementDescMin) VALUES (0, 1000, 100);
  END IF;

  IF NOT EXISTS (SELECT * FROM _replica.BranchService_DescId_Movement WHERE _replica.BranchService_DescId_Movement.DescId = -1)
  THEN
    INSERT INTO _replica.BranchService_DescId_Movement (DescId, MovementDescMax, MovementDescMin) VALUES (-1, 3000, 300);
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