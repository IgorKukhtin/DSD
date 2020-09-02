/* 
  _replica.gpInit_SequencesSlave() - ‘ункци€ обновл€ет все sequences с учетом start_id, 
                                     который заполн€етс€ на мастере в gpInit_SequencesMaster,   
                                     и с учетом digit_for_increment, который формируетс€ при регистрации клиента
                                     в _replica.clients на мастере. “аблицы _replica.table_slave и _replica.clients 
                                     должны быть синхронизированы с мастером
*/
CREATE OR REPLACE FUNCTION _replica.gpInit_SequencesSlave()
RETURNS VOID AS
$BODY$
DECLARE sql TEXT;
DECLARE vbDigitForIncrement INT;
BEGIN
  
  -- проверка start_id 
  IF EXISTS(SELECT * FROM _replica.table_slave WHERE start_id IS NULL) THEN
    RAISE EXCEPTION 'Start_id в таблицу _replica.table_slave не заполнен';
  END IF;
  
  vbDigitForIncrement := (SELECT digit_for_increment FROM _replica.clients WHERE client_id ::Text = (SELECT value FROM _replica.settings WHERE name ILIKE 'client_id'));
  IF vbDigitForIncrement IS NULL THEN
    RAISE EXCEPTION 'ќшибка получени€ digit_for_increment из таблицы _replica.clients';
  END IF;
  
    
  FOR sql IN 
          SELECT
            'ALTER SEQUENCE ' || sequence_name || ' INCREMENT 10 RESTART WITH ' || use_start_id ::TEXT
          FROM (
             SELECT col.table_name, col.column_name, seq.sequence_name, ts.start_id, COALESCE(CEIL(ts.start_id / 10.0) * 10, 0) + vbDigitForIncrement AS use_start_id
             FROM information_schema.columns col
                INNER JOIN information_schema.sequences seq ON col.table_schema || '.' || seq.sequence_name = pg_get_serial_sequence(col.table_name, col.column_name)
                INNER JOIN _replica.table_slave ts ON ts.master_schema = col.table_schema AND ts.master_table = col.table_name
             WHERE col.table_schema = 'public'
            ) sub
  LOOP
    EXECUTE sql;
  END LOOP;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
