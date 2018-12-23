-- Function: gpInsertUpdate_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(
 INOUT ioId                      Integer   ,   	-- ���� ������� <������� �����������>
 INOUT ioCode                    Integer   ,    -- ��� ������� <������� �����������>
    IN inUnitId                  Integer, 
    IN inWeekId                  Integer, 
    IN inUserId                  Integer, 
    IN inIsClose                 Boolean,
    IN inSession                 TVarChar       -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;
   
   IF COALESCE(inUnitId, 0) = 0
   THEN
     RAISE EXCEPTION '������. �� ��������� �������������..';   
   END IF;
   
   IF COALESCE(inWeekId, 0) < 1 OR COALESCE(inWeekId, 0) > 7
   THEN
     RAISE EXCEPTION '������. �� ������ ���� ������..';   
   END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_RecalcMCSSheduler());
   vbName := '����������� �������� ��� '||ioCode::TVarChar;

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_RecalcMCSSheduler(), vbName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RecalcMCSSheduler(), ioCode);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RecalcMCSSheduler(), ioCode, vbName, NULL);

   -- ��������� ����� � <���� ��. ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_Unit(), ioId, inUnitId);

   --��������� 
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RecalcMCSSheduler_Week(), ioId, inWeekId);

   -- ��������� ����� � <�����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_User(), ioId, inUserId);

   -- ��������
   UPDATE Object SET isErased = inIsClose WHERE Id = ioId;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RecalcMCSSheduler(Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.12.18                                                       *

*/
