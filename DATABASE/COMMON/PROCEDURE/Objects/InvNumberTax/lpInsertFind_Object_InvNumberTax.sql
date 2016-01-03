-- Function: lpInsertFind_Object_InvNumberTax

DROP FUNCTION IF EXISTS lpInsertFind_Object_InvNumberTax (Integer, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertFind_Object_InvNumberTax (Integer, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_InvNumberTax(
    IN inMovementDescId          Integer            , -- 
    IN inOperDate                TDateTime          , -- 
    IN inInvNumberBranch         TVarChar  , -- Номер филиала
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

     -- с 01.01.2016 деления по филиалам не будет
     IF vbOperDate >= '01.01.2016'
     THEN 
         inInvNumberBranch:= '';
     ELSE
         -- всегда 
         inInvNumberBranch:= TRIM (COALESCE (inInvNumberBranch, ''));
     END IF;

     /*IF inInvNumberBranch <> '6' -- !!!Одесса!!!
     THEN inInvNumberBranch:= '';
     END IF;*/
     

     -- поиск
     vbId:= (SELECT ObjectDate.ObjectId
             FROM ObjectDate
                  INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectDate.ObjectId AND ObjectString.DescId = zc_ObjectString_InvNumberTax_InvNumberBranch() AND ObjectString.ValueData = inInvNumberBranch
             WHERE ObjectDate.ValueData = vbOperDate AND ObjectDate.DescId = zc_ObjectDate_InvNumberTax_Value());

     IF COALESCE (vbId, 0) = 0
     THEN
         -- !!!для скорости - напрямую!!! добавили новый
         INSERT INTO Object (DescId, ObjectCode, ValueData)
            SELECT zc_Object_InvNumberTax(), CASE WHEN inInvNumber <> 0 THEN inInvNumber WHEN inInvNumberBranch <> '' THEN 1 WHEN vbOperDate >= '01.07.2015' THEN 1 ELSE 3800 END, '' RETURNING Id, ObjectCode INTO vbId, vbObjectCode;
         -- !!!для скорости - напрямую!!! добавили свойство
         INSERT INTO ObjectDate (DescId, ObjectId, ValueData)
                         VALUES (zc_ObjectDate_InvNumberTax_Value(), vbId, vbOperDate);
         -- !!!для скорости - напрямую!!! добавили свойство
         INSERT INTO ObjectString (DescId, ObjectId, ValueData)
                         VALUES (zc_ObjectString_InvNumberTax_InvNumberBranch(), vbId, inInvNumberBranch);
     ELSE
         -- изменили на inInvNumber или +1
         UPDATE Object SET ObjectCode = CASE WHEN inInvNumber <> 0 THEN inInvNumber ELSE ObjectCode + 1 END WHERE Id = vbId RETURNING ObjectCode INTO vbObjectCode;
     END IF;

     -- проверили
     IF 1 <> (SELECT COUNT(*)
              FROM ObjectDate
                   INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectDate.ObjectId AND ObjectString.DescId = zc_ObjectString_InvNumberTax_InvNumberBranch() AND ObjectString.ValueData = inInvNumberBranch
              WHERE ObjectDate.ValueData = vbOperDate AND ObjectDate.DescId = zc_ObjectDate_InvNumberTax_Value())
     THEN
         RAISE EXCEPTION 'Ошибка.Системная блокировка <Налоговый номер>, <%>  <%>.', vbOperDate, inInvNumberBranch;
     END IF;


     -- Возвращаем значение
     RETURN (vbObjectCode);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_InvNumberTax (Integer, TDateTime, TVarChar, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.05.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_InvNumberTax (inMovementDescId:= zc_Movement_Tax(), inOperDate:= '01.04.2014', inInvNumberBranch:= '', inInvNumber:= 0);

