/*
  Создание 
    - таблицы _replica.BranchService_Settings (Настройки службы филиала)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.BranchService_Settings(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   
   ReplServerId          Integer,     --    
   
   DateSnapshot          TIMESTAMP WITHOUT TIME ZONE,   -- Дата переноса данных (снапшот)

   DateSend              TIMESTAMP WITHOUT TIME ZONE,   -- Дата начала отправки данных
   SendLastId            BIGINT,                        -- Id последней строки лога изменений отправки слейва

   DateEqualization      TIMESTAMP WITHOUT TIME ZONE,   -- Дата начала получения изменений
   EqualizationLastId    BIGINT,                        -- Id последней строки лога изменений отправки мастера

   RecordStep            Integer NOT NULL DEFAULT 10000,-- Обрабатывать записей за раз

   OffsetTimeEnd         Integer NOT NULL DEFAULT 10    -- Смещение времени конца синхронизации
      
   );

/*-------------------------------------------------------------------------------*/

-- Добавление полей
DO $$
BEGIN

  
  IF NOT EXISTS(SELECT * FROM information_schema.columns c 
                WHERE c.table_schema = '_replica' AND c.table_name ILIKE 'BranchService_Settings' AND c.column_name ILIKE 'RecordStep')
  THEN
    ALTER TABLE _replica.BranchService_Settings ADD RecordStep            Integer NOT NULL DEFAULT 10000;
  END IF;

  IF NOT EXISTS(SELECT * FROM _replica.BranchService_Settings)
  THEN
    INSERT INTO _replica.BranchService_Settings (Id) VALUES (1);
  END IF;

END $$; 

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Шаблий О.В.
 02.03.23                                          * 
*/