-- Function: _replica.gpInsert_Errors()

DROP FUNCTION IF EXISTS _replica.gpInsert_Errors (Integer, Integer, Integer, Bigint, Text);
DROP FUNCTION IF EXISTS _replica.gpInsert_Errors (Integer, Bigint, Bigint, Bigint, Text);

CREATE OR REPLACE FUNCTION _replica.gpInsert_Errors (
    IN inStep            Integer, -- шаг, на котором возникла ошибка (1,2 или 3)
    IN inStart_Id        Bigint, -- начальный ID пакета
    IN inLast_Id         Bigint, -- конечный ID пакета
    IN inClient_Id       Bigint,  -- slave._replica.Settings.Client_Id
    IN inErrDescription  Text     -- текст ошибки
)
RETURNS VOID 
AS
$BODY$      
BEGIN
    INSERT INTO _replica.Errors
           (Step,   Start_Id,   Last_Id,   Client_Id,   Description) 
    VALUES (inStep, inStart_Id, inLast_Id, inClient_Id, inErrDescription);
END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;     

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.Г.
 17.08.20                                                          *              
*/

-- тест
-- SELECT _replica.gpInsert_Errors (inStep:= 1, inStart_Id:= 1, inLast_Id:= 1, inClient_Id:= 1, inErrDescription:= 'test error')