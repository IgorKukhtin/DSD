-- Function: lpInsertFind_Object_InvNumberTax

DROP FUNCTION IF EXISTS lpInsertFind_Object_InvNumberTax (Integer, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertFind_Object_InvNumberTax (Integer, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_InvNumberTax(
    IN inMovementDescId          Integer            , -- 
    IN inOperDate                TDateTime          , -- 
    IN inInvNumberBranch         TVarChar  , -- ����� �������
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

     -- � 01.01.2016 ������� �� �������� �� �����
     IF vbOperDate >= '01.01.2016'
     THEN 
         inInvNumberBranch:= '';
     ELSE
         -- ������ 
         inInvNumberBranch:= TRIM (COALESCE (inInvNumberBranch, ''));
     END IF;

     /*IF inInvNumberBranch <> '6' -- !!!������!!!
     THEN inInvNumberBranch:= '';
     END IF;*/
     

     -- �����
     vbId:= (SELECT ObjectDate.ObjectId
             FROM ObjectDate
                  INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectDate.ObjectId AND ObjectString.DescId = zc_ObjectString_InvNumberTax_InvNumberBranch() AND ObjectString.ValueData = inInvNumberBranch
             WHERE ObjectDate.ValueData = vbOperDate AND ObjectDate.DescId = zc_ObjectDate_InvNumberTax_Value());

     IF COALESCE (vbId, 0) = 0
     THEN
         -- !!!��� �������� - ��������!!! �������� �����
         INSERT INTO Object (DescId, ObjectCode, ValueData)
            SELECT zc_Object_InvNumberTax(), CASE WHEN inInvNumber <> 0 THEN inInvNumber WHEN inInvNumberBranch <> '' THEN 1 WHEN vbOperDate >= '01.07.2015' THEN 1 ELSE 3800 END, '' RETURNING Id, ObjectCode INTO vbId, vbObjectCode;
         -- !!!��� �������� - ��������!!! �������� ��������
         INSERT INTO ObjectDate (DescId, ObjectId, ValueData)
                         VALUES (zc_ObjectDate_InvNumberTax_Value(), vbId, vbOperDate);
         -- !!!��� �������� - ��������!!! �������� ��������
         INSERT INTO ObjectString (DescId, ObjectId, ValueData)
                         VALUES (zc_ObjectString_InvNumberTax_InvNumberBranch(), vbId, inInvNumberBranch);
     ELSE
         -- �������� �� inInvNumber ��� +1
         UPDATE Object SET ObjectCode = CASE WHEN inInvNumber <> 0 THEN inInvNumber ELSE ObjectCode + 1 END WHERE Id = vbId RETURNING ObjectCode INTO vbObjectCode;
     END IF;

     -- ���������
     IF 1 <> (SELECT COUNT(*)
              FROM ObjectDate
                   INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectDate.ObjectId AND ObjectString.DescId = zc_ObjectString_InvNumberTax_InvNumberBranch() AND ObjectString.ValueData = inInvNumberBranch
              WHERE ObjectDate.ValueData = vbOperDate AND ObjectDate.DescId = zc_ObjectDate_InvNumberTax_Value())
     THEN
         RAISE EXCEPTION '������.��������� ���������� <��������� �����>, <%>  <%>.', vbOperDate, inInvNumberBranch;
     END IF;


     -- ���������� ��������
     RETURN (vbObjectCode);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_InvNumberTax (Integer, TDateTime, TVarChar, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.05.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_InvNumberTax (inMovementDescId:= zc_Movement_Tax(), inOperDate:= '01.04.2014', inInvNumberBranch:= '', inInvNumber:= 0);

