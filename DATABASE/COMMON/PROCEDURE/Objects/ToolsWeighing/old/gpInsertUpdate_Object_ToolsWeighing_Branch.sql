 DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ToolsWeighing_Branch (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ToolsWeighing_Branch(
    IN inScaleName               TVarChar  ,
    IN inScaleNameUser           TVarChar  ,
    IN inMovementDescCount       TVarChar  ,
    IN inServiceComPort          TVarChar  ,
    IN inServiceisPreviewPrint   TVarChar  ,
    IN inSession                 TVarChar
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId Integer;
   DECLARE vbScaleId Integer;
   DECLARE vbServiceId Integer;
   DECLARE vbMovementId Integer;

   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());
   vbId := 0; vbScaleId:= 0; vbServiceId := 0; vbMovementId:= 0;
   -- ������� Scale_X
   vbScaleId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, '', inScaleName, '', inScaleNameUser, 0, inSession);

   -- ������� Service
   vbServiceId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, '', 'Service', '', '���������', vbScaleId, inSession);
   -- ������� Service -> ComPort
   PERFORM gpInsertUpdate_Object_ToolsWeighing (0, 0, inServiceComPort, 'ComPort', '', '��� ����', vbServiceId, inSession);
   -- ������� Service -> isPreviewPrint
   PERFORM gpInsertUpdate_Object_ToolsWeighing (0, 0, inServiceisPreviewPrint, 'isPreviewPrint', '', '�������� ����� �������', vbServiceId, inSession);

   -- ������� Movement
   vbMovementId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, '', 'Movement', '', '���������', vbScaleId, inSession);
   -- ������� Movement -> DescCount
   PERFORM gpInsertUpdate_Object_ToolsWeighing (0, 0, inMovementDescCount, 'DescCount', '', '���������� ��������', vbServiceId, inSession);


   -- ������� Movement -> MovementDesc_X
--   PERFORM gpInsertUpdate_Object_ToolsWeighing (0, 0, inMovementDescCount, 'MovementDesc_1', '', '���������� ��������', vbServiceId, inSession);

  RETURN vbScaleId;




/*
   -- ���� ���������
   IF vbOldId <> ioId THEN
      -- ���������� �������� ����\����� � ����
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ToolsWeighing_Branch (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ToolsWeighing_Branch ('Scale_3', '������� ������ - ���������� ��3', '10', '1', 'false', '2');
