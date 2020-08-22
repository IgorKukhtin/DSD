-- Function: gpSelect_SequenceNames()

DROP FUNCTION IF EXISTS gpSelect_SequenceNames ();

CREATE OR REPLACE FUNCTION gpSelect_SequenceNames (
)
RETURNS TABLE (SequenceName Text
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT Sequence_Name :: Text 
        FROM   information_schema.sequences
        WHERE  sequence_schema = 'public';      
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 21.08.20                                                          *              
*/

-- тест
-- SELECT * FROM gpSelect_SequenceNames ()