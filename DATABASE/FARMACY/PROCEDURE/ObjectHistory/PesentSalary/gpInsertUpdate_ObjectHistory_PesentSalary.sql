-- Function: gpInsertUpdate_ObjectHistory_PesentSalary ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PesentSalary (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PesentSalary(
 INOUT ioId                 Integer,    -- ���� ������� <������� ������� % ����� ��>
    IN inRetailId           Integer,    -- ������� ����
    IN inOperDate           TDateTime,  -- ���� �������� %
    IN inPesentSalary       TFloat,     -- % ����� ��
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
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PesentSalary(), inRetailId, inOperDate, vbUserId);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PesentSalary_Value(), ioId, inPesentSalary);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 16.04.20         *
*/
