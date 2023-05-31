/*
  Создание 
    - таблицы BranchService_Equalization_Id (Перечень ID для текущего уравнивания)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.BranchService_Equalization_Id(
   ReplServerId   INTEGER   NOT NULL, -- Филиал

   Id             BIGINT    NOT NULL, 

   Transaction_Id BIGINT,
   Table_Name     TEXT,

   ValueId        Integer,
   DescId         Integer,
   Last_Modified  TIMESTAMP WITHOUT TIME ZONE,

   isInsert       Boolean    NOT NULL DEFAULT False,    
   
   CONSTRAINT pk_BranchService_Equalization_Id  PRIMARY KEY (ReplServerId, Id)
   );

/*-------------------------------------------------------------------------------*/

-- Добавление полей
DO $$
BEGIN


  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_Equalization_Id' AND c.column_name ILIKE 'isInsert')
  THEN
    ALTER TABLE _replica.BranchService_Equalization_Id ADD isInsert Boolean NOT NULL DEFAULT False;
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