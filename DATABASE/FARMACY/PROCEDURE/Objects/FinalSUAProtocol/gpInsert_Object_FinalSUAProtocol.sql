-- Function: gpInsert_Object_FinalSUAProtocol()

DROP FUNCTION IF EXISTS gpInsert_Object_FinalSUAProtocol (TDateTime, TDateTime, Text, Text, TFloat, Integer, Integer, TFloat, boolean, boolean, boolean, boolean, boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_FinalSUAProtocol(
    IN inDateStart           TDateTime , -- ������ �������
    IN inDateEnd             TDateTime , -- ��������� �������
    IN inRecipientList       Text      , -- ������ ����������
    IN inAssortmentList      Text      , -- ������ ������������
    IN inThreshold           TFloat    , -- ����� ����������� ������
    IN inDaysStock           Integer   , -- ���� ������ � ����������
    IN inCountPharmacies     Integer   , -- ���. ���-�� ����� ������������
    IN inResolutionParameter TFloat    , -- ������. �������� ����������
    IN inisGoodsClose        boolean   , -- �� ���������� ������ ���
    IN inisMCSIsClose        boolean   , -- �� ���������� ���� ��� 
    IN inisNotCheckNoMCS     boolean   , -- �� ���������� ������� �� ��� ���
    IN inisMCSValue          boolean   , -- ��������� ����� � ��� > 0
    IN inisRemains           boolean   , -- ������� ���������� > 0
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode   Integer;   
   DECLARE vbId     Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;
   
   IF COALESCE(inRecipientList, '') = '' OR COALESCE(inAssortmentList, '') = ''
   THEN
     RAISE EXCEPTION '�� �������� ������ �������������';   
   END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode:=lfGet_ObjectCode (0, zc_Object_FinalSUAProtocol());
   
   -- ��������� <������>
   vbId := lpInsertUpdate_Object(0, zc_Object_FinalSUAProtocol(), vbCode, '');

   -- ���������
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_FinalSUAProtocol_OperDate(), vbId, CURRENT_TIMESTAMP);
   -- ���������
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_FinalSUAProtocol_DateStart(), vbId, inDateStart);
   -- ���������
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_FinalSUAProtocol_DateEnd(), vbId, inDateEnd);

   -- ���������
   PERFORM lpInsertUpdate_ObjectBlob (zc_objectBlob_FinalSUAProtocol_Recipient(), vbId, inRecipientList);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBlob (zc_objectBlob_FinalSUAProtocol_Assortment(), vbId, inAssortmentList);

   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_FinalSUAProtocol_Threshold(), vbId, inThreshold);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_FinalSUAProtocol_DaysStock(), vbId, inDaysStock);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_FinalSUAProtocol_CountPharmacies(), vbId, inCountPharmacies);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter(), vbId, inResolutionParameter);


   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_GoodsClose(), vbId, inisGoodsClose);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_MCSIsClose(), vbId, inIsMCSIsClose);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_NotCheckNoMCS(), vbId, inIsNotCheckNoMCS);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_MCSValue(), vbId, inisMCSValue);
   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_FinalSUAProtocol_Remains(), vbId, inisRemains);

   -- ��������� ����� � <������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_FinalSUAProtocol_User(), vbId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.03.21                                                       *
*/

-- select * from gpInsert_Object_FinalSUAProtocol(inDateStart := ('01.10.2020')::TDateTime , inDateEnd := ('31.10.2020')::TDateTime , inRecipientList := '183292' , inAssortmentList := '472116,1781716,6309262' , inThreshold := 1 , inDaysStock := 10, inPercentPharmacies := 75,  inSession := '3');