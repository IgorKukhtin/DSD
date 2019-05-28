-- Function: gpUpdate_Report_UnLiquid_isSend()

DROP FUNCTION IF EXISTS gpUpdate_Report_UnLiquid_isSend(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Report_UnLiquid_isSend(
    IN inId              Integer   ,    -- 
    IN inisSend          Boolean   ,  
   OUT outisSend         Boolean   ,
    IN inSession         TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   outisSend:= inisSend;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.05.19         *
*/