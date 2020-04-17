-- Function: gpInsertUpdate_ObjectHistory_PersentSalary ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PersentSalary (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PersentSalary(
 INOUT ioId                 Integer,    -- ���� ������� <������� ������� % ����� ��>
    IN inRetailId           Integer,    -- ������� ����
    IN inOperDate           TDateTime,  -- ���� �������� %
    IN inPersentSalary       TFloat,     -- % ����� ��
    IN inSession            TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- ��������
   IF COALESCE (inRetailId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� <�������� ����>.';
   END IF;


   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PersentSalary(), inRetailId, inOperDate, vbUserId);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PersentSalary_Value(), ioId, inPersentSalary);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 16.04.20         *
*/
