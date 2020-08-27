-- Function: gpSelect_Sequences()

DROP FUNCTION IF EXISTS gpSelect_Sequences ();

CREATE OR REPLACE FUNCTION gpSelect_Sequences (
)
RETURNS TABLE (SequenceName Text,
               Increment    Integer
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT ISS.Sequence_Name :: Text,
               ISS.Increment :: Integer
        FROM   information_schema.sequences 
          AS   ISS 
        WHERE  sequence_schema = 'public';      
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 27.08.20                                                          *              
*/

-- тест
-- SELECT * FROM gpSelect_Sequences ()