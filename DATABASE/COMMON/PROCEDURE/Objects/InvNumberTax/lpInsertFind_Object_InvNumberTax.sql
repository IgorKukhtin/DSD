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

     -- ������ 1-� ����� ������
     vbOperDate:= DATE_TRUNC ('MONTH', inOperDate);

     -- �����
     vbId:= (SELECT ObjectId FROM ObjectDate WHERE ValueData = vbOperDate AND DescId = zc_ObjectDate_InvNumberTax_Value());

     IF COALESCE (vbId, 0) = 0
     THEN
         -- !!!��� �������� - ��������!!! �������� �����
         INSERT INTO Object (DescId, ObjectCode, ValueData)
            SELECT zc_Object_InvNumberTax(), CASE WHEN inInvNumber <> 0 THEN inInvNumber ELSE 3800 END, '' RETURNING Id, ObjectCode INTO vbId, vbObjectCode;
         -- !!!��� �������� - ��������!!! �������� ��������
         INSERT INTO ObjectDate (DescId, ObjectId, ValueData)
                         VALUES (zc_ObjectDate_InvNumberTax_Value(), vbId, vbOperDate);
     ELSE
         -- �������� �� inInvNumber ��� +1
         UPDATE Object SET ObjectCode = CASE WHEN inInvNumber <> 0 THEN inInvNumber ELSE ObjectCode + 1 END WHERE Id = vbId RETURNING ObjectCode INTO vbObjectCode;
     END IF;

     -- ���������
     IF 1 <> (SELECT COUNT(*) FROM ObjectDate WHERE ValueData = vbOperDate AND DescId = zc_ObjectDate_InvNumberTax_Value())
     THEN
         RAISE EXCEPTION '������.��������� ���������� <��������� �����>, <%>.', vbOperDate;
     END IF;


     -- ���������� ��������
     RETURN (vbObjectCode);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_InvNumberTax (Integer, TDateTime, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.05.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_InvNumberTax (inMovementDescId:= zc_Movement_Tax(), inOperDate:= '01.04.2014', inInvNumber:= 0);
-- SELECT * FROM lpInsertFind_Object_InvNumberTax (inMovementDescId:= zc_Movement_Tax(), inOperDate:= '01.04.2014');
