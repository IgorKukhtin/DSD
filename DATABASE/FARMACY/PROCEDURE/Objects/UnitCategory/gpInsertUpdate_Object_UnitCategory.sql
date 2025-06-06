-- Function: gpInsertUpdate_Object_UnitCategory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UnitCategory (Integer, Integer, TVarChar, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitCategory(
 INOUT ioId                        Integer,   -- ���� ������� <>
    IN inCode                      Integer,   -- ��� �������
    IN inName                      TVarChar,  -- �������� �������
    IN inPenaltyNonMinPlan         TFloat,    -- % ������ �� ������������ ������������ �����
    IN inPremiumImplPlan           TFloat,    -- % ������ �� ���������� ����� ������
    IN inMinLineByLineImplPlan     TFloat,    -- ����������� % ����������� ���������� ������������ ����� ��� ��������� ������
    IN inScaleCalcMarketingPlanId  Integer,   -- ����� ������� ������/������ � ���� �� ����������
    IN inSession                   TVarChar   -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_UnitCategory());
   vbUserId := inSession;
  
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_UnitCategory());

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_UnitCategory(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_UnitCategory(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_UnitCategory(), vbCode_calc, inName);

   -- % ������ �� ������������ ������������ �����
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan(), ioId, inPenaltyNonMinPlan);

   -- % ������ �� ���������� ����� ������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_UnitCategory_PremiumImplPlan(), ioId, inPremiumImplPlan);
 
   -- ����������� % ����������� ���������� ������������ ����� ��� ��������� ������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan(), ioId, inMinLineByLineImplPlan);

   -- ��������� ����� � <����� ������� ������/������ � ���� �� ����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan(), ioId, inScaleCalcMarketingPlanId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������ �.�.
 15.05.18         *
 05.05.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_UnitCategory(ioId:=null, inCode:=null, inName:='������ 1', inSession:='3')