-- Function: gpUpdate_Object_Maker_SendDate (Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Maker_SendDate (Integer,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Maker_SendDate(
 INOUT ioId              Integer   ,    -- ���� ������� <�������������>
    IN inAddMonth        Integer   ,    -- �������� ����� � ��������
    IN inAddDay          Integer   ,    -- �������� ��� � ��������
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSendPlan TDateTime;    
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession; 

   IF not EXISTS(SELECT * FROM Object WHERE Object.DescId = zc_Object_Maker() and Object.Id = ioId)
   THEN
        RAISE EXCEPTION '������.������������� �� ������.'; 
   END IF;

   IF EXISTS(SELECT * FROM ObjectDate WHERE ObjectDate.DescId = zc_ObjectDate_Maker_SendPlan() and ObjectDate.ObjectId = ioId)
   THEN
     SELECT 
       ObjectDate.ValueData
     INTO
       vbSendPlan
     FROM ObjectDate 
     WHERE ObjectDate.DescId = zc_ObjectDate_Maker_SendPlan() and ObjectDate.ObjectId = ioId;
     
     IF COALESCE (inAddDay, 0) = 0 
     THEN
       IF COALESCE (inAddMonth, 0) <> 0 
       THEN
         vbSendPlan := vbSendPlan + inAddMonth * interval '1 month';
       ELSE
         vbSendPlan := vbSendPlan + interval '1 month';       
       END IF;
     ELSE
       IF COALESCE (inAddDay, 0) = 15 or COALESCE (inAddDay, 0) = 14
       THEN
         IF date_part('day', vbSendPlan) < (inAddDay + 1)
         THEN
           vbSendPlan := vbSendPlan + inAddDay * interval '1 day';     
         ELSE
           vbSendPlan := vbSendPlan - inAddDay * interval '1 day';     
           vbSendPlan := vbSendPlan + interval '1 month';         
         END IF;
       ELSE
         vbSendPlan := vbSendPlan + inAddDay * interval '1 day';     
       END IF;
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendPlan(), ioId, vbSendPlan);
     
   END IF;

   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendReal(), ioId, CURRENT_TIMESTAMP);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.19                                                       *
 25.01.19                                                       *
 
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Maker_SendDate()