-- Function: gpUpdate_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpUpdate_Object_RecalcMCSSheduler(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_RecalcMCSSheduler(
    IN inId                      Integer   ,   	-- ���� ������� <>
    IN inSelectRun               Boolean,
   OUT outSelectRun              Boolean,
    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;
   DECLARE RetailId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;
   
   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION '������. �������� �� ��������..';
   END IF;

   --���������
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_RecalcMCSSheduler_SelectRun(), inId, inSelectRun);
   
   outSelectRun := COALESCE((SELECT ObjectBoolean.ValueData FROM ObjectBoolean 
                             WHERE ObjectBoolean.ObjectID = inId
                               AND ObjectBoolean.DescId = zc_ObjectBoolean_RecalcMCSSheduler_SelectRun()), False);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_RecalcMCSSheduler(Integer, Boolean, TVarChar) OWNER TO postgres;


------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.19                                                       *
 21.12.18                                                       *

*/