-- Добавить у документов ссылку на форму для просмотра
DO $$ 
    BEGIN
      IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementDesc') AND Column_Name = lower('FormId'))) THEN
         ALTER TABLE MovementDesc ADD COLUMN FormId integer REFERENCES Object;
      END IF;
    END;
$$;