-- Function: lpInsertFind_Object_InvNumberTax

DROP FUNCTION IF EXISTS lpInsertFind_Object_InvNumberTax (Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_InvNumberTax(
    IN inMovementDescId          Integer            , -- 
    IN inOperDate                TDateTime          , -- 
    IN inInvNumber               Integer   DEFAULT 0  -- 
)
  RETURNS Integer AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbObjectCode Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

     -- всегда 1-е число месяца
     vbOperDate:= DATE_TRUNC ('MONTH', inOperDate);

     -- поиск
     vbId:= (SELECT ObjectId FROM ObjectDate WHERE ValueData = vbOperDate AND DescId = zc_ObjectDate_InvNumberTax_Value());

     IF COALESCE (vbId, 0) = 0
     THEN
         -- !!!для скорости - напрямую!!! добавили новый
         INSERT INTO Object (DescId, ObjectCode, ValueData)
            SELECT zc_Object_InvNumberTax(), CASE WHEN inInvNumber <> 0 THEN inInvNumber ELSE 3800 END, '' RETURNING Id, ObjectCode INTO vbId, vbObjectCode;
         -- !!!для скорости - напрямую!!! добавили свойство
         INSERT INTO ObjectDate (DescId, ObjectId, ValueData)
                         VALUES (zc_ObjectDate_InvNumberTax_Value(), vbId, vbOperDate);
     ELSE
         -- изменили на inInvNumber или +1
         UPDATE Object SET ObjectCode = CASE WHEN inInvNumber <> 0 THEN inInvNumber ELSE ObjectCode + 1 END WHERE Id = vbId RETURNING ObjectCode INTO vbObjectCode;
     END IF;

     -- проверили
     IF 1 <> (SELECT COUNT(*) FROM ObjectDate WHERE ValueData = vbOperDate AND DescId = zc_ObjectDate_InvNumberTax_Value())
     THEN
         RAISE EXCEPTION 'Ошибка.Системная блокировка <Налоговый номер>, <%>.', vbOperDate;
     END IF;


     -- Возвращаем значение
     RETURN (vbObjectCode);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_InvNumberTax (Integer, TDateTime, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.05.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_InvNumberTax (inMovementDescId:= zc_Movement_Tax(), inOperDate:= '01.04.2014', inInvNumber:= 0);
-- SELECT * FROM lpInsertFind_Object_InvNumberTax (inMovementDescId:= zc_Movement_Tax(), inOperDate:= '01.04.2014');
