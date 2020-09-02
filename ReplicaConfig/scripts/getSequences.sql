SELECT 
    col.table_schema, 
    col.table_name, 
    col.column_name, 
    seq.sequence_name
FROM information_schema.columns col
    INNER JOIN information_schema.sequences seq ON col.table_schema || '.' || seq.sequence_name = pg_get_serial_sequence(col.table_name, col.column_name)
WHERE col.table_schema = 'public'

