-- Function: _replica.gpSelect_Errors()

DROP FUNCTION IF EXISTS _replica.gpSelect_Errors ();

CREATE OR REPLACE FUNCTION _replica.gpSelect_Errors (
)
RETURNS TABLE (Step           Integer, -- шаг, на котором возникла ошибка (1,2 или 3) 
               Start_Id       Bigint, -- начальный ID пакета
               Last_Id        Bigint, -- конечный ID пакета
               Client_Id      Bigint , -- slave._replica.Settings.Client_Id
               Description    Text     -- текст ошибки
)    
AS
$BODY$      
BEGIN
    RETURN QUERY
        SELECT Err.Step, Err.Start_Id, Err.Last_Id, Err.Client_Id, Err.Description  
        FROM   _replica.errors
          AS   Err;
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 27.08.20                                                          *              
*/

-- тест
-- SELECT * FROM _replica.gpSelect_Errors ()
